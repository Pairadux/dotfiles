#!/usr/bin/env lua
--------------------------------
---- SOUNDBOARD CHEAT SHEET ----
--------------------------------

-- Draws soundboard.lua as an SVG shaped like the Voyager, so a sound can be found
-- by reaching for where it sits under your hands rather than by reading a list.
--
-- The banks come from `require("soundboard")`, the same tables hyprland.lua binds,
-- so the picture cannot drift from the keymap. Requiring it outside Hyprland is
-- safe: the `hl` global is only touched inside setup(), which this never calls.
--
-- It requires whichever soundboard.lua sits beside its own directory, so running
-- it from the chezmoi source tree reads the source config and refreshes the
-- committed soundboard.svg:
--
--   lua ~/.dotfiles/dot_config/hypr/scripts/executable_soundboard-cheatsheet.lua \
--       -o ~/.dotfiles/dot_config/hypr/soundboard.svg
--
-- SVG out only -- rsvg-convert or magick will make a PNG if a viewer wants one.

local here = arg[0]:match("^(.*)/[^/]*$") or "."
package.path = here .. "/../?.lua;" .. package.path
local board = require("soundboard")

---------------------
---- GEOMETRY -------
---------------------

-- Lifted off an Oryx screenshot of the layout and scaled up until a slot name is
-- legible: the pitches, the per-column stagger and the thumb cluster's 30 degrees
-- are the real board's, just bigger.
local KEY_W, KEY_H = 164, 144
local COL_PITCH, ROW_PITCH = 180, 160
local HALF_GAP = 520
local MARGIN = 48

local STAGGER = {
    { 0, 0, -26, -54, -20, 0 },  -- left half: ring and middle fingers reach up
    { 0, -20, -54, -26, 0, 0 },  -- right half mirrors it
}

local RIGHT_X = 6 * COL_PITCH + HALF_GAP
local BOARD_W = RIGHT_X + 5 * COL_PITCH + KEY_W

--- Mirrors an x across the gap between the halves, so the right thumb cluster is
--- placed by reflecting the left one rather than by a second set of magic numbers.
--- @param x number
--- @return number
local function mirror(x)
    return BOARD_W - x
end

-- Centres are measured from the top-left of the left half's first key.
local THUMBS = {
    { cx = 1031, cy = 790, w = KEY_W, h = KEY_H, rot = 30, key = "period", chord = "SUPER + ." },
    { cx = 1165, cy = 912, w = KEY_W, h = KEY_H * 1.6, rot = 30, key = "bracketleft", chord = "SUPER + [" },
    { cx = mirror(1031), cy = 790, w = KEY_W, h = KEY_H, rot = -30, key = "comma", chord = "SUPER + ," },
    { cx = mirror(1165), cy = 912, w = KEY_W, h = KEY_H * 1.6, rot = -30, key = "bracketright", chord = "SUPER + ]" },
}

---------------------
---- PALETTE --------
---------------------

local BG = "#0f172a"
local KEY_FILL = "#1e293b"
local NAME = "#e2e8f0"
local MUTED = "#64748b"
local FONT = "'Fira Sans','DejaVu Sans',sans-serif"

local KINDS = {
    plain = { stroke = "#38bdf8", label = "#7dd3fc" },
    meta  = { stroke = "#a78bfa", label = "#c4b5fd" },
    stop  = { stroke = "#4ade80", label = "#86efac" },
    dead  = { stroke = "#334155", label = MUTED },
}

---------------------
---- TEXT FITTING ---
---------------------

-- No text measurement in plain Lua, so widths are estimated per glyph class. The
-- error only has to be small enough that fit() lands on a size that does not spill.
local NARROW = { i = 0.32, l = 0.32, j = 0.32, t = 0.38, f = 0.38, r = 0.40, ["-"] = 0.36, ["."] = 0.30, [" "] = 0.28 }
local WIDE = { m = 0.87, w = 0.78, M = 0.87, W = 0.87 }

--- @param s string
--- @param size number
--- @return number
local function width(s, size)
    local ems = 0
    for ch in s:gmatch(".") do
        ems = ems + (NARROW[ch] or WIDE[ch] or 0.55)
    end
    return ems * size
end

--- Splits a kebab-case slot into chunks that keep their trailing dash, so a wrap
--- lands after the hyphen where a reader expects the break.
--- @param s string
--- @return string[]
local function chunks(s)
    local out = {}
    for chunk in s:gmatch("[^-]*%-?") do
        if chunk ~= "" then out[#out + 1] = chunk end
    end
    return out
end

--- @param s string
--- @param size number
--- @param maxW number
--- @return string[]
local function wrap(s, size, maxW)
    local lines, line = {}, ""
    for _, chunk in ipairs(chunks(s)) do
        local merged = line .. chunk
        if line ~= "" and width(merged, size) > maxW then
            lines[#lines + 1] = line
            line = chunk
        else
            line = merged
        end
    end
    if line ~= "" then lines[#lines + 1] = line end
    return lines
end

--- Largest size at or below `maxSize` that keeps the string on one line.
--- @param s string
--- @param maxW number
--- @param maxSize number
--- @return number
local function fitLine(s, maxW, maxSize)
    local size = maxSize
    while size > 9 and width(s, size) > maxW do size = size - 1 end
    return size
end

--- Largest size at which the wrapped slot name still fits the box.
--- @param s string
--- @param maxW number
--- @param maxH number
--- @return string[], number
local function fit(s, maxW, maxH)
    for size = 30, 12, -1 do
        local lines = wrap(s, size, maxW)
        local fits = #lines * size * 1.16 <= maxH
        for _, line in ipairs(lines) do
            fits = fits and width(line, size) <= maxW
        end
        if fits then return lines, size end
    end
    return wrap(s, 12, maxW), 12
end

---------------------
---- SVG ------------
---------------------

local svg = {}

--- @param s string
--- @return string
local function esc(s)
    return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function emit(fmt, ...)
    svg[#svg + 1] = select("#", ...) > 0 and fmt:format(...) or fmt
end

--- @param x number
--- @param y number
--- @param s string
--- @param size number
--- @param fill string
--- @param opts table|nil anchor, weight, spacing
local function text(x, y, s, size, fill, opts)
    opts = opts or {}
    emit('<text x="%.1f" y="%.1f" font-size="%d" fill="%s" text-anchor="%s"%s%s>%s</text>',
        x, y, size, fill, opts.anchor or "middle",
        opts.weight and (' font-weight="' .. opts.weight .. '"') or "",
        opts.spacing and (' letter-spacing="' .. opts.spacing .. '"') or "",
        esc(s))
end

--- One key: rounded cap, its chord along the top, the slot name filling the rest.
--- Drawn around its own centre so the rotated thumb keys need no special case.
--- @param k table cx, cy, w, h, rot, chord, slot, kind
local function key(k)
    local c = KINDS[k.kind]
    emit('<g transform="translate(%.1f,%.1f) rotate(%d)">', k.cx, k.cy, k.rot or 0)
    emit('<rect x="%.1f" y="%.1f" width="%.1f" height="%.1f" rx="14" fill="%s" stroke="%s" stroke-width="2.5"/>',
        -k.w / 2, -k.h / 2, k.w, k.h, KEY_FILL, c.stroke)

    local top = -k.h / 2
    text(0, top + 28, k.chord, fitLine(k.chord, k.w - 20, 19), c.label, { weight = 600, spacing = "0.5" })

    local lines, size = fit(k.slot, k.w - 22, k.h - 58)
    local block = #lines * size * 1.16
    local y = top + 42 + (k.h - 54 - block) / 2 + size * 0.86
    for _, line in ipairs(lines) do
        text(0, y, line, size, k.kind == "dead" and MUTED or NAME)
        y = y + size * 1.16
    end
    emit("</g>")
end

---------------------
---- COMPOSE --------
---------------------

--- Every physical key, in board coordinates. A column carries one odd/even F-key
--- pair: the top two rows send it with SUPER, the bottom two send it bare.
--- @return table[]
local function keys()
    local out = {}
    for half = 1, 2 do
        local originX = half == 1 and 0 or RIGHT_X
        for col = 1, 6 do
            local first = (half - 1) * 12 + (col - 1) * 2 + 1
            local cells = {
                { bank = board.meta, n = first, kind = "meta", prefix = "SUPER + " },
                { bank = board.meta, n = first + 1, kind = "meta", prefix = "SUPER + " },
                { bank = board.plain, n = first, kind = "plain", prefix = "" },
                { bank = board.plain, n = first + 1, kind = "plain", prefix = "" },
            }
            for row, cell in ipairs(cells) do
                local name = "F" .. cell.n
                local slot = cell.bank[name]
                local k = {
                    cx = originX + (col - 1) * COL_PITCH + KEY_W / 2,
                    cy = STAGGER[half][col] + (row - 1) * ROW_PITCH + KEY_H / 2,
                    w = KEY_W,
                    h = KEY_H,
                    chord = cell.prefix .. name,
                    slot = slot,
                    kind = cell.kind,
                }
                -- The meta bank stops at F22, so the last column's top two keys are
                -- the layer key and the stop key instead -- exactly as Oryx shows them.
                if not slot and cell.kind == "meta" then
                    if row == 1 then
                        k.chord, k.slot, k.kind = "Index", "layer key", "dead"
                    else
                        k.chord, k.slot, k.kind = "SUPER + " .. board.stopKey, "stop playback", "stop"
                    end
                end
                out[#out + 1] = k
            end
        end
    end

    for _, t in ipairs(THUMBS) do
        out[#out + 1] = {
            cx = t.cx, cy = t.cy, w = t.w, h = t.h, rot = t.rot,
            chord = t.chord, slot = board.meta[t.key], kind = "meta",
        }
    end
    return out
end

--- Title and legend, dropped into the gap between the halves.
local function legend()
    local x, y = 6 * COL_PITCH + HALF_GAP / 2, 26
    local bound = 0
    for _ in pairs(board.plain) do bound = bound + 1 end
    for _ in pairs(board.meta) do bound = bound + 1 end

    text(x, y, "SOUNDBOARD", 52, NAME, { weight = 700, spacing = "3" })
    text(x, y + 38, bound .. " sounds bound \u{00b7} pwsp", 22, MUTED)

    local rows = {
        { kind = "plain", head = "F1 - F24", body = "bare F-key" },
        { kind = "meta", head = "SUPER + F1 - F22", body = "and the four thumb keys" },
        { kind = "stop", head = "SUPER + " .. board.stopKey, body = "stop playback" },
    }

    -- One width for all three chips, set by the widest line so none of them clip.
    local chipW = 0
    for _, r in ipairs(rows) do
        chipW = math.max(chipW, width(r.head, 21), width(r.body, 18))
    end
    chipW = chipW + 44

    y = y + 108
    for _, r in ipairs(rows) do
        local c = KINDS[r.kind]
        emit('<rect x="%.1f" y="%.1f" width="%.1f" height="74" rx="12" fill="%s" stroke="%s" stroke-width="2.5"/>',
            x - chipW / 2, y, chipW, KEY_FILL, c.stroke)
        text(x, y + 32, r.head, 21, c.label, { weight = 600 })
        text(x, y + 58, r.body, 18, MUTED)
        y = y + 100
    end
end

--- Slots pwsp holds that no key fires yet, asked of the daemon rather than kept by
--- hand so a newly added sound shows up here without touching the config. Empty if
--- the daemon is not running. The reply is `true : {json}`; slot names are the only
--- field needed, so they are matched out instead of pulling in a JSON parser.
--- @return string[]
local function unbound()
    local bound = {}
    for _, bank in ipairs({ board.plain, board.meta }) do
        for _, slot in pairs(bank) do bound[slot] = true end
    end

    local pipe = io.popen("pwsp-cli get hotkeys 2>/dev/null")
    local reply = pipe and pipe:read("a") or ""
    if pipe then pipe:close() end

    local free = {}
    for slot in reply:gmatch('"slot":"([^"]+)"') do
        if not bound[slot] then free[#free + 1] = slot end
    end
    table.sort(free)
    return free
end

--- @param top number
--- @return number bottom
local function freeSlots(top)
    local free = unbound()
    if #free == 0 then return top end
    text(0, top, "UNASSIGNED", 22, MUTED, { anchor = "start", weight = 700, spacing = "3" })

    local x, y, pad, gap = 0, top + 30, 18, 12
    for _, slot in ipairs(free) do
        local w = width(slot, 20) + pad * 2
        if x + w > BOARD_W then
            x, y = 0, y + 52
        end
        emit('<rect x="%.1f" y="%.1f" width="%.1f" height="40" rx="10" fill="%s" stroke="%s" stroke-width="2"/>',
            x, y, w, KEY_FILL, KINDS.dead.stroke)
        text(x + w / 2, y + 27, slot, 20, MUTED)
        x = x + w + gap
    end
    return y + 40
end

local function render()
    local all = keys()

    -- Rotated thumb keys stick out past the grid, so the canvas is sized from what
    -- was actually drawn rather than from the row and column counts.
    local bottom, top = 0, 0
    for _, k in ipairs(all) do
        local rad = math.rad(k.rot or 0)
        local reach = (math.abs(k.w * math.sin(rad)) + math.abs(k.h * math.cos(rad))) / 2
        bottom = math.max(bottom, k.cy + reach)
        top = math.min(top, k.cy - reach)
    end

    for _, k in ipairs(all) do key(k) end
    legend()
    local body = table.concat(svg)

    svg = {}
    local footTop = bottom + 70
    local footBottom = freeSlots(footTop)
    local foot = table.concat(svg)

    local h = (footBottom - top) + MARGIN * 2
    return table.concat({
        string.format(
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="%.1f %.1f %.1f %.1f" width="%.0f" height="%.0f" font-family="%s">',
            -MARGIN, top - MARGIN, BOARD_W + MARGIN * 2, h, BOARD_W + MARGIN * 2, h, FONT),
        string.format('<rect x="%.1f" y="%.1f" width="%.1f" height="%.1f" fill="%s"/>',
            -MARGIN, top - MARGIN, BOARD_W + MARGIN * 2, h, BG),
        body, foot, "</svg>\n",
    }, "\n")
end

local out = io.stdout
if arg[1] == "-o" then
    out = assert(io.open(arg[2], "w"))
elseif arg[1] then
    io.stderr:write("usage: ", arg[0], " [-o FILE]\n")
    os.exit(1)
end
out:write(render())
if out ~= io.stdout then out:close() end
