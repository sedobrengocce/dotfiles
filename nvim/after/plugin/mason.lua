local mason = require('mason')
local masonNvimDap = require('mason-nvim-dap')

mason.setup()
masonNvimDap.setup({
    ensure_installed = {'dart'},
    handlers = {},
})
