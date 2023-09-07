--- Copilot

        vim.keymap.set('i', '<C-L>', '<Plug>(copilot-next)')
        vim.keymap.set('i', '<C-H>', '<Plug>(copilot-previous)')
        vim.keymap.set('i', '<C-S>', '<Plug>(copilot-suggest)')
        vim.api.nvim_set_keymap("i", "<C-\\>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
        vim.keymap.set('n', '<leader>cpp', vim.cmd.Copilot_panel)
        vim.keymap.set('n', '<leader>cps', vim.cmd.Copilot_status)
        vim.keymap.set('n', '<leader>cpe', vim.cmd.Copilot_enable)
        vim.keymap.set('n', '<leader>cpd', vim.cmd.Copilot_disable)

--- Fugitive
        vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
        vim.keymap.set('n', '<leader>gd', vim.cmd.Gvdiffsplit)
        vim.keymap.set('n', '<leader>gb', ':Git blame<CR>')
        vim.keymap.set('n', '<leader>gpl', ':Git pull<CR>')
        vim.keymap.set('n', '<leader>gps', ':Git push<CR>')
        vim.keymap.set('n', '<leader>gmc', ':Gvdiffspilt!<CR>')


