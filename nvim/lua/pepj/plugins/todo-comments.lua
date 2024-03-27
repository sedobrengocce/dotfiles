return {
    "folke/todo-comments.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    opts = {},
    keys = {
        { "n", "<leader>ttd", "<cmd>TodoTelescope<cr>" },
        { "n", "<leader>ttr", "<cmd>TodoToruble<cr>" },
    },
}
