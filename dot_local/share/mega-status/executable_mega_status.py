#!/usr/bin/env python3
"""MEGA sync status tray icon.

Publishes a StatusNotifierItem whose icon reflects mega-cmd's own view of sync
health. Detection is event-driven: an inotify watch on ~/.megaCmd acts as a
kernel activity bell, and mega-cmd is consulted as the authoritative oracle only
once that bell rings, so nothing is queried while MEGA is genuinely idle.

Strictly read-only. Nothing here writes to ~/.megaCmd or to any synced folder,
and no mega-cmd command is ever invoked with a mutating flag. The mega-* client
wrappers auto-spawn mega-cmd-server when it is absent, so a live server is
confirmed via /proc before any command runs -- a stopped server stays stopped.
"""

import collections
import csv
import ctypes
import ctypes.util
import enum
import logging
import os
import subprocess
import sys

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("AyatanaAppIndicator3", "0.1")
gi.require_version("GLibUnix", "2.0")

from gi.repository import AyatanaAppIndicator3 as AppIndicator  # noqa: E402
from gi.repository import GLib, GLibUnix, Gtk  # noqa: E402

APP_ID = "mega-status"
ICON_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "icons")
WATCH_DIR = os.path.expanduser("~/.megaCmd")
SERVER_COMM = "mega-cmd-server"

# Coalescing window for the activity bell. Events arriving while a check is
# already scheduled fold into it rather than pushing it back, so continuous
# transfer chatter can never starve the check indefinitely.
DEBOUNCE_MS = 200

# Transfers in flight are re-checked on this interval until they drain. The bell
# tells us work started, but nothing guarantees a final event lands after the
# last transfer completes, which would latch the icon on "syncing" forever.
# Armed only while actively syncing -- at rest, and while degraded, no timer runs.
SETTLE_MS = 1000
SETTLE_MAX_FAILURES = 5

COMMAND_TIMEOUT_S = 5

# Raise to DEBUG to trace the activity bell and every probe result.
LOG_LEVEL = os.environ.get("MEGA_STATUS_LOG_LEVEL", "INFO").upper()

IN_MODIFY = 0x00000002
O_NONBLOCK = 0o4000
O_CLOEXEC = 0o2000000
EVENT_BUF_SIZE = 4096

# STATUS values meaning the engine still has work in flight, or cannot yet say.
BUSY_STATUS = frozenset({"Syncing", "Pending", "Processing", "NONE"})
SYNC_COLUMNS = ("LOCALPATH", "RUN_STATE", "STATUS", "ERROR")

log = logging.getLogger(APP_ID)


class State(enum.Enum):
    """Display states. Values are icon basenames under ICON_DIR."""

    SYNCED = "synced"
    SYNCING = "syncing"
    DEGRADED = "degraded"


LABELS = {
    State.SYNCED: "MEGA — synced",
    State.SYNCING: "MEGA — syncing…",
    State.DEGRADED: "MEGA — needs attention",
}

# state: overall icon to show; detail: per-sync lines for the hover tooltip.
Snapshot = collections.namedtuple("Snapshot", "state detail")


def server_running():
    """True when a mega-cmd-server process is live.

    Checked before every probe: the mega-* wrappers would otherwise start the
    server on our behalf, which this daemon must never do.
    """
    for entry in os.scandir("/proc"):
        if not entry.name.isdigit():
            continue
        try:
            with open(os.path.join(entry.path, "comm")) as handle:
                if handle.read().strip() == SERVER_COMM:
                    return True
        except OSError:
            continue  # process exited mid-scan, or not ours to read
    return False


def _run(args):
    """Run a read-only mega-cmd query, returning stdout or None on failure."""
    try:
        return subprocess.run(
            args,
            capture_output=True,
            text=True,
            timeout=COMMAND_TIMEOUT_S,
            check=True,
        ).stdout
    except (OSError, subprocess.SubprocessError) as exc:
        log.warning("%s failed: %s", args[0], exc)
        return None


def _has_sync_issues():
    """True only when mega-cmd positively reports outstanding sync issues.

    A failed probe reports False: this guards the reassuring "synced" claim, and
    an unreadable probe is not evidence of a problem worth alarming about.
    """
    out = _run(["mega-sync-issues"])
    if out is None:
        return False
    return "no sync issues" not in out.lower()


def _describe(row):
    """One hover line for a sync, naming the worst thing true of it."""
    name = os.path.basename(row["LOCALPATH"].rstrip("/")) or row["LOCALPATH"]
    if row["ERROR"] != "NO":
        return f"{name}: {row['ERROR']}"
    if row["RUN_STATE"] != "Running":
        return f"{name}: {row['RUN_STATE'].lower()}"
    return f"{name}: {row['STATUS'].lower()}"


def read_snapshot():
    """Collapse every configured sync into one Snapshot, or None if undetermined.

    Precedence is worst-first: one broken sync outweighs healthy ones, and
    "synced" is claimed only when mega-cmd also reports no outstanding issues.
    """
    if not server_running():
        log.info("%s is not running", SERVER_COMM)
        return Snapshot(State.DEGRADED, f"{SERVER_COMM} is not running")

    out = _run(
        ["mega-sync", "--output-cols=" + ",".join(SYNC_COLUMNS), "--col-separator=,"]
    )
    if out is None:
        return None

    reader = csv.DictReader(out.splitlines())
    if not reader.fieldnames or not set(SYNC_COLUMNS) <= set(reader.fieldnames):
        log.warning("unexpected mega-sync columns: %s", reader.fieldnames)
        return None

    rows = list(reader)
    if not rows:
        log.warning("mega-sync reports no configured syncs")
        return None

    detail = "\n".join(_describe(row) for row in rows)
    broken = any(
        row["ERROR"] != "NO" or row["RUN_STATE"] != "Running" for row in rows
    )
    if broken:
        return Snapshot(State.DEGRADED, detail)
    if any(row["STATUS"] in BUSY_STATUS for row in rows):
        return Snapshot(State.SYNCING, detail)
    if _has_sync_issues():
        return Snapshot(State.DEGRADED, detail + "\nsync issues reported")
    return Snapshot(State.SYNCED, detail)


class InotifyWatch:
    """Kernel-driven activity bell over one directory, wired into the GLib loop.

    Raw ctypes rather than a binding, to keep the daemon on stock Arch packages.
    """

    def __init__(self, path, on_activity):
        self._on_activity = on_activity
        libc_name = ctypes.util.find_library("c") or "libc.so.6"
        self._libc = ctypes.CDLL(libc_name, use_errno=True)
        self._libc.inotify_init1.argtypes = [ctypes.c_int]
        self._libc.inotify_init1.restype = ctypes.c_int
        self._libc.inotify_add_watch.argtypes = [
            ctypes.c_int,
            ctypes.c_char_p,
            ctypes.c_uint32,
        ]
        self._libc.inotify_add_watch.restype = ctypes.c_int

        self._fd = self._libc.inotify_init1(O_NONBLOCK | O_CLOEXEC)
        if self._fd < 0:
            raise OSError(ctypes.get_errno(), "inotify_init1 failed")

        if self._libc.inotify_add_watch(self._fd, os.fsencode(path), IN_MODIFY) < 0:
            err = ctypes.get_errno()
            os.close(self._fd)
            raise OSError(err, f"inotify_add_watch failed for {path}")

        GLibUnix.fd_add_full(
            GLib.PRIORITY_DEFAULT, self._fd, GLib.IOCondition.IN, self._on_readable
        )

    def _on_readable(self, fd, _condition):
        self._drain(fd)
        self._on_activity()
        return GLib.SOURCE_CONTINUE

    @staticmethod
    def _drain(fd):
        """Discard event payloads -- only the fact that something happened matters."""
        while True:
            try:
                if not os.read(fd, EVENT_BUF_SIZE):
                    return
            except BlockingIOError:
                return


class MegaStatus:
    """Tray indicator driven by the activity bell and the mega-sync oracle."""

    def __init__(self):
        self._snapshot = None
        self._debounce_id = 0
        self._settle_id = 0
        self._settle_failures = 0

        self._status_item = Gtk.MenuItem(label="…")
        self._status_item.set_sensitive(False)
        self._detail_items = []

        self._indicator = AppIndicator.Indicator.new(
            APP_ID,
            State.SYNCED.value,
            AppIndicator.IndicatorCategory.APPLICATION_STATUS,
        )
        self._indicator.set_icon_theme_path(ICON_DIR)
        self._indicator.set_title("MEGA")
        self._indicator.set_menu(self._build_menu())
        self._indicator.set_status(AppIndicator.IndicatorStatus.ACTIVE)

        self._watch = InotifyWatch(WATCH_DIR, self._on_activity)
        self._refresh()

    def _build_menu(self):
        """Header, then one live line per sync, then Quit.

        The menu -- not the tooltip -- is the detail surface: AstalTray reads an
        item's ToolTip once at creation and ignores NewToolTip, so hover text is
        frozen forever under HyprPanel. dbusmenu pushes updates, so the menu
        stays truthful. The tooltip is still published for other SNI hosts.
        """
        self._menu = Gtk.Menu()
        self._menu.append(self._status_item)
        self._detail_separator = Gtk.SeparatorMenuItem()
        self._menu.append(self._detail_separator)
        quit_item = Gtk.MenuItem(label="Quit")
        quit_item.connect("activate", lambda _item: Gtk.main_quit())
        self._menu.append(quit_item)
        self._menu.show_all()
        return self._menu

    def _update_detail_items(self, lines):
        """Grow/shrink the per-sync rows in place, keeping dbusmenu churn minimal."""
        while len(self._detail_items) < len(lines):
            item = Gtk.MenuItem()
            item.set_sensitive(False)
            self._menu.insert(item, 1 + len(self._detail_items))
            item.show()
            self._detail_items.append(item)
        while len(self._detail_items) > len(lines):
            self._menu.remove(self._detail_items.pop())
        for item, line in zip(self._detail_items, lines):
            item.set_label(line)

    def _on_activity(self):
        log.debug("activity bell (check already scheduled: %s)", bool(self._debounce_id))
        if self._debounce_id:
            return
        self._debounce_id = GLib.timeout_add(DEBOUNCE_MS, self._on_debounce_elapsed)

    def _on_debounce_elapsed(self):
        self._debounce_id = 0
        self._refresh()
        return GLib.SOURCE_REMOVE

    def _refresh(self):
        snapshot = read_snapshot()
        log.debug("probe -> %s", snapshot)
        if snapshot is None:
            return
        self._apply(snapshot)
        if snapshot.state is State.SYNCING:
            self._arm_settle()

    def _arm_settle(self):
        if self._settle_id:
            return
        self._settle_failures = 0
        self._settle_id = GLib.timeout_add(SETTLE_MS, self._on_settle_tick)

    def _on_settle_tick(self):
        snapshot = read_snapshot()
        if snapshot is None:
            self._settle_failures += 1
            if self._settle_failures < SETTLE_MAX_FAILURES:
                return GLib.SOURCE_CONTINUE
            log.warning(
                "settle loop giving up after %d failed probes", self._settle_failures
            )
            self._settle_id = 0
            return GLib.SOURCE_REMOVE

        self._settle_failures = 0
        self._apply(snapshot)
        if snapshot.state is State.SYNCING:
            return GLib.SOURCE_CONTINUE
        self._settle_id = 0
        return GLib.SOURCE_REMOVE

    def _apply(self, snapshot):
        if snapshot == self._snapshot:
            return
        icon_changed = (
            self._snapshot is None or snapshot.state is not self._snapshot.state
        )
        self._snapshot = snapshot

        label = LABELS[snapshot.state]
        if icon_changed:
            self._indicator.set_icon_full(snapshot.state.value, label)
            log.info("state -> %s", snapshot.state.value)
        self._indicator.set_tooltip_full(snapshot.state.value, label, snapshot.detail)
        self._status_item.set_label(label)
        self._update_detail_items(snapshot.detail.splitlines())


def main():
    logging.basicConfig(
        level=getattr(logging, LOG_LEVEL, logging.INFO),
        format="%(levelname)s %(message)s",
        stream=sys.stderr,
    )
    if not os.path.isdir(WATCH_DIR):
        log.error("%s does not exist -- is mega-cmd installed and logged in?", WATCH_DIR)
        return 1

    app = MegaStatus()  # noqa: F841 -- must outlive the main loop
    Gtk.main()
    return 0


if __name__ == "__main__":
    sys.exit(main())
