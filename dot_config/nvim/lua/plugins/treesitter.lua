--[[
  treesitter.lua
  ------------------
  This file is for plugins that integrate with Tree-sitter.
  Add plugins for advanced syntax highlighting, parsing, and structural code analysis.
]]

return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        version = false,
        build = ':TSUpdate',
        lazy = false,
        config = function()
            local filetypes = {
                'bash',
                'c',
                'dart',
                'diff',
                'html',
                'lua',
                'luadoc',
                'markdown',
                'markdown_inline',
                'query',
                'vim',
                'vimdoc',
                'go',
                'gowork',
                'gomod',
                'gosum',
                'sql',
                'gotmpl',
                'json',
                'comment',
                'regex',
                'css',
                'javascript',
                'latex',
                'scss',
                'svelte',
                'tsx',
                'typst',
                'vue',
                'norg',
            }

            vim.api.nvim_create_autocmd('FileType', {
                pattern = filetypes,
                callback = function()
                    vim.treesitter.start()
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })

            require('nvim-treesitter').install(filetypes)
        end,

        -- There are additional nvim-treesitter modules that you can use to interact
        -- with nvim-treesitter. You should go explore a few and see what interests you:
        --
        --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
        --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
        --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    },
}
