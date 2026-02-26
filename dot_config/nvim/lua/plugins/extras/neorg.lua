return {
    {
        'nvim-neorg/neorg',
        build = function()
            local parser_dir = vim.fn.stdpath 'data' .. '/site/parser'
            vim.fn.mkdir(parser_dir, 'p')
            local out = parser_dir .. '/norg.so'
            local tmp = vim.fn.tempname()
            vim.fn.mkdir(tmp, 'p')
            local result = vim.fn.system(string.format(
                [[
            git clone --depth 1 https://github.com/nvim-neorg/tree-sitter-norg %s 2>&1 &&
            cd %s &&
            gcc-15 -c -std=c99 -fPIC -I./src -o %s/parser.o src/parser.c 2>&1 &&
            g++-15 -c -std=c++14 -fPIC -I./src -o %s/scanner.o src/scanner.cc 2>&1 &&
            g++-15 -shared -o %s %s/parser.o %s/scanner.o -lstdc++ 2>&1
        ]],
                tmp,
                tmp,
                tmp,
                tmp,
                out,
                tmp,
                tmp
            ))
            if vim.v.shell_error ~= 0 then
                vim.notify('norg parser build failed:\n' .. result, vim.log.levels.ERROR)
            else
                vim.notify 'norg parser compiled successfully'
            end
        end,
        lazy = false,
        version = '*',
        opts = {
            load = {
                ['core.defaults'] = {},
                ['core.concealer'] = {
                    config = {
                        icon_preset = 'diamond',
                        init_open_folds = 'always',
                    },
                },
                ['core.dirman'] = {
                    config = {
                        default_workspace = 'notes',
                        workspaces = {
                            notes = '~/Cloud/Notes/',
                        },
                    },
                },
                ['core.summary'] = {},
                ['core.journal'] = {
                    config = {
                        workspace = 'notes',
                    },
                },
                ['core.completion'] = {
                    config = {
                        engine = { module_name = 'external.lsp-completion' },
                    },
                },
                ['external.interim-ls'] = {
                    config = {
                        completion_provider = {
                            enable = true,
                            documentation = true,
                        },
                    },
                },
            },
        },
    },

    { 'benlubas/neorg-interim-ls' },
}
