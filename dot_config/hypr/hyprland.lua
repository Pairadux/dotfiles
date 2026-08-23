------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080", position = "320x-1080", scale = 1, transform = 2 })
-- TEMP VERTICAL MONITOR
hl.monitor({ output = "HDMI-A-2", mode = "1920x1080", position = "-720x0", scale = 1.5, transform = 1 })

---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "ghostty"
local fileManager = "ghostty -e yazi"
local menu        = "rofi -show drun"
local browser     = "zen-browser"
local lockscreen  = "hyprlock"
local pdfViewer   = "zathura"
local noteTaker   = "~/.config/hypr/scripts/notetaker.sh"
local picker      = "~/.config/hypr/scripts/picker.sh"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd(lockscreen)
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("dunst")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hyprpanel")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("systemctl --user start mega-status")
    hl.exec_cmd("gametrak")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "radeonsi")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("XDG_DATA_DIRS",
    "/var/lib/flatpak/exports/share:" ..
    os.getenv("HOME") .. "/.local/share/flatpak/exports/share:" ..
    "/usr/local/share:/usr/share")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 8,

        border_size = 2,

        col = {
            active_border   = "rgba(f7768eff)",
            inactive_border = "rgba(565f89cc)",
        },

        resize_on_border = true,
        allow_tearing    = true,

        layout = "dwindle",
    },

    decoration = {
        rounding = 10,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled           = true,
            size              = 6,
            passes            = 3,
            new_optimizations = true,
            ignore_opacity    = true,
            xray              = false,

            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper   = 0,
        disable_hyprland_logo     = true,
        on_focus_under_fullscreen = 2,
        focus_on_activate         = false,
    },

    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "ctrl:nocaps",
        kb_rules   = "",

        follow_mouse  = 1,
        mouse_refocus = false,

        sensitivity = -0.25, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },

    cursor = {
        hide_on_key_press = true,
    },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + T", hl.dsp.focus({ workspace = 20 }))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.focus({ workspace = 30 }))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + D", hl.dsp.focus({ workspace = 40 }))
hl.bind(mainMod .. " + S", hl.dsp.focus({ workspace = 50 }))
hl.bind(mainMod .. " + M", hl.dsp.focus({ workspace = 60 }))
hl.bind(mainMod .. " + O", hl.dsp.focus({ workspace = 70 }))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(pdfViewer))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(noteTaker))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("qimgv"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("nwg-drawer -nofs -ovl -wm hyprland -k -c 8 -is 64 -spacing 16"))

hl.bind(mainMod .. " + C", hl.dsp.window.close())

hl.bind(mainMod .. " + HOME", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + HOME", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

hl.bind(mainMod .. " + SHIFT + PAUSE", hl.dsp.exec_cmd(lockscreen))

-- Hyprshot
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))

-- Picker
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(picker))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(picker .. " playlist"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd(picker .. " clipboard"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(picker .. " wallpaper"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd(picker .. " note"))

-- Media (mpc)
hl.bind(mainMod .. " + ALT + SPACE", hl.dsp.exec_cmd("mpc toggle"))
hl.bind(mainMod .. " + RIGHT", hl.dsp.exec_cmd("mpc next"))
hl.bind(mainMod .. " + LEFT", hl.dsp.exec_cmd("mpc prev"))
hl.bind(mainMod .. " + UP", hl.dsp.exec_cmd("mpc volume +5"))
hl.bind(mainMod .. " + DOWN", hl.dsp.exec_cmd("mpc volume -5"))

hl.bind(mainMod .. " + V", hl.dsp.window.float())

-- Toggle split orientation: side-by-side <-> top/bottom
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.layout("togglesplit"))

-- ALT + Tab remake but only works inside workspace
hl.bind(mainMod .. " + Tab", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + Tab", hl.dsp.window.bring_to_top())

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

-- Move window with mainMod + SHIFT + hjkl
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

-- Switch to / move window to workspaces 1-10
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + G", hl.dsp.focus({ workspace = 100 }))

hl.bind(mainMod .. " + SHIFT + D", hl.dsp.window.move({ workspace = 40 }))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.move({ workspace = 60 }))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.window.move({ workspace = 70 }))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({ workspace = 100 }))

-- Special Workspaces
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + ALT + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Neovide
hl.window_rule({
    name  = "neovide",
    match = { class = "neovide" },

    monitor = "DP-2",
    float   = true,
    size    = { 1920, 1080 },
})

-- Notetaker capture
hl.window_rule({
    name  = "notetaker",
    match = { title = "^(Notetaker)$" },

    float  = true,
    center = true,
    size   = { 1000, 700 },
})

-- Mega
hl.window_rule({
    name  = "mega",
    match = { class = "MEGA" },

    float            = true,
    render_unfocused = true,
})

-- Zoom
hl.window_rule({
    name  = "zoom-menu",
    match = { class = "zoom", initial_title = "(menu window)" },

    stay_focused = true,
})

-- Discord
hl.window_rule({
    name  = "discord",
    match = { class = "discord" },

    workspace = "40",
    monitor   = "HDMI-A-1",
})

-- Steam Client
hl.window_rule({
    name  = "steam-main",
    match = { class = "^(steam)$" },

    workspace = "50",
    monitor   = "DP-2",
})

-- Steam - Subwindows (everything except main Steam window)
hl.window_rule({
    name  = "steam-subwindows",
    match = { class = "^(steam)$", title = "negative:^Steam$" },

    float = true,
})

-- Steam - Known Popup/Dialog Bugs
hl.window_rule({
    name  = "steam-popups",
    match = { class = "^(steam)$", title = "^()$" },

    min_size = { 1, 1 },
})

-- Steam Games
-- gametrak writes $game_regex into games.conf in the old hyprlang format; read it
-- back out here since Lua configs have no `source` keyword.
local function game_regex(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local contents = f:read("a")
    f:close()
    return contents:match("%$game_regex%s*=%s*([^\n]+)")
end

local games = game_regex(os.getenv("HOME") .. "/.config/gametrak/games.conf")
if games then
    hl.window_rule({
        name  = "steam-games",
        match = { class = games },

        workspace    = "100",
        monitor      = "DP-2",
        fullscreen   = true,
        immediate    = true,
        idle_inhibit = "always",
    })
end

-- GIMP
hl.window_rule({
    name  = "gimp-dialogs",
    match = { class = "^(script-fu|file-.*)$" },
    float = true,
})

hl.window_rule({
    name  = "gimp-preferences",
    match = { class = "^(org\\.gimp\\.GIMP)$", title = "^(Preferences)$" },
    float = true,
})

-- XDG Desktop Portal
hl.window_rule({
    name  = "xdg-portal",
    match = { class = "^(xdg-desktop-portal-gtk)$" },
    float = true,
})

-- GODOT Engine Test Window
hl.window_rule({
    name  = "godot-runner",
    match = { title = ".*DEBUG.*" },
    float = true,
})

-- Default
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.workspace_rule({ workspace = "1", monitor = "DP-2", default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1", on_created_empty = "ticktick" })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1", on_created_empty = "spotify" })
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1" })
hl.workspace_rule({
    workspace   = "100",
    monitor     = "DP-2",
    gaps_in     = 0,
    gaps_out    = 0,
    no_border   = true,
    no_rounding = true,
})

hl.workspace_rule({ workspace = "20", monitor = "DP-2", on_created_empty = terminal })
hl.workspace_rule({ workspace = "30", monitor = "HDMI-A-1", on_created_empty = browser })
hl.workspace_rule({ workspace = "40", monitor = "HDMI-A-1", on_created_empty = "gtk-launch discord" })
hl.workspace_rule({ workspace = "50", monitor = "DP-2", on_created_empty = "gtk-launch steam" })
hl.workspace_rule({ workspace = "60", monitor = "HDMI-A-1", on_created_empty = "gtk-launch com.fastmail.Fastmail" })
hl.workspace_rule({ workspace = "70", monitor = "HDMI-A-1", on_created_empty = "obsidian" })
