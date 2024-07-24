return {
	"williamboman/mason-lspconfig.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		{
			"williamboman/mason.nvim",
			config = function()
				-- import mason
				local mason = require("mason")

				-- enable mason and configure icons
				mason.setup({
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				})
			end,
		},
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		local keymap = vim.keymap -- for conciseness

		local opts = { noremap = true, silent = true }

		local on_attach = function(_, bufnr)
			opts.buffer = bufnr

			-- set keybinds
			opts.desc = "Show LSP references"
			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

			opts.desc = "Go to declaration"
			keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

			opts.desc = "Show LSP definitions"
			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

			opts.desc = "Show LSP implementations"
			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

			opts.desc = "Show LSP type definitions"
			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

			opts.desc = "See available code actions"
			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

			opts.desc = "Smart rename"
			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

			opts.desc = "Show buffer diagnostics"
			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

			opts.desc = "Show line diagnostics"
			keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

			opts.desc = "Show documentation for what is under cursor"
			keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

			opts.desc = "Restart LSP"
			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
		end

		local md_on_attach = function(client, bufnr)
			keymap.set("n", "<leader>pdf", ":!pandoc % -o %.pdf<CR>")
			on_attach(client, bufnr)
		end

		local dart_on_attach = function(client, bufnr)
			keymap.set("n", "<leader>df", ":!dart format .<CR>")
			on_attach(client, bufnr)
		end

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

        vim.filetype.add({ extension = { templ = "templ" } })

		local masonLspconfig = require("mason-lspconfig")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilites = cmp_lsp.default_capabilities()
		masonLspconfig.setup({
			ensure_installed = {
				"lua_ls",
				"marksman",
				"kotlin_language_server",
				"gopls",
				"tsserver",
				"cssls",
				"html",
				"htmx",
				"tailwindcss",
				"arduino_language_server",
				"dockerls",
				"docker_compose_language_service",
				"eslint",
				"intelephense",
                "ccls",
                "cmake",
                "templ",
			},

			handlers = {
				function(server_name)
					lspconfig[server_name].setup({
						capabilites = capabilites,
						on_attach = on_attach,
					})
				end,
				["marksman"] = function()
					lspconfig["marksman"].setup({
						on_attach = md_on_attach,
					})
				end,
				["dartls"] = function()
					lspconfig["dartls"].setup({
						on_attach = dart_on_attach,
					})
				end,
                ["htmx"] = function()
                    lspconfig["htmx"].setup({
                        on_attach = on_attach,
                        capabilities = capabilites,
                        filetypes = { "htmx", "templ" },
                    })
                end,
                ["templ"] = function()
                    lspconfig["temlp"].setup({
                        on_attach = on_attach,
                        capabilities = capabilites,
                    })
                end,
				["gopls"] = function()
					lspconfig["gopls"].setup({
						on_attach = on_attach,
						filetypes = { "go", "gomod", "gowork", "gotmpl" },
						root_dir = lspconfig.util.root_pattern("go.mod", "go.work", ".git"),
						settings = {
							gopls = {
								completeUnimported = true,
								usePlaceholders = true,
								analyses = {
									unusedparams = true,
								},
							},
						},
					})
				end,
				["lua_ls"] = function()
					lspconfig["lua_ls"].setup({
						on_attach = on_attach,
						settings = { -- custom settings for lua
							Lua = {
								-- make the language server recognize "vim" global
								diagnostics = {
									globals = { "vim" },
								},
								workspace = {
									-- make language server aware of runtime files
									library = {
										[vim.fn.expand("$VIMRUNTIME/lua")] = true,
										[vim.fn.stdpath("config") .. "/lua"] = true,
									},
								},
							},
						},
					})
				end,
			},
		})
	end,
}
