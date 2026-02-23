--[[
    extras/claudecode.lua
    ----------------------
    WebSocket-based Claude Code integration via claudecode.nvim.
    Replaces the previous shell-out approach in util.lua.
]]

return {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    opts = {
        terminal = {
            provider = 'snacks',
            split_side = 'right',
            split_width_percentage = 0.30,
        },
    },
    keys = {
        { '<leader>aa', '<cmd>ClaudeCode<cr>', desc = '[A]I [A]ssistant (Toggle)' },
        { '<C-a>', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude Code', mode = { 'n', 't' } },
        { '<leader>ac', '<cmd>ClaudeCode --continue<cr>', desc = '[A]I [C]ontinue' },
        { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = '[A]I [R]esume' },
        { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = '[A]I [F]ocus' },
        { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = '[A]I Add [B]uffer' },
        { '<leader>as', '<cmd>ClaudeCodeSend<cr>', desc = '[A]I [S]end Selection', mode = 'v' },
    },
}
