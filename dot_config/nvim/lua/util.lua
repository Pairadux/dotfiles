local M = {}

function M.insert_title()
    -- grab commentstring prefix
    local cs = vim.bo.commentstring:match '^(.-)%%s' or vim.bo.commentstring
    cs = cs:gsub('%s*$', '')

    -- prompt
    local title = vim.fn.input 'Enter title: '
    if title == '' then
        return
    end

    local top, mid, bot
    if vim.bo.filetype == 'lua' then
        -- fixed-width break style for lua
        local border = string.rep('-', 60)
        top = cs .. border
        mid = cs .. ' ' .. title
        bot = top
    else
        -- dynamic box style for everything else
        local inner = #title + 2
        local border = string.rep('-', inner)
        top = cs .. ' +' .. border .. '+'
        mid = cs .. ' | ' .. title .. ' |'
        bot = top
    end

    -- insert and restore cursor
    vim.api.nvim_put({ top, mid, bot }, 'l', true, true)
    local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local last = vim.api.nvim_buf_line_count(0)
    if r == last then
        vim.api.nvim_buf_set_lines(0, last, last, false, { '' })
    end
    vim.api.nvim_win_set_cursor(0, { r + 1, 0 })

    -- center and drop into insert
    vim.cmd 'normal! zz'
    vim.cmd 'startinsert'
end

function M.insert_line_break()
    local cs = vim.bo.commentstring:match '^(.-)%%s' or vim.bo.commentstring
    cs = cs:gsub('%s*$', '')

    local prefix = cs .. ' '
    local prefix_len = #prefix

    local total_width = 80

    local fill_width = total_width - prefix_len
    if fill_width < 0 then
        fill_width = 0
    end

    local break_line = prefix .. string.rep('#', fill_width)

    vim.api.nvim_put({ break_line }, 'l', true, true)
end

function M.squeeze_interior_whitespace()
    -- Exit visual mode
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)

    -- Get 0-indexed start/end of the last visual selection
    local s = vim.fn.getpos "'<"
    local e = vim.fn.getpos "'>"
    local sl, sc = s[2] - 1, s[3] - 1
    local el, ec = e[2] - 1, e[3] - 1

    if sl < 0 or el < 0 then
        vim.notify('No valid selection found', vim.log.levels.ERROR)
        return
    end

    for ln = sl, el do
        local line = vim.api.nvim_buf_get_lines(0, ln, ln + 1, false)[1] or ''
        -- compute raw range
        local lcol = (ln == sl) and sc or 0
        local rcol = (ln == el) and ec or #line

        -- clamp to [0, #line]
        lcol = math.max(0, math.min(lcol, #line))
        rcol = math.max(lcol, math.min(rcol, #line))

        if lcol < rcol then
            local segment = line:sub(lcol + 1, rcol)
            local lead = segment:match '^%s*' or ''
            local body = segment:sub(#lead + 1):gsub('%s+', ' ')
            local modified = lead .. body

            if modified ~= segment then
                local ok, err = pcall(vim.api.nvim_buf_set_text, 0, ln, lcol, ln, rcol, { modified })
                if not ok then
                    vim.notify('Error squeezing whitespace: ' .. err, vim.log.levels.ERROR)
                end
            end
        end
    end
end

--- Split `key = value` into the key half (indent, key, `=` and trailing spacing),
--- the bare key, and the value half. Returns nil for a line that is not an
--- assignment; the key alone is nil for one whose key is not a plain identifier.
local function split_assignment(line)
    local prefix, value = line:match '^(%s*[^=]-=%s*)(.+)$'
    if not prefix then
        return nil
    end
    return prefix, prefix:match '([%w_]+)%s*=%s*$', value
end

--- Line range of a top-level `local <name> = { ... }`, excluding its braces.
--- @param lines string[] the whole buffer
--- @param name string
--- @return integer|nil first, integer|nil last
local function table_range(lines, name)
    local first
    for i, line in ipairs(lines) do
        if first then
            if line:match '^}' then
                return first, i - 1
            end
        elseif line:match('^local ' .. name .. ' = {%s*$') then
            first = i + 1
        end
    end
end

--- Swap the value on the cursor's line with the nearest one above or below,
--- leaving both keys where they are. Where a table's keys are fixed slots --
--- soundboard.lua's F-keys, say -- only the values are really ordered, so moving
--- the whole line carries the key along and reorders nothing. Blank lines and
--- comments are stepped over; a line holding a brace ends the search, so a value
--- cannot leave the table it lives in.
--- @param step integer -1 to move up, 1 to move down
local function move_value(step)
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ''
    local prefix, _, value = split_assignment(line)
    if not prefix then
        return
    end

    local last = vim.api.nvim_buf_line_count(0)
    for target = row + step, step < 0 and 1 or last, step do
        local candidate = vim.api.nvim_buf_get_lines(0, target - 1, target, false)[1] or ''
        if candidate:find '[{}]' then
            return
        end
        local target_prefix, _, target_value = split_assignment(candidate)
        if target_prefix then
            vim.api.nvim_buf_set_lines(0, row - 1, row, false, { prefix .. target_value })
            vim.api.nvim_buf_set_lines(0, target - 1, target, false, { target_prefix .. value })
            local col = math.min(vim.api.nvim_win_get_cursor(0)[2], #target_prefix + #value)
            vim.api.nvim_win_set_cursor(0, { target, col })
            return
        end
    end
end

--- Swap the value on the cursor's line with the one under the same key in an
--- adjacent table. Banks are matched by key, not by position: `F17` trades with
--- `F17`, and a key the other bank does not define is reported rather than
--- guessed at, because that slot genuinely does not exist there. The cursor must
--- be inside one of the named tables, so a value cannot cross out of them.
--- @param banks string[] table names, in the order they appear in the file
--- @param step integer -1 for the previous bank, 1 for the next
local function swap_bank(banks, step)
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local line = lines[row] or ''
    -- A brace delimits a table rather than binding anything, so `local plain = {`
    -- is not an entry that missed its bank -- it is not an entry at all.
    if line:find '[{}]' then
        return
    end
    local prefix, key, value = split_assignment(line)
    if not key then
        return
    end

    local ranges, from = {}, nil
    for i, name in ipairs(banks) do
        local first, last = table_range(lines, name)
        if first then
            ranges[i] = { first = first, last = last }
            if row >= first and row <= last then
                from = i
            end
        end
    end
    if not from then
        vim.notify('Not in a sound bank', vim.log.levels.WARN)
        return
    end

    local target_bank = banks[from + step]
    local target_range = target_bank and ranges[from + step]
    if not target_range then
        return
    end

    for target = target_range.first, target_range.last do
        local target_prefix, target_key, target_value = split_assignment(lines[target])
        if target_key == key then
            vim.api.nvim_buf_set_lines(0, row - 1, row, false, { prefix .. target_value })
            vim.api.nvim_buf_set_lines(0, target - 1, target, false, { target_prefix .. value })
            local col = math.min(vim.api.nvim_win_get_cursor(0)[2], #target_prefix + #value)
            vim.api.nvim_win_set_cursor(0, { target, col })
            return
        end
    end
    vim.notify(('%s has no %s'):format(target_bank, key), vim.log.levels.WARN)
end

function M.move_value_up()
    move_value(-1)
end

function M.move_value_down()
    move_value(1)
end

--- @param banks string[] table names, in the order they appear in the file
function M.swap_bank_next(banks)
    swap_bank(banks, 1)
end

--- @param banks string[] table names, in the order they appear in the file
function M.swap_bank_prev(banks)
    swap_bank(banks, -1)
end

function M.open_todo()
    require('todo').open()
end

return M
