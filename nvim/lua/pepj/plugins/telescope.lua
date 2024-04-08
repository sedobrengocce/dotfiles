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
    keys = {
        { "<leader>pf",
            function()
                require("telescope.builtin").find_files({
                    find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" },
                })
            end,
            desc = "Find files",
        },
        { "<C-p>",
            function()
                require("telescope.builtin").git_files()
            end,
            desc = "Git files",
        },
        { "<leader>tbs",
            function()
                require("telescope.builtin").current_buffer_fuzzy_find()
            end,
            desc = "Current buffer fuzzy find",
        },
        { "<leader>tbr",
            function()
                require("telescope.builtin").git_branches()
            end,
            desc = "Git branches",
        },
        { "<leader>tbf",
            function()
                require("telescope.builtin").buffers()
            end,
            desc = "Buffers",
        },
        { "<leader>ter",
            function()
                require("telescope.builtin").diagnostics()
            end,
            desc = "Diagnostics",
        },
        { "<leader>ps",
            function()
                require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
            end,
            desc = "Grep string",
        },
        { "<leader>lbr",
            function()
                require("telescope.extensions.dap").list_breakpoints()
            end,
            desc = "List breakpoints",
        },
        { "<leader>pv",
            ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
            desc = "File browser",
        },
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

        telescope.load_extension("fzf")

		telescope.load_extension("dap")

		telescope.load_extension("file_browser")

	end,
}
