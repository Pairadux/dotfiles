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
-- `slots` keys are Hyprland keys, values are slot names from `pwsp-cli get hotkeys`.
-- The sound each slot plays stays configured in the pwsp GUI; only the trigger
-- lives here. Leave the slots' own key chords unset (`pwsp-cli action
-- clear-hotkey-key "<slot>"`) so a press cannot fire twice.
--
-- `hl` is a Hyprland global, so it needs no import; `mod` is passed in because
-- mainMod is a local in hyprland.lua.

local slots = {
    F1 = "Goofy Running Sound Effect [qbnyaJAbP1U]",
}

local stopKey = "BACKSPACE"

return function(mod)
    for key, slot in pairs(slots) do
        hl.bind(mod .. " + ALT + " .. key,
            hl.dsp.exec_cmd('pwsp-cli action play-hotkey "' .. slot .. '"'))
    end

    hl.bind(mod .. " + ALT + " .. stopKey, hl.dsp.exec_cmd("pwsp-cli action stop"))
end
