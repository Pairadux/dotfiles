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
--   ALT + F<n>
--
-- No CTRL or SHIFT anywhere, deliberately. A bind only consumes its trigger key --
-- modifier presses still reach the focused window, so a CTRL chord reads as crouch
-- in a game and SHIFT as sprint. ALT leaks the same way, reading as lean, so only
-- the bare bank is silent. The modifier does no other work here: the Voyager sends
-- the whole chord as one key, so a bare F-key is just as unambiguous.
--
-- The tradeoff is the other direction: Hyprland grabs these globally, so an
-- assigned key is gone from every app. Known casualties if you assign them --
-- F12 (Steam screenshot, still on its default here; also browser devtools),
-- F11 (browser fullscreen), F5 (browser reload), F5/F9 (quicksave/quickload in
-- some games), ALT + F4 (close window), ALT + period (shell's last argument).
-- F13..F24 have no such baggage; nothing claims them.
--
-- Values are slot names from `pwsp-cli get hotkeys`. The sound each slot plays
-- stays configured in pwsp; only the trigger lives here. Add a line to bind a key
-- -- an unassigned one is left alone, both to keep it available to apps and so a
-- stray press cannot fire play-hotkey against a slot that does not exist. Leave
-- the slots' own key chords unset (`pwsp-cli action clear-hotkey-key "<slot>"`)
-- so a press cannot fire twice.
--
-- `hl` is a Hyprland global, so it needs no import.
local plain = {
    F1 = "outro-song",
    F2 = "anime-ahh",
    F3 = "rizzbot-laugh",
    F4 = "sponge-bob-disgusting",
    F5 = "shut-up-lois",
    F6 = "fart-with-reverb",
    F7 = "daddys-home",
    F8 = "spongebob-fail",
    F9 = "faaah",
    F10 = "vine-boom",
    F11 = "gopgopgop",
    F12 = "fnaf2-jumpscare",
    F13 = "ceeday-huh",
    F14 = "no-no-wait-wait",
    F15 = "hes-grippin-me",
    F16 = "m-e-o-w",
    F17 = "snore-mimimimimimi",
    F18 = "lobotomy",
    F19 = "let-her-go",
    F23 = "redvid_io_tom_proudly_eats_his_diarrhea_hd",
    -- F20, F21, F22 and F24 belong to the cassette binds in hyprland.lua.

    -- UNBOUND: replace KEY with an F-key
    -- KEY = "please-bro",
    -- KEY = "baby-laughing-meme",
    -- KEY = "prowler",
    -- KEY = "deg-deg-sussy",
    -- KEY = "999-social-credit-siren",
    -- KEY = "ack",
    -- KEY = "among-us-role-reveal",
    -- KEY = "applepay",
    -- KEY = "charlie-kirky-funk",
    -- KEY = "core",
    -- KEY = "ding",
    -- KEY = "discord-leave-noise",
    -- KEY = "fbi-open-up",
    -- KEY = "gah-dayum",
    -- KEY = "gta-san-andreas-abertura-oficial",
    -- KEY = "gta-san-andreas-ah-shit-here-we-go-again",
    -- KEY = "gta-v-death-sound-effect",
    -- KEY = "gta-v-notification",
    -- KEY = "ho-ho-ho-ben",
    -- KEY = "homer-lets-the-barts-out",
    -- KEY = "i-farted-and-a-poopy-almost-slipped-out",
    -- KEY = "indian-song",
    -- KEY = "italian-brainrot-ringtone",
    -- KEY = "jet2hoilday-indian",
    -- KEY = "man-snoring-meme",
    -- KEY = "naruto-sad-music-instant",
    -- KEY = "oh-pwincess-where-are-you",
    -- KEY = "peter-griffin-who-the-hell-cares",
    -- KEY = "punch-gaming",
    -- KEY = "rip-my-granny-loud-asf",
    -- KEY = "shocked",
    -- KEY = "spiderman-polyester-edit",
    -- KEY = "talking-ben-sound",
    -- KEY = "undertakers-bell",
    -- KEY = "we-are-charlie-kirk-song",
    -- KEY = "what-the-hell-meme",
    -- KEY = "wide-putin",
    -- KEY = "wrong-answer-buzzer",
    -- KEY = "yara-yara-phonk",
    -- KEY = "yes-king-who-did-that-mess",
    -- KEY = "yippeeeeeeeeeeeeee",
    -- KEY = "yooooooooooooooooooooooooo",
    -- KEY = "yo-phone-ringing-chino",
    -- KEY = "dbd_check_start",
    -- KEY = "having-sex-w-everyone",
    -- KEY = "i-just-hit-the-jackpot",
}

-- Labels for the bare keys the cassette binds hold. Only the cheat sheet reads this;
-- the binds themselves stay in hyprland.lua.
local cassette = {
    F20 = "save clip",
    F21 = "clip list",
    F22 = "trim clip",
    F24 = "play clip",
}

-- What the Voyager sends for the second bank and the thumb keys.
local mod = "ALT"

local alt = {
    F1 = "smoke-detector-beep",
    F2 = "animatronic-in-door",
    F3 = "talking-ben-saying-ben",
    F4 = "rizz",
    F5 = "talkingg-benn-laughh",
    F6 = "what-bottom-text-meme-sanctuary-guardian-sound",
    F7 = "talking-benn-ughhh",
    F8 = "dexter-meme",
    F9 = "talking-benn-yes",
    F10 = "long-brain-fart",
    F11 = "talking-bennnn-noo",
    F12 = "tuco-get-out",
    F13 = "i_have_sex_in_front_of_my_kids",
    F14 = "they-jumpin-me",
    F15 = "awkward-cricket",
    F16 = "zinc",
    F17 = "sybau",
    F18 = "the-men-riff",
    F19 = "yes-king-you-digging-in",
    F20 = "oh-my-god-bro-oh-hell-nah-man",
    F21 = "what-a-good-boy",
    F22 = "perfect-fart",
    period = "scoreboard-family-guy",
    comma = "pluh",
    bracketleft = "duolingo-wrong",
    bracketright = "correct",
}

-- Stops playback; lives outside the banks, so it costs no F-key slot. The Voyager
-- sends this one with SUPER rather than the banks' modifier.
local stopChord = "SUPER + backspace"


-- This layout gives F13..F24 XF86* keysyms rather than F-key ones, and Hyprland's
-- Lua config matches binds by keysym, so a bind written as F13 never fires.
-- Binding by keycode is not the way out: the Lua parser stores code:N as
-- NoSymbol+N and the match short-circuits on the keysym half, so it never fires
-- for a key that has a keysym at all (hyprwm/Hyprland#14819). These are the
-- keysyms the compiled keymap actually emits, so the tables above stay readable.
-- ALT does not shift the level of any key bound here, so both banks share them.
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

local function resolve(key)
    return highF[key] or key
end

--- Binds both banks and the stop key. Called from hyprland.lua; `hl` is a Hyprland
--- global and only exists at that point.
local function setup()
    local banks = {
        [""]  = plain,
        [mod] = alt,
    }

    for mods, slots in pairs(banks) do
        for key, slot in pairs(slots) do
            local chord = mods ~= "" and (mods .. " + " .. resolve(key)) or resolve(key)
            hl.bind(chord, hl.dsp.exec_cmd('pwsp-cli action play-hotkey "' .. slot .. '"'))
        end
    end

    hl.bind(stopChord, hl.dsp.exec_cmd("pwsp-cli action stop"))
end

-- The banks are exported so the cheat sheet can draw the same tables Hyprland
-- binds from, instead of re-parsing this file.
return {
    plain = plain,
    alt = alt,
    cassette = cassette,
    mod = mod,
    stopChord = stopChord,
    setup = setup,
}
