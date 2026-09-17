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
-- Two chord banks, both emitted as single keys by the Voyager:
--   ALT + SHIFT + F1..F22
--   SUPER + ALT + SHIFT + F1..F24
--
-- Only assigned keys are bound. Hyprland grabs a chord globally, so an entry here
-- takes that chord away from every app -- leave a key out rather than parking a
-- placeholder on it. F13 and up are the safest: they exist on no standard
-- keyboard, so nothing else claims them. ALT + SHIFT + F1..F12 overlaps IntelliJ
-- (Shift+Alt+F10 Run..., Shift+Alt+F9 Debug...), so prefer the SUPER bank there.
--
-- Values are slot names from `pwsp-cli get hotkeys`. The sound each slot plays
-- stays configured in pwsp; only the trigger lives here. Leave the slots' own key
-- chords unset (`pwsp-cli action clear-hotkey-key "<slot>"`) so a press cannot
-- fire twice.
--
-- `hl` is a Hyprland global, so it needs no import; `mod` is passed in because
-- mainMod is a local in hyprland.lua.

local altShift = {
    -- F13..F22 recommended here; F1..F12 collide with IDE shortcuts.
}

local metaAltShift = {
    F1 = "Goofy Running Sound Effect [qbnyaJAbP1U]",
}

-- Stops playback; costs one slot out of the SUPER bank.
local stopKey = "F24"

return function(mod)
    local banks = {
        ["ALT + SHIFT"]           = altShift,
        [mod .. " + ALT + SHIFT"] = metaAltShift,
    }

    for mods, slots in pairs(banks) do
        for key, slot in pairs(slots) do
            hl.bind(mods .. " + " .. key,
                hl.dsp.exec_cmd('pwsp-cli action play-hotkey "' .. slot .. '"'))
        end
    end

    hl.bind(mod .. " + ALT + SHIFT + " .. stopKey, hl.dsp.exec_cmd("pwsp-cli action stop"))
end
