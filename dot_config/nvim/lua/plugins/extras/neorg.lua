return {
    'nvim-neorg/neorg',
    lazy = false,
    version = '*',
    config = require('neorg').setup {
        load = {
            ['core.defaults'] = {},
            ['core.concealer'] = {},
        },
    },
}
