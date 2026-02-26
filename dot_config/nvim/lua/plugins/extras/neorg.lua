return {
    {
        'nvim-neorg/neorg',
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
