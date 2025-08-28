return {
    "folke/todo-comments.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    opts = {},
    keys = {
        { "<leader>ttd", "<cmd>TodoTelescope<cr>" },
        { "<leader>ttr", "<cmd>TodoTrouble<cr>" },
    },
}
