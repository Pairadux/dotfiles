local configs = require("nvchad.configs.lspconfig")

local servers = {
    html = {},
    cssls = {},
    tsserver = {},
    clangd = {},
    svelte = {},
    marksman = {},
    bashls = {},
    rust_analyzer = {},
    pyright = {},
    tailwindcss = {
        filetypes = { "html", "css", "svelte", "scss", "javascript", "typescript", "vue" }
    }
}

for name, opts in pairs(servers) do
  opts.on_init = configs.on_init
  opts.on_attach = configs.on_attach
  opts.capabilities = configs.capabilities

  require("lspconfig")[name].setup(opts)
end
