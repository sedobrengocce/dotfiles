local dap = require('dap')

vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, {})
vim.keymap.set('n', '<leader>B', function()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition > '));
end)
vim.keymap.set('n', '<F5>', dap.continue, {})
vim.keymap.set('n', '<F10>', dap.step_over, {})
vim.keymap.set('n', '<F11>', dap.step_into, {})
vim.keymap.set('n', '<F12>', dap.step_out, {})
vim.keymap.set('n', '<leader>dr', dap.repl.open, {})

require("nvim-dap-virtual-text").setup {
    enabled = true,                        -- enable this plugin (the default)
    enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = false,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true,               -- show stop reason when stopped for exceptions
    commented = false,                     -- prefix virtual text with comment string
    only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
    all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
    --- A callback that determines how a variable is displayed or whether it should be omitted
    --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
    --- @param buf number
    --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
    --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
    --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
    display_callback = function(variable, _buf, _stackframe, _node)
      return variable.name .. ' = ' .. variable.value
    end,

    -- experimental features:
    virt_text_pos = 'eol',                 -- position of virtual text, see `:h nvim_buf_set_extmark()`
    all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
                                           -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}

local dapui = require('dapui')

local dap = require('dap')
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
}

dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedConsole',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}

dap.adapters.dart = {
    type = "executable",
    command = "node",
    args = {"/Users/pepj2/Dart-Code/out/dist/debug.js", "flutter"}
  }
  dap.configurations.dart = {
    {
      type = "dart",
      request = "launch",
      name = "Launch flutter app",
      dartSdkPath = "/flutter/bin/cache/dart-sdk/",
      flutterSdkPath = "/flutter",
      program = "${workspaceFolder}/lib/main.dart",
      cwd = "${workspaceFolder}",
    }
}

dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
end
dap.listeners.after.event_terminated['dapui_config'] = function()
    dapui.close()
end
dap.listeners.after.event_exited['dapui_config'] = function()
    dapui.close()
end

vim.keymap.set('v', '<leader>e', '<cmd>lua require("dapui").eval()<CR>')
