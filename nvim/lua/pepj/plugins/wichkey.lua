return {
    'folke/which-key.nvim',
    config = function()
        whichKey = require("which-key");

        vim.o.timeou = true;
        vim.o.timeoutlen = 500;

        whichKey.setup {}
    end
}
