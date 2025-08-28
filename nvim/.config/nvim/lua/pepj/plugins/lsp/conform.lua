return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			sh = { "shfmt" },
			go = { "gofmt" },
			cpp = { "clang_format" },
			c = { "clang_format" },
			bash = { "shfmt" },
			dart = { "dart_format" },
		},
		format_on_save = false,
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function(_, opts)
		local conform = require("conform")
		conform.setup(opts)
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function()
				conform.format({ async = false })
			end,
		})
	end,
}
