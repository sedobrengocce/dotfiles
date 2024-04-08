return {
    'mbbill/undotree',
    keys = {
        { "<leader>u",
            function()
                vim.cmd.UndotreeToggle()
            end,
            desc = "Toggle undotree"
        },
    },
    config = function()
        vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    end
}
