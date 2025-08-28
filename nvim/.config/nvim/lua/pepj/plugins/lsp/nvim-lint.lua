return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters.flutter_analyze = {
			cmd = "flutter",
			args = { "analyze", "--no-fatal-infos", "--no-fatal-warnings", "$FILENAME" },
			stream = "stdout",
			ignore_exitcode = true,
			parser = function(output, _)
				local diagnostics = {}
				for line in output:gmatch("[^\r\n]+") do
					local file, line_num, col_num, message = line:match("^(.-):(%d+):(%d+): (.+)$")
					if file and line_num and col_num and message then
						table.insert(diagnostics, {
							filename = file,
							lnum = tonumber(line_num) - 1,
							col = tonumber(col_num),
							message = message,
							severity = vim.lsp.protocol.DiagnosticSeverity.Warning,
						})
					end
				end
				return diagnostics
			end,
		}

		lint.linters_by_ft = {
			lua = { "luacheck" },
			javascript = { "eslint" },
			typescript = { "eslint" },
			html = { "eslint" },
			css = { "stylelint" },
			json = { "eslint" },
			yaml = { "yamllint" },
			markdown = { "markdownlint" },
			sh = { "shellcheck" },
			go = { "golangcilint" },
			cpp = { "clang_check" },
			c = { "clang_check" },
			bash = { "bach" },
			dart = { "flutter_analyze" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
