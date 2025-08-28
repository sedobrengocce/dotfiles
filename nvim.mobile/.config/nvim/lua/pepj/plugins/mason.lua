return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"html",
			"cssls",
			"emmet_ls",
			"gopls",
			"marksman",
			"omnisharp",
			"bashls",
			"jsonls",
			"yamlls",
		},
		automatic_enable = {
			exclude = { "dartls" },
		},
	},
	dependencies = {
		{
			"mason-org/mason.nvim",
			opts = {
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			},
		},
	},
	config = function(_, opts)
		require("mason-lspconfig").setup(opts)
		local keyOpts = { noremap = true, silent = true }
		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				keyOpts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", keyOpts)
				keyOpts.desc = "Go to Definition"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", keyOpts)
				keyOpts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, keyOpts)
				keyOpts.desc = "Go to Implementation"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", keyOpts)
				keyOpts.desc = "Show available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, keyOpts)
				keyOpts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, keyOpts)
				keyOpts.desc = "Show diagnostics"
				keymap.set("n", "<leader>cd", "<cmd>Telescope diagnostics<CR>", keyOpts)
				keyOpts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>cD", vim.diagnostic.open_float, keyOpts)
				keyOpts.desc = "Show documentation"
				keymap.set("n", "K", vim.lsp.buf.hover, keyOpts)
				keyOpts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, keyOpts)
				keyOpts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, keyOpts)
				if client.name == "marksman" then
					keyOpts.desc = "Convert to PDF"
					keymap.set("n", "<leader>pdf", ":!pandoc % -o %:r.pdf<CR>", keyOpts)
				end
			end,
		})
	end,
}
