-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

local mason_dap = require 'mason-nvim-dap'
local dap = require 'dap'
local ui = require 'dapui'
local dap_virtual_text = require 'nvim-dap-virtual-text'

-- Dap Virtual Text
dap_virtual_text.setup { enabled = true, commented = true }

mason_dap.setup {
  ensure_installed = { 'cppdbg', 'python' },
  automatic_installation = true,
  handlers = {
    function(config)
      require('mason-nvim-dap').default_setup(config)
    end,
  },
}

-- Configurations
dap.configurations = {
  c = {
    {
      name = 'Launch file',
      type = 'cppdbg',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopAtEntry = false,
      MIMode = 'lldb',
    },
    {
      name = 'Attach to lldbserver :1234',
      type = 'cppdbg',
      request = 'launch',
      MIMode = 'lldb',
      miDebuggerServerAddress = 'localhost:1234',
      miDebuggerPath = '/usr/bin/lldb',
      cwd = '${workspaceFolder}',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
    },
  },
  python = {
    {
      -- The first three options are required by nvim-dap
      type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
      request = 'launch',
      name = 'Launch file',

      -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

      program = '${file}', -- This configuration will launch the current file if used.
      pythonPath = function()
        -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
        -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
        -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
        local cwd = vim.fn.getcwd()
        if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
          return cwd .. '/venv/bin/python'
        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
          return cwd .. '/.venv/bin/python'
        else
          return '/usr/bin/python'
        end
      end,
    },
  },
}

-- Dap UI

ui.setup()

vim.fn.sign_define('DapBreakpoint', { text = '🐞' })

dap.listeners.before.attach.dapui_config = function()
  ui.open()
end
dap.listeners.before.launch.dapui_config = function()
  ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  ui.close()
end

vim.keymap.set('n', '<F5>', function()
  require('dap').continue()
end, { desc = 'DAP: Continue', nowait = true, remap = false })

vim.keymap.set('n', '<F10>', function()
  require('dap').step_over()
end, { desc = 'DAP: Step Over', nowait = true, remap = false })

vim.keymap.set('n', '<F11>', function()
  require('dap').step_into()
end, { desc = 'DAP: Step Into', nowait = true, remap = false })

vim.keymap.set('n', '<F23>', function()
  require('dap').step_out()
end, { desc = 'DAP: Step Out', nowait = true, remap = false })

local wk = require 'which-key'
wk.add {
  -- Debugger
  {
    '<leader>d',
    group = 'Debugger 🐞',
    nowait = true,
    remap = false,
  },
  {
    '<leader>dt',
    function()
      require('dap').toggle_breakpoint()
    end,
    desc = 'Toggle Breakpoint',
    nowait = true,
    remap = false,
  },
  {
    '<leader>dc',
    function()
      require('dap').continue()
    end,
    desc = 'Continue',
    nowait = true,
    remap = false,
  },
  {
    '<leader>di',
    function()
      require('dap').step_into()
    end,
    desc = 'Step Into',
    nowait = true,
    remap = false,
  },
  {
    '<leader>do',
    function()
      require('dap').step_over()
    end,
    desc = 'Step Over',
    nowait = true,
    remap = false,
  },
  {
    '<leader>du',
    function()
      require('dap').step_out()
    end,
    desc = 'Step Out',
    nowait = true,
    remap = false,
  },
  {
    '<leader>dr',
    function()
      require('dap').repl.open()
    end,
    desc = 'Open REPL',
    nowait = true,
    remap = false,
  },
  {
    '<leader>dl',
    function()
      require('dap').run_last()
    end,
    desc = 'Run Last',
    nowait = true,
    remap = false,
  },
  {
    '<leader>dq',
    function()
      require('dap').terminate()
      require('dapui').close()
      require('nvim-dap-virtual-text').toggle()
    end,
    desc = 'Terminate',
    nowait = true,
    remap = false,
  },
  {
    '<leader>db',
    function()
      require('dap').list_breakpoints()
    end,
    desc = 'List Breakpoints',
    nowait = true,
    remap = false,
  },
  {
    '<leader>de',
    function()
      require('dap').set_exception_breakpoints { 'all' }
    end,
    desc = 'Set Exception Breakpoints',
    nowait = true,
    remap = false,
  },
}

return {}
