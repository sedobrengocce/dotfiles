return {
    'folke/which-key.nvim',
    event = "VeryLazy",
    config = function()
        local whichKey = require("which-key");

        vim.o.timeou = true;
        vim.o.timeoutlen = 500;

        whichKey.setup {}
    end
}
