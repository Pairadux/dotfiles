--- Filetype detection for chezmoi source files.
---
--- chezmoi encodes target attributes in the source filename (`dot_`, `private_`,
--- `executable_`, ...) and marks templates with a `.tmpl` suffix, so none of the
--- dotfiles repo matches Neovim's normal detection: `machine.lua.tmpl` is not
--- seen as Lua, `dot_zshenv.tmpl` is not seen as zsh. Rebuild the name chezmoi
--- would render to, and detect against that instead.
---
--- The `{{ ... }}` markers still parse as errors in the base grammar, and how
--- much that costs scales with how many of them there are. A handful leaves a
--- well-formed root and highlights fine; enough of them exhausts the parser's
--- error recovery, the root itself becomes an ERROR node, every highlight query
--- misses and the buffer renders with no colour at all. Keep the template logic
--- in a file thin enough to stay under that threshold -- if a template needs
--- real control flow, that is a sign the logic belongs in the target language.
--- Files with no second extension (ghostty's `config.tmpl`) fall back to gotmpl,
--- which highlights the template syntax and leaves the body plain.

-- Attribute prefixes chezmoi strips when rendering a target. They stack, as in
-- `private_dot_gnupg`, so peel until nothing more matches.
local ATTR_PREFIXES = {
    'after_',
    'before_',
    'create_',
    'empty_',
    'encrypted_',
    'exact_',
    'executable_',
    'external_',
    'literal_',
    'modify_',
    'once_',
    'onchange_',
    'private_',
    'readonly_',
    'remove_',
    'run_',
    'symlink_',
}

--- Convert a chezmoi source basename into the target basename it renders to.
--- @param name string basename with the `.tmpl` suffix already removed
--- @return string
local function target_name(name)
    local peeled = true
    while peeled do
        peeled = false
        for _, prefix in ipairs(ATTR_PREFIXES) do
            local rest = name:gsub('^' .. prefix, '', 1)
            if rest ~= name then
                name, peeled = rest, true
            end
        end
    end
    return (name:gsub('^dot_', '.', 1))
end

--- Filetype a chezmoi source file's rendered target would get.
--- @param path string
--- @return string|nil
local function detect(path)
    local name = vim.fs.basename(path)
    local template = name:match('%.tmpl$') ~= nil
    if template then
        name = name:gsub('%.tmpl$', '', 1)
    end
    -- Match on the filename alone. Passing the buffer would let content
    -- heuristics read the template source and guess from the `{{ }}`.
    local ft = vim.filetype.match { filename = target_name(name) }
    if template and not ft then
        return 'gotmpl'
    end
    return ft
end

-- Attribute prefixes are part of the source filename, so a plain `dot_zshenv`
-- needs the same treatment as `dot_zshenv.tmpl` -- without this it matches
-- nothing at all and opens with no filetype. Both patterns route to `detect`,
-- so it does not matter which one wins for a file carrying a prefix AND .tmpl.
local patterns = { ['.*%.tmpl'] = detect, ['dot_.*'] = detect }
for _, prefix in ipairs(ATTR_PREFIXES) do
    patterns[prefix .. '.*'] = detect
end

vim.filetype.add { pattern = patterns }
