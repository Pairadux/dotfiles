--- Filetype detection for chezmoi source files.
---
--- chezmoi encodes target attributes in the source filename (`dot_`, `private_`,
--- `executable_`, ...) and marks templates with a `.tmpl` suffix, so none of the
--- dotfiles repo matches Neovim's normal detection: `hyprland.lua.tmpl` is not
--- seen as Lua, `dot_zshenv.tmpl` is not seen as zsh. Rebuild the name chezmoi
--- would render to, and detect against that instead.
---
--- The `{{ ... }}` markers still parse as errors in the base grammar. That is the
--- trade: roughly 90% of a template highlights correctly rather than none of it.
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

vim.filetype.add {
    pattern = {
        ['.*%.tmpl'] = function(path)
            local base = target_name(vim.fs.basename(path):gsub('%.tmpl$', '', 1))
            -- Match on the filename alone. Passing the buffer would let content
            -- heuristics read the template source and guess from the `{{ }}`.
            return vim.filetype.match { filename = base } or 'gotmpl'
        end,
    },
}
