--------------------
---- SOUNDBOARD ----
--------------------

-- Keybindings for pwsp (pipewire-soundpad).
--
-- pwsp's own "universal hotkeys" read /dev/input/event* directly, which needs the
-- `input` group and only picks up keyboards the daemon saw when it started, so a
-- boot race loses them. Binding through the compositor needs no extra privileges
-- and survives hotplug.
--
-- Two banks, both emitted as single keys by the Voyager, F1..F24 each:
--   F<n>           (no modifier)
--   SUPER + F<n>
--
-- No CTRL, SHIFT or ALT anywhere, deliberately. A bind only consumes its trigger
-- key -- modifier presses still reach the focused window, so a CTRL chord reads as
-- crouch in a game, SHIFT as sprint, ALT as lean. The modifier was never doing any
-- work here anyway: the Voyager sends the whole chord as one key, so a bare F-key
-- is just as unambiguous and leaks nothing.
--
-- The tradeoff is the other direction: Hyprland grabs these globally, so an
-- assigned key is gone from every app. Known casualties if you assign them --
-- F12 (Steam screenshot, still on its default here; also browser devtools),
-- F11 (browser fullscreen), F5 (browser reload), F5/F9 (quicksave/quickload in
-- some games). F13..F24 have no such baggage; nothing claims them.
--
-- Values are slot names from `pwsp-cli get hotkeys`. The sound each slot plays
-- stays configured in pwsp; only the trigger lives here. Add a line to bind a key
-- -- an unassigned one is left alone, both to keep it available to apps and so a
-- stray press cannot fire play-hotkey against a slot that does not exist. Leave
-- the slots' own key chords unset (`pwsp-cli action clear-hotkey-key "<slot>"`)
-- so a press cannot fire twice.
--
-- `hl` is a Hyprland global, so it needs no import; `mod` is passed in because
-- mainMod is a local in hyprland.lua.

local plain = {
    F13 = "Goofy Running Sound Effect [qbnyaJAbP1U]",
}

local meta = {
}

-- Stops playback; costs one slot out of the SUPER bank.
local stopKey = "F24"

return function(mod)
    local banks = {
        [""]  = plain,
        [mod] = meta,
    }

    for mods, slots in pairs(banks) do
        for key, slot in pairs(slots) do
            local chord = mods ~= "" and (mods .. " + " .. key) or key
            hl.bind(chord, hl.dsp.exec_cmd('pwsp-cli action play-hotkey "' .. slot .. '"'))
        end
    end

    hl.bind(mod .. " + " .. stopKey, hl.dsp.exec_cmd("pwsp-cli action stop"))
end
