local M = {}

local NOTES_ROOT = vim.fn.expand '~/Cloud/Notes'
local INDEX_PATH = NOTES_ROOT .. '/index.norg'

-- Directories at the notes root that are not section folders and should be
-- excluded from sync scans.
local ROOT_SKIP = {
    ['Archive'] = true,
    ['journal'] = true,
    ['.debris'] = true,
    ['.claude'] = true,
}

local function is_index_buf()
    if vim.fn.expand '%:p' ~= INDEX_PATH then
        vim.notify('notes: must be run from index.norg', vim.log.levels.WARN)
        return false
    end
    return true
end

-- Parse a Neorg list-item link line: `   - {:$/path/to/note:}[Display Name]`.
-- Returns the workspace-relative path (no extension) and the display name, or nil.
local function parse_link(line)
    return line:match '{:%$/(.-):}%[(.-)%]'
end

-- Title-case a kebab/snake filename: `homelab-guide` -> `Homelab Guide`.
local function title_case(s)
    local out = s:gsub('[-_]', ' ')
    out = out:gsub('(%w)(%w*)', function(a, b)
        return a:upper() .. b
    end)
    return out
end

-- Compute the archive destination path. Always prepends the sanitized source
-- path so Archive/ stays a single-heading section and provenance is preserved
-- in the filename (e.g. `Work/Robins AFB/foo` -> `Archive/Work_Robins_AFB_foo`).
local function archive_dest(src_rel)
    local archive_dir = NOTES_ROOT .. '/Archive'
    vim.fn.mkdir(archive_dir, 'p')
    local sanitized = src_rel:gsub('[/ ]', '_')
    return archive_dir .. '/' .. sanitized .. '.norg', 'Archive/' .. sanitized
end

-- Locate the `** Archive` heading and return the line index (0-based) where
-- a new list item should be inserted: end of the Archive block or EOF.
local function archive_insert_point(buf_lines)
    local archive_idx
    for i, l in ipairs(buf_lines) do
        if l:match '^%*%* Archive%s*$' then
            archive_idx = i
            break
        end
    end
    if not archive_idx then
        return nil
    end
    local insert_at = #buf_lines
    for i = archive_idx + 1, #buf_lines do
        if buf_lines[i]:match '^%*+%s' then
            insert_at = i - 1
            break
        end
    end
    return insert_at
end

function M.archive_under_cursor()
    if not is_index_buf() then
        return
    end

    local row = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ''
    local rel_path, display = parse_link(line)
    if not rel_path then
        vim.notify('notes: no Neorg link on this line', vim.log.levels.WARN)
        return
    end

    local src = NOTES_ROOT .. '/' .. rel_path .. '.norg'
    if vim.fn.filereadable(src) == 0 then
        vim.notify('notes: source file not found: ' .. src, vim.log.levels.ERROR)
        return
    end

    local dest, new_rel = archive_dest(rel_path)
    local ok, err = os.rename(src, dest)
    if not ok then
        vim.notify('notes: rename failed: ' .. tostring(err), vim.log.levels.ERROR)
        return
    end

    -- Remove the index entry under the cursor.
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, {})

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local insert_at = archive_insert_point(lines)
    if not insert_at then
        vim.notify('notes: ** Archive heading not found in index', vim.log.levels.ERROR)
        return
    end

    -- `** Archive` is a level-2 heading; list items use 3-space indent.
    local new_line = '   - {:$/' .. new_rel .. ':}[' .. display .. ']'
    vim.api.nvim_buf_set_lines(0, insert_at, insert_at, false, { new_line })

    vim.notify('notes: archived ' .. rel_path, vim.log.levels.INFO)
end

-- Archive every list-item link in the heading under (or above) the cursor,
-- recursively including its sub-headings. The entire heading block is then
-- removed from the index and the moved entries are appended under `** Archive`.
function M.archive_header_under_cursor()
    if not is_index_buf() then
        return
    end

    local row = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    -- Walk up from the cursor to find the enclosing heading.
    local heading_idx, heading_level, heading_name
    for i = row, 1, -1 do
        local stars, name = lines[i]:match '^(%*+) (.+)$'
        if stars then
            heading_idx, heading_level, heading_name = i, #stars, name
            break
        end
    end

    if not heading_idx then
        vim.notify('notes: no heading at or above cursor', vim.log.levels.WARN)
        return
    end
    if heading_level == 1 then
        vim.notify('notes: refusing to archive the root heading', vim.log.levels.WARN)
        return
    end
    if heading_name == 'Archive' then
        vim.notify('notes: refusing to archive the Archive heading', vim.log.levels.WARN)
        return
    end

    -- Section ends at the next heading of equal or lower depth (or EOF).
    local end_idx = #lines + 1
    for i = heading_idx + 1, #lines do
        local stars = lines[i]:match '^(%*+)%s'
        if stars and #stars <= heading_level then
            end_idx = i
            break
        end
    end

    -- Pre-flight: collect every link and verify no archive collision exists.
    local entries = {}
    for i = heading_idx, end_idx - 1 do
        local rel, display = parse_link(lines[i])
        if rel then
            local src = NOTES_ROOT .. '/' .. rel .. '.norg'
            if vim.fn.filereadable(src) == 0 then
                vim.notify('notes: skipping missing file: ' .. src, vim.log.levels.WARN)
            else
                local dest, new_rel = archive_dest(rel)
                if vim.fn.filereadable(dest) == 1 then
                    vim.notify('notes: archive destination already exists, aborting: ' .. dest, vim.log.levels.ERROR)
                    return
                end
                table.insert(entries, { src = src, dest = dest, new_rel = new_rel, display = display })
            end
        end
    end

    -- Move all files first; if any rename fails, surface the error but keep
    -- the index intact so the user can recover manually.
    for _, e in ipairs(entries) do
        local ok, err = os.rename(e.src, e.dest)
        if not ok then
            vim.notify('notes: rename failed for ' .. e.src .. ': ' .. tostring(err), vim.log.levels.ERROR)
            return
        end
    end

    -- Drop the heading block from the index.
    vim.api.nvim_buf_set_lines(0, heading_idx - 1, end_idx - 1, false, {})

    if #entries == 0 then
        vim.notify(('notes: removed empty heading "%s"'):format(heading_name), vim.log.levels.INFO)
        return
    end

    local cur_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local insert_at = archive_insert_point(cur_lines)
    if not insert_at then
        vim.notify('notes: ** Archive heading not found in index', vim.log.levels.ERROR)
        return
    end

    local new_lines = {}
    for _, e in ipairs(entries) do
        table.insert(new_lines, '   - {:$/' .. e.new_rel .. ':}[' .. e.display .. ']')
    end
    vim.api.nvim_buf_set_lines(0, insert_at, insert_at, false, new_lines)

    vim.notify(('notes: archived heading "%s" (%d notes)'):format(heading_name, #entries), vim.log.levels.INFO)
end

-- Recursively collect every `.norg` file under `root`, skipping the
-- non-section folders. Returns workspace-relative paths without extension.
local function scan_notes(root)
    local results = {}

    local function walk(dir, rel)
        local handle = vim.loop.fs_scandir(dir)
        if not handle then
            return
        end
        while true do
            local name, t = vim.loop.fs_scandir_next(handle)
            if not name then
                break
            end
            local rel_child = rel == '' and name or (rel .. '/' .. name)
            if t == 'directory' then
                if not (rel == '' and ROOT_SKIP[name]) then
                    walk(dir .. '/' .. name, rel_child)
                end
            elseif t == 'file' and name:match '%.norg$' then
                table.insert(results, (rel_child:gsub('%.norg$', '')))
            end
        end
    end

    walk(root, '')
    return results
end

-- Locate the insertion point for a new list item under a nested heading path.
-- Returns (insert_line_0indexed, indent_string) or nil if no section matches.
-- The index file is structured with `* Notes Index` at level 1 and section
-- headings starting at level 2, so a target like {"Work", "Robins AFB"}
-- requires a level-2 "Work" heading followed by a nested level-3 "Robins AFB".
local function find_section_insert(buf_lines, target_path)
    if #target_path == 0 then
        return nil
    end

    local matched = 0
    local heading_idx
    for i, l in ipairs(buf_lines) do
        local stars, name = l:match '^(%*+) (.+)$'
        if stars then
            local level = #stars
            local expected = matched + 2
            if level == expected and name == target_path[matched + 1] then
                matched = matched + 1
                heading_idx = i
                if matched == #target_path then
                    break
                end
            elseif level <= matched + 1 and matched > 0 then
                -- Left the parent section before finding the next sub-heading.
                return nil
            end
        end
    end

    if matched ~= #target_path then
        return nil
    end

    -- Insert just before the next heading of any level (or at EOF), so new
    -- items land at the bottom of this section's direct list.
    local insert_at = #buf_lines
    for i = heading_idx + 1, #buf_lines do
        if buf_lines[i]:match '^%*+%s' then
            insert_at = i - 1
            break
        end
    end

    local indent = string.rep(' ', #target_path + 2)
    return insert_at, indent
end

function M.sync_index()
    if not is_index_buf() then
        return
    end

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    local existing = { index = true }
    for _, l in ipairs(lines) do
        local p = parse_link(l)
        if p then
            existing[p] = true
        end
    end

    local found = scan_notes(NOTES_ROOT)
    local new_files = {}
    for _, rel in ipairs(found) do
        if not existing[rel] then
            table.insert(new_files, rel)
        end
    end

    if #new_files == 0 then
        vim.notify('notes: index is up to date', vim.log.levels.INFO)
        return
    end

    table.sort(new_files)

    local added, skipped = 0, {}
    for _, rel in ipairs(new_files) do
        local parts = vim.split(rel, '/')
        local basename = table.remove(parts)
        local display = title_case(basename)

        local cur_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local insert_at, indent = find_section_insert(cur_lines, parts)
        if insert_at then
            local new_line = indent .. '- {:$/' .. rel .. ':}[' .. display .. ']'
            vim.api.nvim_buf_set_lines(0, insert_at, insert_at, false, { new_line })
            added = added + 1
        else
            table.insert(skipped, rel)
        end
    end

    local msg = ('notes: added %d, skipped %d'):format(added, #skipped)
    if #skipped > 0 then
        msg = msg .. ' (no matching heading: ' .. table.concat(skipped, ', ') .. ')'
    end
    vim.notify(msg, vim.log.levels.INFO)
end

-- Build the heading nesting at `row` by linearly walking the buffer and
-- maintaining a stack. The root `* Notes Index` (level 1) is dropped so the
-- result mirrors the on-disk folder structure (level 2 = top-level folder).
local function section_path_at(buf_lines, row)
    local stack = {}
    for i = 1, math.min(row, #buf_lines) do
        local stars, name = buf_lines[i]:match '^(%*+) (.+)$'
        if stars then
            local level = #stars
            while #stack > 0 and stack[#stack].level >= level do
                table.remove(stack)
            end
            table.insert(stack, { level = level, name = name })
        end
    end
    if stack[1] and stack[1].level == 1 then
        table.remove(stack, 1)
    end
    local path = {}
    for _, h in ipairs(stack) do
        table.insert(path, h.name)
    end
    return path
end

function M.add_under_heading()
    if not is_index_buf() then
        return
    end

    local row = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local section_path = section_path_at(lines, row)

    if #section_path == 0 then
        vim.notify('notes: cursor must be inside a section heading', vim.log.levels.WARN)
        return
    end
    if section_path[1] == 'Archive' then
        vim.notify('notes: use \\la to archive instead of adding to Archive', vim.log.levels.WARN)
        return
    end

    local filename = vim.fn.input 'New note filename: '
    if filename == '' then
        return
    end
    filename = filename:gsub('%.norg$', '')

    local rel = table.concat(section_path, '/') .. '/' .. filename
    local abs = NOTES_ROOT .. '/' .. rel .. '.norg'
    local parent = NOTES_ROOT .. '/' .. table.concat(section_path, '/')

    if vim.fn.filereadable(abs) == 1 then
        vim.notify('notes: file already exists: ' .. abs, vim.log.levels.ERROR)
        return
    end

    vim.fn.mkdir(parent, 'p')
    local fh, err = io.open(abs, 'w')
    if not fh then
        vim.notify('notes: could not create file: ' .. tostring(err), vim.log.levels.ERROR)
        return
    end
    fh:close()

    local cur_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local insert_at, indent = find_section_insert(cur_lines, section_path)
    if not insert_at then
        vim.notify('notes: could not resolve heading path in index', vim.log.levels.ERROR)
        return
    end

    local display = title_case(filename)
    local new_line = indent .. '- {:$/' .. rel .. ':}[' .. display .. ']'
    vim.api.nvim_buf_set_lines(0, insert_at, insert_at, false, { new_line })

    vim.cmd('edit ' .. vim.fn.fnameescape(abs))
end

function M.delete_under_cursor()
    if not is_index_buf() then
        return
    end

    local row = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ''
    local rel_path = parse_link(line)
    if not rel_path then
        vim.notify('notes: no Neorg link on this line', vim.log.levels.WARN)
        return
    end

    local abs = NOTES_ROOT .. '/' .. rel_path .. '.norg'
    local answer = vim.fn.input(('Delete %s? (y/N): '):format(rel_path))
    if answer:lower() ~= 'y' and answer:lower() ~= 'yes' then
        vim.notify('notes: delete cancelled', vim.log.levels.INFO)
        return
    end

    if vim.fn.filereadable(abs) == 1 then
        local ok, err = os.remove(abs)
        if not ok then
            vim.notify('notes: could not delete file: ' .. tostring(err), vim.log.levels.ERROR)
            return
        end
    else
        vim.notify('notes: file already missing, removing index entry only', vim.log.levels.WARN)
    end

    vim.api.nvim_buf_set_lines(0, row - 1, row, false, {})
    vim.notify('notes: deleted ' .. rel_path, vim.log.levels.INFO)
end

return M
