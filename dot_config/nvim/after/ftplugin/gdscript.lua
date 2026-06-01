-- GDScript buffer-local setup.
--
-- Indentation is intentionally left to Neovim's bundled ftplugin/gdscript.vim and
-- indent/gdscript.vim, which apply Godot's recommended style (noexpandtab, tabstop=4)
-- and already match gdformat's output. Verify with `:verbose setlocal expandtab?`.

-- Open the Godot class reference in the browser for the symbol under the cursor,
-- or an explicit name (e.g. `:GodotDocs Sprite2D`).
vim.api.nvim_buf_create_user_command(0, 'GodotDocs', function(o)
    local sym = o.args ~= '' and o.args or vim.fn.expand '<cword>'
    if sym == '' then
        return vim.notify('No symbol under cursor', vim.log.levels.WARN)
    end
    vim.ui.open(('https://docs.godotengine.org/en/stable/classes/class_%s.html'):format(sym:lower()))
end, { nargs = '?', desc = 'Open Godot class docs in browser' })
