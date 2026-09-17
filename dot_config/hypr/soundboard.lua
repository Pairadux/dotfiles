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
-- Two chord banks, both emitted as single keys by the Voyager, F1..F24 each:
--   SUPER + ALT + SHIFT + F<n>
--   SUPER + CTRL + SHIFT + F<n>
--
-- Both carry SUPER, which is what actually keeps a chord safe: apps leave SUPER
-- to the compositor by convention, so the whole F1..F24 range is usable. Plain
-- ALT+SHIFT is app territory (it collides with IntelliJ's Shift+Alt+F10 Run and
-- Shift+Alt+F9 Debug), and CTRL+ALT+SHIFT sits one dropped modifier away from
-- CTRL+ALT+F<n>, which Hyprland routes to switchVT.
--
-- Values are slot names from `pwsp-cli get hotkeys`. The sound each slot plays
-- stays configured in pwsp; only the trigger lives here. Add a line to bind a
-- chord -- an unassigned one is left alone so a stray press cannot fire
-- play-hotkey against a slot that does not exist. Leave the slots' own key chords
-- unset (`pwsp-cli action clear-hotkey-key "<slot>"`) so a press cannot fire twice.
--
-- `hl` is a Hyprland global, so it needs no import; `mod` is passed in because
-- mainMod is a local in hyprland.lua.

local altShift = {
    F1 = "Goofy Running Sound Effect [qbnyaJAbP1U]",
}

local ctrlShift = {
}

-- Stops playback; costs one slot out of the ALT bank.
local stopKey = "F24"

return function(mod)
    local banks = {
        [mod .. " + ALT + SHIFT"]  = altShift,
        [mod .. " + CTRL + SHIFT"] = ctrlShift,
    }

    for mods, slots in pairs(banks) do
        for key, slot in pairs(slots) do
            hl.bind(mods .. " + " .. key,
                hl.dsp.exec_cmd('pwsp-cli action play-hotkey "' .. slot .. '"'))
        end
    end

    hl.bind(mod .. " + ALT + SHIFT + " .. stopKey, hl.dsp.exec_cmd("pwsp-cli action stop"))
end
