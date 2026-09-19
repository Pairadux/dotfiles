--- Keycap hints for the sound banks in hypr/soundboard.lua.
---
--- The banks are keyed by F-key because that is what the Voyager emits, but no
--- F-key is printed on the board: the layout puts each one under an ordinary key.
--- Reading the file otherwise means translating F17 into K in your head. These
--- hints render the physical cap beside each slot as virtual text, so they live
--- outside the file -- nothing to go stale when a sound moves between slots, and
--- nothing for `set-soundboard-items` to parse around.

-- The layout as measured on the keyboard, recorded verbatim:
--
--   meta+f1:  `        meta+f13: 6           f1:  esc      f13: h
--   meta+f2:  -        meta+f14: y           f2:  alt      f14: n
--   meta+f3:  1        meta+f15: 7           f3:  a        f15: j
--   meta+f4:  q        meta+f16: u           f4:  z        f16: m
--   meta+f5:  2        meta+f17: 8           f5:  s        f17: k
--   meta+f6:  w        meta+f18: i           f6:  x        f18: ,
--   meta+f7:  3        meta+f19: 9           f7:  d        f19: l
--   meta+f8:  e        meta+f20: o           f8:  c        f20: .
--   meta+f9:  4        meta+f21: 0           f9:  f        f21: ;
--   meta+f10: r        meta+f22: p           f10: v        f22: /
--   meta+f11: 5        meta+f23: unbound     f11: g        f23: '
--   meta+f12: t        meta+f24: unbound     f12: b        f24: caps
--
--   meta+,: enter      meta+[: l_big
--   meta+.: space      meta+]: r_big
--
-- Drawn as written above, except that single letters are capitalised and
-- esc/alt/caps/enter/space/l_big/r_big get symbols.

local M = {}

--- Physical cap under each slot, by bank and by the key the bank binds. Raw
--- rather than pretty: `cap` below decides how a token is drawn, so this stays a
--- record of the hardware.
local LAYOUT = {
    plain = {
        F1 = 'esc',
        F2 = 'alt',
        F3 = 'a',
        F4 = 'z',
        F5 = 's',
        F6 = 'x',
        F7 = 'd',
        F8 = 'c',
        F9 = 'f',
        F10 = 'v',
        F11 = 'g',
        F12 = 'b',
        F13 = 'h',
        F14 = 'n',
        F15 = 'j',
        F16 = 'm',
        F17 = 'k',
        F18 = ',',
        F19 = 'l',
        F20 = '.',
        F21 = ';',
        F22 = '/',
        F23 = "'",
        F24 = 'caps',
    },
    meta = {
        F1 = '`',
        F2 = '-',
        F3 = '1',
        F4 = 'q',
        F5 = '2',
        F6 = 'w',
        F7 = '3',
        F8 = 'e',
        F9 = '4',
        F10 = 'r',
        F11 = '5',
        F12 = 't',
        F13 = '6',
        F14 = 'y',
        F15 = '7',
        F16 = 'u',
        F17 = '8',
        F18 = 'i',
        F19 = '9',
        F20 = 'o',
        F21 = '0',
        F22 = 'p',
        F23 = 'unbound',
        F24 = 'unbound',
        comma = 'enter',
        period = 'space',
        bracketleft = 'l_big',
        bracketright = 'r_big',
    },
}

--- Tokens that read better as their symbol than as their name. Every one of
--- these is present in FiraCode Nerd Font Mono, checked rather than assumed.
local SYMBOLS = {
    esc = '⎋',
    alt = '⎇',
    caps = '↑',
    enter = '⏎',
    space = '␣',
    l_big = '←',
    r_big = '→',
}

--- Caps take Comment's colour but never its italics. Italics are a separate font
--- family (VictorMono here, against FiraCode for upright), and it has no glyph
--- for several of these symbols -- the terminal falls back to some other font
--- mid-line and the column stops lining up.
local function define_highlights()
    for name, source in pairs { SoundboardKeycap = 'Comment', SoundboardKeycapUnbound = 'DiagnosticWarn' } do
        local hl = vim.api.nvim_get_hl(0, { name = source, link = false })
        vim.api.nvim_set_hl(0, name, { fg = hl.fg, italic = false })
    end
end

define_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
    desc = 'Keep the soundboard keycap hints upright across colourscheme changes',
    callback = define_highlights,
})

--- How a cap is drawn: a symbol where one exists, capitals for the letters so
--- they stand out from the sounds, and otherwise exactly what the layout records,
--- so a hint can be matched to the board without a diagram.
--- @param raw string
--- @return string
local function cap(raw)
    if SYMBOLS[raw] then
        return SYMBOLS[raw]
    end
    if raw:match '^%a$' then
        return raw:upper()
    end
    return raw
end

local ns = vim.api.nvim_create_namespace 'soundboard-keycaps'

--- Draw the cap beside every live slot, in a column so the banks read like a
--- keyboard. Commented-out binds are left bare on purpose: the key plays nothing
--- while the line is commented, and a cap there would say otherwise.
--- @param buf integer
function M.render(buf)
    local util = require 'util'
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    local hints, column = {}, 0
    for bank, caps in pairs(LAYOUT) do
        local first, last = util.table_range(lines, bank)
        if first then
            for row = first, last do
                local line = lines[row]
                local _, key = util.split_assignment(line)
                local raw = not line:match '^%s*%-%-' and key and caps[key]
                if raw then
                    hints[#hints + 1] = { row = row, raw = raw, width = #line }
                    column = math.max(column, #line)
                end
            end
        end
    end

    for _, hint in ipairs(hints) do
        vim.api.nvim_buf_set_extmark(buf, ns, hint.row - 1, 0, {
            virt_text = {
                { string.rep(' ', column - hint.width + 2) },
                { cap(hint.raw), hint.raw == 'unbound' and 'SoundboardKeycapUnbound' or 'SoundboardKeycap' },
            },
            virt_text_pos = 'eol',
            hl_mode = 'combine',
        })
    end
end

--- Render now, and again on every change: the caps are anchored to keys, which
--- never move, but rewriting a line detaches its mark and inserting one shifts
--- every slot below it.
---
--- `on_lines` rather than TextChanged, which does not fire for the API edits the
--- slot moves make from inside a mapping -- the caps drift by a row the first
--- time a sound is moved. Redrawing is deferred because a buffer callback may not
--- touch the buffer it fires for, and coalesced so a multi-line edit redraws once.
--- @param buf integer
function M.attach(buf)
    if vim.b[buf].soundboard_keycaps then
        return
    end
    vim.b[buf].soundboard_keycaps = true

    M.render(buf)

    local pending = false
    vim.api.nvim_buf_attach(buf, false, {
        on_lines = function()
            if not vim.api.nvim_buf_is_valid(buf) then
                return true
            end
            if pending then
                return
            end
            pending = true
            vim.schedule(function()
                pending = false
                if vim.api.nvim_buf_is_valid(buf) then
                    M.render(buf)
                end
            end)
        end,
    })
end

return M
