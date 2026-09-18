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

-- F12 is deliberately absent from both banks: no key on the Voyager sends
-- it, so a binding there could never fire.
local plain = {
    F1 = "punch-gaming-sound-effect-hd_RzlG1GE",
    F2 = "rizzbot-laugh",
    F3 = "rizz-sound-effect",
    F4 = "shocked-sound-effect",
    F5 = "shut-up-lois",
    F6 = "smoke-detector-beep",
    F7 = "snore-mimimimimimi",
    F8 = "spongebob-fail",
    F9 = "tmp_7901-951678082",
    F10 = "tuco-get-out",
    F11 = "undertakers-bell_2UwFCIe",
    F13 = "999-social-credit-siren",
    F14 = "ack",
    F15 = "among-us-role-reveal-sound",
    F16 = "anime-ahh",
    F17 = "applepay",
    F18 = "awkward-cricket-sound-effect",
    F19 = "baby-laughing-meme",
    F20 = "ceeday-huh-sound-effect",
    F21 = "core-sound-effect",
    F22 = "correct",
    F23 = "daddys-home",
    F24 = "deg-deg-sussy",

    -- UNBOUND: replace KEY with an F-key
    -- KEY = "let-her-go",
    -- KEY = "vine-boom",
    -- KEY = "yippeeeeeeeeeeeeee",
    -- KEY = "yo-phone-ringing-chino",
}

local meta = {
    F1 = "dexter-meme",
    F2 = "ding-sound-effect_2",
    F3 = "faaah",
    F4 = "fart-with-reverb",
    F5 = "gah-dayum",
    F6 = "gopgopgop",
    F7 = "gta-v-notification",
    F8 = "homer-lets-the-barts-out",
    F9 = "i-farted-and-a-poopy-almost-slipped-out",
    F10 = "indian-song",
    F11 = "italian-brainrot-ringtone",
    F13 = "lobotomy-sound-effect",
    F14 = "long-brain-fart",
    F15 = "man-snoring-meme_ctrllNn",
    F16 = "m-e-o-w",
    F17 = "no-no-wait-wait",
    F18 = "oh-my-god-bro-oh-hell-nah-man",
    F19 = "outro-song_oqu8zAg",
    F20 = "perfect-fart",
    F21 = "please-bro",
    F22 = "pluh",
    F23 = "prowler-sound-effect_6bXErot",
    period = "we-are-charlie-kirk-phone",
    comma = "what-a-good-boy",
    bracketleft = "what-bottom-text-meme-sanctuary-guardian-sound-effect-hd",
    bracketright = "what-the-hell-meme-sound-effect",
}

-- Stops playback; lives outside the banks, so it costs no F-key slot.
local stopKey = "backspace"


-- This layout gives F13..F24 XF86* keysyms rather than F-key ones, and Hyprland's
-- Lua config matches binds by keysym, so a bind written as F13 never fires.
-- Binding by keycode is not the way out: the Lua parser stores code:N as
-- NoSymbol+N and the match short-circuits on the keysym half, so it never fires
-- for a key that has a keysym at all (hyprwm/Hyprland#14819). These are the
-- keysyms the compiled keymap actually emits, so the tables above stay readable.
local highF = {
    F13 = "XF86Tools",
    F14 = "XF86Launch5",
    F15 = "XF86Launch6",
    F16 = "XF86Launch7",
    F17 = "XF86Launch8",
    F18 = "XF86Launch9",
    F19 = "F19",
    F20 = "XF86AudioMicMute",
    F21 = "XF86TouchpadToggle",
    F22 = "XF86TouchpadOn",
    F23 = "F23",
    F24 = "F24",
}

-- FK23 and FK24 are typed PC_SHIFT_SUPER_LEVEL2 and PC_CONTROL_SUPER_LEVEL2, so
-- holding SUPER shifts them to a second level and a different keysym arrives.
local highFSuper = {
    F23 = "XF86Assistant",
    F24 = "XF86TouchpadToggle",
}

local function resolve(key, mods)
    if mods ~= "" and highFSuper[key] then
        return highFSuper[key]
    end
    return highF[key] or key
end

return function(mod)
    local banks = {
        [""]  = plain,
        [mod] = meta,
    }

    for mods, slots in pairs(banks) do
        for key, slot in pairs(slots) do
            local chord = mods ~= "" and (mods .. " + " .. resolve(key, mods)) or resolve(key, "")
            hl.bind(chord, hl.dsp.exec_cmd('pwsp-cli action play-hotkey "' .. slot .. '"'))
        end
    end

    hl.bind(mod .. " + " .. resolve(stopKey, mod), hl.dsp.exec_cmd("pwsp-cli action stop"))
end
