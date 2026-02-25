--[[
    lsp/init.lua
    ---------------
    This file is for plugins related to the Language Server Protocol (LSP).
    Include configurations and integrations for LSP servers to offer enhanced code intelligence.
]]

return {

    {
        'mason-org/mason.nvim',
        lazy = false,
        opts = {},
    },

    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'mason-org/mason.nvim' },
            { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
            { 'j-hui/fidget.nvim', opts = {} },
            { 'saghen/blink.cmp' },
        },
        config = function()
            --  This function gets run when an LSP attaches to a particular buffer.
            --    That is to say, every time a new file is opened that is associated with
            --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
            --    function will be executed to configure the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end
                    -- Mappings
                    map('<leader>lr', vim.lsp.buf.rename, '[L]anguage [R]ename')
                    map('<leader>la', vim.lsp.buf.code_action, '[L]anguage [A]ction', { 'n', 'x' })
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    -- if client and client:supports_method('textDocument/documentHighlight', event.buf) then
                    --     local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                    --     vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    --         buffer = event.buf,
                    --         group = highlight_augroup,
                    --         callback = vim.lsp.buf.document_highlight,
                    --     })
                    --     vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    --         buffer = event.buf,
                    --         group = highlight_augroup,
                    --         callback = vim.lsp.buf.clear_references,
                    --     })
                    --     vim.api.nvim_create_autocmd('LspDetach', {
                    --         group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                    --         callback = function(event2)
                    --             vim.lsp.buf.clear_references()
                    --             vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                    --         end,
                    --     })
                    -- end
                    -- The following code creates a keymap to toggle inlay hints in your
                    -- code, if the language server you are using supports them
                    if client and client:supports_method('textDocument/inlayHint', event.buf) then
                        map('<leader>lh', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                        end, '[L]anguage Inlay [H]ints')
                    end
                    -- Disable Ruff's hover in favor of Pyright
                    if client and client.name == 'ruff' then
                        client.server_capabilities.hoverProvider = false
                    end
                end,
            })
            -- Diagnostic Config
            -- See :help vim.diagnostic.Opts
            vim.diagnostic.config {
                severity_sort = true,
                float = { border = 'rounded', source = 'if_many' },
                underline = { severity = vim.diagnostic.severity.ERROR },
                signs = vim.g.have_nerd_font and {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '󰅚 ',
                        [vim.diagnostic.severity.WARN] = '󰀪 ',
                        [vim.diagnostic.severity.INFO] = '󰋽 ',
                        [vim.diagnostic.severity.HINT] = '󰌶 ',
                    },
                } or {},
                virtual_text = {
                    source = 'if_many',
                    spacing = 2,
                    format = function(diagnostic)
                        local diagnostic_message = {
                            [vim.diagnostic.severity.ERROR] = diagnostic.message,
                            [vim.diagnostic.severity.WARN] = diagnostic.message,
                            [vim.diagnostic.severity.INFO] = diagnostic.message,
                            [vim.diagnostic.severity.HINT] = diagnostic.message,
                        }
                        return diagnostic_message[diagnostic.severity]
                    end,
                },
            }
            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            -- Enable the following language servers
            --  Add any additional override configuration in the following tables. Available keys are:
            --  - cmd (table): Override the default command used to start the server
            --  - filetypes (table): Override the default list of associated filetypes for the server
            --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
            --  - settings (table): Override the default settings passed when initializing the server.
            --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
            local servers = {
                clangd = {},
                gopls = {},
                pyright = {
                    settings = {
                        pyright = {
                            disableOrganizeImports = true,
                        },
                    },
                },
                ruff = {},
                svelte = {},
                ts_ls = {},
                rust_analyzer = {},
                -- jdtls = {
                --     cmd = {
                --         '/opt/homebrew/opt/openjdk@23/bin/java',
                --         '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                --         '-Dosgi.bundles.defaultStartLevel=4',
                --         '-Declipse.product=org.eclipse.jdt.ls.core.product',
                --         -- '-Dlog.protocol=true',
                --         -- '-Dlog.level=ALL',
                --         '-Xmx1g',
                --         '--add-modules=ALL-SYSTEM',
                --         '--add-opens',
                --         'java.base/java.util=ALL-UNNAMED',
                --         '--add-opens',
                --         'java.base/java.lang=ALL-UNNAMED',
                --         '-jar',
                --         vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
                --         '-configuration',
                --         vim.fn.stdpath 'data' .. '/mason/packages/jdtls/' .. (vim.fn.has 'mac' == 1 and 'config_mac' or 'config_linux'),
                --         '-data',
                --         vim.fn.stdpath 'cache' .. '/jdtls_workspace',
                --     },
                --     filetypes = { 'java' },
                --     -- This simple root_dir function makes the LSP work on standalone files.
                --     root_dir = function(fname)
                --         return vim.fs.dirname(fname) or vim.loop.cwd()
                --     end,
                --     single_file_support = true,
                -- },
                bashls = {
                    filetypes = { 'sh', 'zsh' },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = 'LuaJIT' },
                            completion = {
                                callSnippet = 'Replace',
                            },
                            diagnostics = {
                                globals = { 'vim' },
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = { vim.env.VIMRUNTIME },
                            },
                        },
                    },
                },
                hyprls = {},
            }
            -- Merge blink capabilities into each server and register with native LSP API
            for name, server in pairs(servers) do
                server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                vim.lsp.config(name, server)
                vim.lsp.enable(name)
            end
            -- Special lua_ls config: inject Neovim runtime library (replaces lazydev.nvim)
            -- vim.lsp.config('lua_ls', {
            --     on_init = function(client)
            --         if client.workspace_folders then
            --             local path = client.workspace_folders[1].name
            --             if
            --                 path ~= vim.fn.stdpath 'config'
            --                 and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            --             then
            --                 return
            --             end
            --         end
            --         client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            --             runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
            --             workspace = {
            --                 checkThirdParty = false,
            --                 library = vim.api.nvim_get_runtime_file('', true),
            --             },
            --         })
            --     end,
            -- })
            -- Mason tool installer — ensure all servers + formatters/linters are installed
            local ensure_installed = {
                'bash-language-server',
                'lua-language-server',
                'hyprls',
                'stylua',
                'prettier',
                'clang-format',
                'shfmt',
                'pyright',
                'ruff',
                'gofumpt',
                'beautysh',
                'google-java-format',
                'shellcheck',
                'golangci-lint',
            }
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }
        end,
    },
}
