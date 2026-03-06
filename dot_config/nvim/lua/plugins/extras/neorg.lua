return {
    {
        'nvim-neorg/neorg',
        build = function()
            local parser_dir = vim.fn.stdpath 'data' .. '/site/parser'
            vim.fn.mkdir(parser_dir, 'p')
            local out = parser_dir .. '/norg.so'
            local tmp = vim.fn.tempname()
            vim.fn.mkdir(tmp, 'p')
            local cc = vim.fn.executable 'gcc-15' == 1 and 'gcc-15' or 'cc'
            local cxx = vim.fn.executable 'g++-15' == 1 and 'g++-15' or 'c++'
            local result = vim.fn.system(string.format(
                [[
            git clone --depth 1 https://github.com/nvim-neorg/tree-sitter-norg %s 2>&1 &&
            cd %s &&
            %s -c -std=c99 -fPIC -I./src -o %s/parser.o src/parser.c 2>&1 &&
            %s -c -std=c++14 -fPIC -I./src -o %s/scanner.o src/scanner.cc 2>&1 &&
            %s -shared -o %s %s/parser.o %s/scanner.o -lstdc++ 2>&1
        ]],
                tmp,
                tmp,
                cc,
                tmp,
                cxx,
                tmp,
                cxx,
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
                        folds = false,
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
