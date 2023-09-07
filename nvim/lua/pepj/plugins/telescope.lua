return {

    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { 
        {'nvim-lua/popup.nvim'}, 
        {'nvim-lua/plenary.nvim'},
        {'nvim-telescope/telescope-dap.nvim'},
        {'mfussenegger/nvim-dap'},
    },
    lazy = false,
    config = function()
        local builtin = require("telescope.builtin")

        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") });
        end)

        local telescope = require("telescope")
        telescope.load_extension('dap')

        local dap = telescope.extensions.dap

        vim.keymap.set('n', '<leader>lbr', dap.list_breakpoints, {})

    end
}
