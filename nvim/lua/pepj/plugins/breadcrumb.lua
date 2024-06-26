return   {
    "SmiteshP/nvim-navic",
    dependencies = {
        "LunarVim/breadcrumbs.nvim",
        config = function()
            require("breadcrumbs").setup()
        end,
    },

    config = function()
        local icons = require("pepj.icons")
        require("nvim-navic").setup({
            highlight = true,
            lsp = {
                auto_attach = true,
                preference = { "typescript-tools" },
            },
            click = true,
            separator = " " .. icons.ui.ChevronRight .. " ",
            depth_limit = 0,
            depth_limit_indicator = "..",
            icons = {
                File = " ",
                Module = " ",
                Namespace = " ",
                Package = " ",
                Class = " ",
                Method = " ",
                Property = " ",
                Field = " ",
                Constructor = " ",
                Enum = " ",
                Interface = " ",
                Function = " ",
                Variable = " ",
                Constant = " ",
                String = " ",
                Number = " ",
                Boolean = " ",
                Array = " ",
                Object = " ",
                Key = " ",
                Null = " ",
                EnumMember = " ",
                Struct = " ",
                Event = " ",
                Operator = " ",
                TypeParameter = " ",
            },
        })
    end,
}
