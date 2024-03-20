return {
	"marko-cerovac/material.nvim",
	dependencies = {
		"nvim-lualine/lualine.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	priority = 1000,
	config = function()
		vim.g.material_style = "darker"

		local lualine = require("lualine")
		local lazy_status = require("lazy.status")
		lualine.setup({
			options = {
				theme = "material",
			},
			sections = {
				lualine_a = {
					{
						"buffers",

						show_filename_only = true,
						hide_filename_extension = false,
						show_modified_status = true,

						mode = 0,

						filetype_names = {
							TelescopePrompt = "Telescope",
							dashboard = "Dashboard",
							packer = "Packer",
							fzf = "FZF",
							alpha = "Alpha",
						},

						use_mode_colors = false,

						symbols = {
							modified = " ",
							readonly = "",
							directory = "",
							alternate_file = "#",
						},
					},
				},
				lualine_x = {
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					{ "encoding" },
					{ "fileformat" },
					{ "filetype" },
				},
			},
		})

		local material = require("material")
		material.setup({

			contrast = {
				terminal = false, -- Enable contrast for the built-in terminal
				sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
				floating_windows = false, -- Enable contrast for floating windows
				cursor_line = false, -- Enable darker background for the cursor line
				non_current_windows = false, -- Enable darker background for non-current windows
				filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
			},

			styles = { -- Give comments style such as bold, italic, underline etc.
				comments = { --[[ italic = true ]]
				},
				strings = { --[[ bold = true ]]
				},
				keywords = { --[[ underline = true ]]
				},
				functions = { --[[ bold = true, undercurl = true ]]
				},
				variables = {},
				operators = {},
				types = {},
			},

			plugins = { -- Uncomment the plugins that you use to highlight them
				-- Available plugins:
				-- "dap",
				-- "dashboard",
				"gitsigns",
				-- "hop",
				-- "indent-blankline",
				-- "lspsaga",
				-- "mini",
				-- "neogit",
				"nvim-cmp",
				-- "nvim-navic",
				-- "nvim-tree",
				-- "nvim-web-devicons",
				-- "sneak",
				"telescope",
				-- "trouble",
				"which-key",
			},
			disable = {
				colored_cursor = false, -- Disable the colored cursor
				borders = false, -- Disable borders between verticaly split windows
				background = false, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
				term_colors = false, -- Prevent the theme from setting terminal colors
				eob_lines = false, -- Hide the end-of-buffer lines
			},
			high_visibility = {
				lighter = false, -- Enable higher contrast text for lighter style
				darker = false, -- Enable higher contrast text for darker style
			},
			lualine_style = "stealth", -- Lualine style ( can be 'stealth' or 'default' )
			async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)
			custom_colors = nil, -- If you want to everride the default colors, set this to a function
			custom_highlights = {}, -- Overwrite highlights with your own
		})
		vim.cmd([[colorscheme material]])
	end,
}
