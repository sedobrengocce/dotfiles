return {
	"akinsho/flutter-tools.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim",
	},
	config = function()
		require("flutter-tools").setup({
			fvm = false,
			widget_guides = { enabled = true },
			lsp = {
				autostart = true,
				settings = {
					showtodos = true,
					completefunctioncalls = true,
					analysisExcludedFolders = {
						vim.fn.expand("$HOME/.pub-cache"),
					},
					renameFilesWithClasses = "prompt",
					updateImportsOnRename = true,
					enablesnippets = true,
					analysisOptions = { strict = true },
				},
			},
			debugger = {
				enabled = true,
				run_via_dap = true,
				exception_breakpoints = {},
				register_configurations = function(paths)
					local dap = require("dap")
					-- See also: https://github.com/akinsho/flutter-tools.nvim/pull/292
					dap.adapters.dart = {
						type = "executable",
						-- command = vim.fn.exepath('cmd.exe'),
						command = paths.flutter_bin,
						args = { "-v", "debug-adapter" }, --flutter_bin, "debug-adapter" },
						options = {
							detached = false,
						},
					}
					dap.configurations.dart = {
						{
							type = "dart",
							request = "launch",
							name = "Launch dart",
							dartSdkPath = "C:/flutter/flutter/bin/cache/dart-sdk/",
							flutterSdkPath = "C:/flutter/flutter/bin/",
							program = "${workspaceFolder}/lib/main.dart",
							cwd = "${workspaceFolder}",
						},
					}
					require("dap.ext.vscode").load_launchjs()
				end,
			},
		})
	end,
}
