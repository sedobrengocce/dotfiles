return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")
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
            dart = { "dartanalyzer" },
        }
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
