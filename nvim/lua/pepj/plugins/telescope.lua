return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		{ "nvim-lua/popup.nvim" },
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-dap.nvim" },
		{ "mfussenegger/nvim-dap" },
		{ "nvim-telescope/telescope-file-browser.nvim" },
	},
	lazy = false,
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local fb_actions = telescope.extensions.file_browser.actions

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
						["<c-["] = actions.close,
					},
				},
			},
			extensions = {
				file_browser = {
					hidden = true,
					mappings = {
						n = {
							["h"] = telescope.extensions.file_browser.actions.goto_parent_dir,
							["l"] = actions.select_default,
						},
						i = {
							["<C-N>"] = fb_actions.create,
							["<C-R>"] = fb_actions.rename,
							["<C-D>"] = fb_actions.remove,
						},
					},
				},
			},
		})

		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>pf", function()
			builtin.find_files({
				find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" },
			})
		end)
		vim.keymap.set("n", "<C-p>", builtin.git_files, {})
		vim.keymap.set("n", "<leader>tbr", builtin.git_branches, {})
		vim.keymap.set("n", "<leader>tbf", builtin.buffers, {})
		vim.keymap.set("n", "<leader>ter", builtin.diagnostics, {})
		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)

		telescope.load_extension("dap")

		local dap = telescope.extensions.dap

		vim.keymap.set("n", "<leader>lbr", dap.list_breakpoints, {})

		telescope.load_extension("file_browser")

		vim.keymap.set("n", "<leader>pv", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", {})
	end,
}
