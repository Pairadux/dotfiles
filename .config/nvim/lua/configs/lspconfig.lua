local configs = require("nvchad.configs.lspconfig")
local lspconfig = require("lspconfig")

local servers = {
	html = {},
	cssls = {},
	tsserver = {},
	clangd = {},
	svelte = {},
	marksman = {},
	bashls = {},
	rust_analyzer = {},
	-- basedpyright = {
	-- 	settings = {
	-- 		pyright = {
	-- 			disableOrganizeImports = true,
	-- 		},
	-- 		python = {
	-- 			analysis = {
	-- 				ignore = { "*" },
	-- 			},
	-- 		},
	-- 	},
	-- },
	tailwindcss = {
		filetypes = { "html", "css", "svelte", "scss", "javascript", "typescript", "vue" },
	},
    -- pylsp = {
    --     settings = {
    --         pylsp = {
    --             plugins = {
    --                 pycodestyle = {
    --                     enabled = false
    --                 },
    --                 flake8 = {
    --                     enabled = false
    --                 },
    --                 pyflakes = {
    --                     enabled = false
    --                 },
    --                 pylint = {
    --                     enabled = false
    --                 },
    --                 rope = {
    --                     enabled = false
    --                 },
    --                 mccabe = {
    --                     enabled = false
    --                 },
    --             }
    --         }
    --     }
    -- },
    -- ruff_lsp = {},
    ruff = {},
    jqls = {},
    jsonls = {},
}

for name, opts in pairs(servers) do
	opts.on_init = configs.on_init
	opts.on_attach = configs.on_attach
	opts.capabilities = configs.capabilities

	lspconfig[name].setup(opts)
end

-- local nvchad_on_attach = configs.on_attach
-- local custom_on_attach = function(client, bufnr)
-- 	nvchad_on_attach()
-- 	if client.name == "ruff_lsp" then
-- 		-- Disable hover in favor of Pyright
-- 		client.server_capabilities.hoverProvider = false
-- 	end
-- end
--
-- lspconfig.ruff_lsp.setup({
-- 	on_init = configs.on_init,
-- 	on_attach = custom_on_attach,
-- 	capabilities = configs.capabilities,
-- })
