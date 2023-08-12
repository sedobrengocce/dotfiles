vim.keymap.set('i', '<C-L>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<C-K>', '<Plug>(copilot-previous)')
vim.keymap.set('i', '<C-S>', '<Plug>(copilot-suggest)')
vim.api.nvim_set_keymap("i", "<C-\\>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.keymap.set('n', '<leader>cpp', vim.cmd.Copilot_panel)
vim.keymap.set('n', '<leader>cps', vim.cmd.Copilot_status)
vim.keymap.set('n', '<leader>cpe', vim.cmd.Copilot_enable)
vim.keymap.set('n', '<leader>cpd', vim.cmd.Copilot_disable)

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_auto_enable = true
