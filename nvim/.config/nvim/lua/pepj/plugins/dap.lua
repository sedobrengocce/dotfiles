return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			"rcarriga/nvim-dap-ui",
			config = function()
				local dap, dapui = require("dap"), require("dapui")
				dapui.setup()
				dap.listeners.after.event_initialized["dapui_config"] = function()
					dapui.open()
				end
				dap.listeners.before.event_terminated["dapui_config"] = function()
					dapui.close()
				end
				dap.listeners.before.event_exited["dapui_config"] = function()
					dapui.close()
				end

				vim.keymap.set("v", "<leader>e", '<cmd>lua require("dapui").eval()<CR>', { desc = "Evaluate" })
			end,
		},
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				virt_text_pos = "eol",
				all_frames = false,
				virt_line = false,
				virt_text_win_col = nil,
			},
		},
		"nvim-neotest/nvim-nio",
	},
	keys = {
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Continue",
		},
		{
			"<F10>",
			function()
				require("dap").step_over()
			end,
			desc = "Step Over",
		},
		{
			"<F11>",
			function()
				require("dap").step_into()
			end,
			desc = "Step Into",
		},
		{
			"<F12>",
			function()
				require("dap").step_out()
			end,
			desc = "Step Out",
		},
		{
			"<leader>b",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle Breakpoint",
		},
		{
			"<leader>B",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Set Breakpoint",
		},
		{
			"<leader>lp",
			function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end,
			desc = "Set Log Point",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.open()
			end,
			desc = "Open REPL",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "Run Last",
		},
	},
	config = function()
		local dap = require("dap")

		dap.adapters.delve = {
			type = "server",
			port = "${port}",
			executable = {
				command = "dlv",
				args = { "dap", "-l", "127.0.0.1:${port}" },
			},
		}

		dap.configurations.go = {
			{
				type = "delve",
				name = "Debug",
				request = "launch",
				program = "${file}",
			},
			{
				type = "delve",
				name = "Debug test",
				mode = "test",
				request = "launch",
				program = "${file}",
			},
			{
				type = "delve",
				name = "Debug test (go.mod)",
				mode = "test",
				request = "launch",
				program = "./${relativeFileDirname}",
			},
		}

		dap.configurations.dart = {
			{
				type = "dart",
				request = "launch",
				name = "Launch dart",
				dartSdkPath = "/home/pepj/development/flutter/bin/cache/dart-sdk/bin/dart", -- ensure this is correct
				flutterSdkPath = "/home/pepj/development/flutter/bin/flutter", -- ensure this is correct
				program = "${workspaceFolder}/lib/main.dart", -- ensure this is correct
				cwd = "${workspaceFolder}",
			},
			{
				type = "flutter",
				request = "launch",
				name = "Launch flutter",
				dartSdkPath = "/home/pepj/development/flutter/bin/cache/dart-sdk/bin/dart", -- ensure this is correct
				flutterSdkPath = "/home/pepj/development/flutter/bin/flutter", -- ensure this is correct
				program = "${workspaceFolder}/lib/main.dart", -- ensure this is correct
				cwd = "${workspaceFolder}",
			},
		}

		dap.adapters.dart = {
			type = "executable",
			command = "dart",
			args = { "debug_adapter" },
			options = {
				detached = false,
			},
		}
		dap.adapters.flutter = {
			type = "executable",
			command = "flutter",
			args = { "debug_adapter" },
			options = {
				detached = false,
			},
		}

		dap.adapters.gdb = {
			type = "executable",
			command = "gdb",
			args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
		}

		dap.configurations.c = {
			{
				name = "Launch",
				type = "gdb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopAtBeginningOfMainSubprogram = false,
			},
			{
				name = "Select and attach to process",
				type = "gdb",
				request = "attach",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				pid = function()
					local name = vim.fn.input("Executable name (filter): ")
					return require("dap.utils").pick_process({ filter = name })
				end,
				cwd = "${workspaceFolder}",
			},
			{
				name = "Attach to gdbserver :1234",
				type = "gdb",
				request = "attach",
				target = "localhost:1234",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
			},
		}

		dap.configurations.cpp = dap.configurations.c
	end,
}
