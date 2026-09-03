--- Markdown list editing: item continuation, promote/demote, checkbox toggling
--- and ordered-list renumbering.
---
--- Everything is line-based rather than treesitter-based. List markers are
--- trivially regular, and staying off the parse tree keeps these usable
--- mid-insert, where the tree is still stale.
---
--- Buffer-local keymaps live in `after/ftplugin/markdown.lua`.

local M = {}

--- A parsed list item. `indent .. marker() .. pad` reproduces the prefix exactly.
--- @class md.Item
--- @field indent string        leading whitespace
--- @field bullet string|nil    '-', '*' or '+' on unordered items
--- @field number integer|nil   ordered items only
--- @field delim string|nil     '.' or ')' on ordered items
--- @field pad string           whitespace between marker and content
--- @field checked boolean|nil  nil when the item carries no checkbox
--- @field body string          content after the marker and checkbox
--- @field width integer        column at which the body starts

--- @param item md.Item
local function marker(item)
    return item.bullet or (item.number .. item.delim)
end

--- @param item md.Item
--- @return string
local function render(item)
    local box = ''
    if item.checked ~= nil then
        box = item.checked and '[x] ' or '[ ] '
    end
    return item.indent .. marker(item) .. item.pad .. box .. item.body
end

--- @return md.Item|nil
local function parse(line)
    if not line then
        return nil
    end

    local item = {}
    -- Ordered first: `1.` and `1)`, with or without trailing content.
    local indent, number, delim, pad = line:match '^(%s*)(%d+)([.)])(%s+)'
    if not indent then
        indent, number, delim = line:match '^(%s*)(%d+)([.)])%s*$'
        pad = indent and ' ' or nil
    end

    if indent then
        item.number, item.delim = tonumber(number), delim
    else
        local bullet
        indent, bullet, pad = line:match '^(%s*)([-*+])(%s+)'
        if not indent then
            indent, bullet = line:match '^(%s*)([-*+])%s*$'
            pad = indent and ' ' or nil
        end
        if not indent then
            return nil
        end
        item.bullet = bullet
    end

    item.indent, item.pad = indent, pad
    item.width = #indent + #marker(item) + #pad

    local rest = line:sub(item.width + 1)
    local state, gap = rest:match '^%[([ xX])%](%s*)'
    if state then
        item.checked = state ~= ' '
        item.body = rest:sub(#gap + 4)
    else
        item.body = rest
    end

    return item
end

local function is_blank(line)
    return line == nil or line:match '^%s*$' ~= nil
end

local function get_line(row)
    return vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
end

--- Bounds of the list block around `row`: consecutive list items plus their
--- indented continuation lines. A single blank line is tolerated inside a block
--- so loose lists stay together; two in a row end it.
--- @return integer first, integer last
local function block_range(row)
    local eof = vim.api.nvim_buf_line_count(0)

    local function belongs(r)
        if r < 1 or r > eof then
            return false
        end
        local line = get_line(r)
        return parse(line) ~= nil or line:match '^%s+%S' ~= nil
    end

    local first = row
    while true do
        if belongs(first - 1) then
            first = first - 1
        elseif is_blank(get_line(first - 1)) and belongs(first - 2) then
            first = first - 2
        else
            break
        end
    end

    local last = row
    while true do
        if belongs(last + 1) then
            last = last + 1
        elseif is_blank(get_line(last + 1)) and belongs(last + 2) then
            last = last + 2
        else
            break
        end
    end

    return first, last
end

--- Nearest list item above `row` within the same block whose indent is at most
--- `width`, i.e. the item this one would nest under or sit beside.
--- @return md.Item|nil
local function preceding(row, width)
    local first = block_range(row)
    for r = row - 1, first, -1 do
        local other = parse(get_line(r))
        if other and #other.indent <= width then
            return other
        end
    end
end

--- Last row of the item at `row` including everything nested under it.
local function subtree_end(row)
    local item = parse(get_line(row))
    local width = #item.indent
    local _, last = block_range(row)

    local result = row
    for r = row + 1, last do
        local line = get_line(r)
        if not is_blank(line) then
            if #(line:match '^%s*') <= width then
                break
            end
            result = r
        end
    end

    return result
end

--- Renumber the ordered items in the list block containing `row`. Each indent
--- level keeps whatever number its first item used, so lists deliberately
--- starting at 0 (or 5) survive a renumber.
function M.renumber(row)
    row = math.min(math.max(row, 1), vim.api.nvim_buf_line_count(0))

    local first, last = block_range(row)
    local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
    local levels = {} --- @type { indent: integer, count: integer }[]
    local dirty = false

    for i, line in ipairs(lines) do
        local item = parse(line)
        if item then
            local width = #item.indent
            while #levels > 0 and levels[#levels].indent > width do
                table.remove(levels)
            end

            local level = levels[#levels]
            if level and level.indent == width then
                level.count = level.count + 1
            else
                level = { indent = width, count = item.number or 1 }
                table.insert(levels, level)
            end

            if item.number and item.number ~= level.count then
                item.number = level.count
                lines[i] = render(item)
                dirty = true
            end
        end
    end

    if dirty then
        vim.api.nvim_buf_set_lines(0, first - 1, last, false, lines)
    end
end

--- Move the item on `row`, and everything nested under it, one level in or out.
---
--- Demotion anchors on the previous sibling's body column so children line up
--- under their parent's text (3 spaces under `1. `, 2 under `- `); promotion
--- returns to the parent's indent. Demoting an item with no sibling above it is
--- refused, since that produces a list no renderer will nest.
--- @param delta 1|-1
--- @return boolean handled the row holds a list item, so no fallback is wanted
--- @return boolean moved the indent actually changed
function M.shift(row, delta)
    local item = parse(get_line(row))
    if not item then
        return false, false
    end

    local width = #item.indent
    local target
    if delta > 0 then
        local sibling = preceding(row, width)
        if not sibling or #sibling.indent ~= width then
            return true, false
        end
        target = sibling.width
    else
        if width == 0 then
            return true, false
        end
        local parent = preceding(row, width - 1)
        target = parent and #parent.indent or 0
    end

    local offset = target - width
    local last = subtree_end(row)
    local lines = vim.api.nvim_buf_get_lines(0, row - 1, last, false)
    for i, line in ipairs(lines) do
        if not is_blank(line) then
            if offset > 0 then
                lines[i] = string.rep(' ', offset) .. line
            else
                lines[i] = line:sub(math.min(-offset, #(line:match '^%s*')) + 1)
            end
        end
    end
    vim.api.nvim_buf_set_lines(0, row - 1, last, false, lines)

    local cursor = vim.api.nvim_win_get_cursor(0)
    if cursor[1] >= row and cursor[1] <= last then
        vim.api.nvim_win_set_cursor(0, { cursor[1], math.max(0, cursor[2] + offset) })
    end

    M.renumber(row)
    return true, true
end

--- Insert-mode <CR>. Continues the current item, carrying any text right of the
--- cursor onto the new one. On an empty item it steps out a level instead, and
--- at the outermost level it drops the marker so you land back in prose.
--- @return boolean handled
function M.newline()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = get_line(row)
    local item = parse(line)

    -- Not a list, or the cursor is still inside the marker: plain newline.
    if not item or col < item.width then
        return false
    end

    if item.body == '' then
        local _, moved = M.shift(row, -1)
        if not moved then
            vim.api.nvim_buf_set_lines(0, row - 1, row, false, { '' })
            vim.api.nvim_win_set_cursor(0, { row, 0 })
            if parse(get_line(row + 1)) then
                M.renumber(row + 1)
            end
        end
        return true
    end

    local tail = line:sub(col + 1)
    local continued = {
        indent = item.indent,
        bullet = item.bullet,
        number = item.number and item.number + 1 or nil,
        delim = item.delim,
        pad = item.pad,
        body = tail,
    }
    if item.checked ~= nil then
        continued.checked = false
    end

    local text = render(continued)
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, { line:sub(1, col), text })
    vim.api.nvim_win_set_cursor(0, { row + 1, #text - #tail })
    M.renumber(row + 1)
    return true
end

--- Normal-mode o/O on a list item: open an empty sibling and start insert.
--- @param above boolean
--- @return boolean handled
function M.open(above)
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local item = parse(get_line(row))
    if not item then
        return false
    end

    item.body = ''
    if item.checked ~= nil then
        item.checked = false
    end
    if item.number and not above then
        item.number = item.number + 1
    end

    local target = above and row - 1 or row
    local text = render(item)
    vim.api.nvim_buf_set_lines(0, target, target, false, { text })
    vim.api.nvim_win_set_cursor(0, { target + 1, #text })
    M.renumber(target + 1)
    vim.cmd 'startinsert!'
    return true
end

--- Toggle checkboxes across a row range, giving plain list items an unchecked
--- box on first use.
--- @return boolean handled
function M.toggle_checkbox(first, last)
    local handled = false
    for row = first, last or first do
        local item = parse(get_line(row))
        if item then
            item.checked = item.checked == false
            vim.api.nvim_buf_set_lines(0, row - 1, row, false, { render(item) })
            handled = true
        end
    end
    return handled
end

return M
