if vim.g.vscode then
  return
end

vim.pack.add {
  { src = 'https://github.com/mfussenegger/nvim-dap' },
  { src = 'https://github.com/nvim-neotest/nvim-nio' },
  { src = 'https://github.com/rcarriga/nvim-dap-ui' },
  { src = 'https://github.com/theHamsta/nvim-dap-virtual-text' },
  { src = 'https://github.com/jay-babu/mason-nvim-dap.nvim' },
  { src = 'https://github.com/leoluz/nvim-dap-go' },
  { src = 'https://github.com/mfussenegger/nvim-dap-python' },
}

local dap = require 'dap'
local dapui = require 'dapui'

require('mason-nvim-dap').setup {
  ensure_installed = { 'delve', 'debugpy', 'js-debug-adapter', 'codelldb' },
  automatic_installation = true,
  handlers = {},
}

dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

require('nvim-dap-virtual-text').setup {}

vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn' })
vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'DiagnosticInfo' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticOk', linehl = 'Visual' })

dap.listeners.after.event_initialized['dapui_config'] = function()
  -- the terminal and the dap-ui panels compete for the bottom split
  require('kroka_2025.terminal').hide()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- Catches sessions that die without emitting terminated/exited (crashes,
-- adapter dropouts), which would otherwise leave stale virtual text behind
dap.listeners.after.disconnect['cleanup'] = function()
  require('nvim-dap-virtual-text').refresh()
end

-- Adapters

require('dap-go').setup()
require('dap-python').setup(vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python')

local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin/'

dap.adapters['pwa-node'] = {
  type = 'server',
  host = '127.0.0.1',
  port = '${port}',
  executable = {
    command = mason_bin .. 'js-debug-adapter',
    args = { '${port}' },
  },
}
dap.adapters['pwa-chrome'] = dap.adapters['pwa-node']

for _, lang in ipairs { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' } do
  dap.configurations[lang] = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch current file',
      program = '${file}',
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      skipFiles = { '<node_internals>/**', '**/node_modules/**' },
    },
    {
      type = 'pwa-node',
      request = 'attach',
      name = 'Attach to node process',
      processId = require('dap.utils').pick_process,
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      skipFiles = { '<node_internals>/**', '**/node_modules/**' },
    },
    {
      type = 'pwa-chrome',
      request = 'launch',
      name = 'Launch Chrome (localhost:5173)',
      url = 'http://localhost:5173',
      webRoot = '${workspaceFolder}',
      sourceMaps = true,
    },
  }
end

dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    command = mason_bin .. 'codelldb',
    args = { '--port', '${port}' },
  },
}

-- Compiled languages need a binary with debug symbols, not the source file.
-- Build the current file into a temp binary so <leader>dd just works.
local function compile_current_file()
  local src = vim.fn.expand '%:p'
  local out = vim.fn.stdpath 'cache' .. '/dap-build/' .. vim.fn.expand '%:t:r'
  vim.fn.mkdir(vim.fn.fnamemodify(out, ':h'), 'p')

  local compiler = vim.bo.filetype == 'cpp' and 'clang++' or 'clang'
  local result = vim.system({ compiler, '-g', '-O0', src, '-o', out }, { text = true }):wait()

  if result.code ~= 0 then
    vim.notify('Compile failed:\n' .. (result.stderr or ''), vim.log.levels.ERROR)
    return dap.ABORT
  end
  return out
end

for _, lang in ipairs { 'c', 'cpp' } do
  dap.configurations[lang] = {
    {
      name = 'Build and debug current file',
      type = 'codelldb',
      request = 'launch',
      program = compile_current_file,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
    },
    {
      name = 'Launch existing binary',
      type = 'codelldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
  }
end

dap.configurations.rust = {
  {
    name = 'Launch binary',
    type = 'codelldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

-- Keymaps

local nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = 'Debug: ' .. desc })
end

nmap('<leader>db', dap.toggle_breakpoint, 'Toggle breakpoint')
nmap('<leader>dB', function()
  vim.ui.input({ prompt = 'Breakpoint condition: ' }, function(cond)
    if cond and cond ~= '' then
      dap.set_breakpoint(cond)
    end
  end)
end, 'Conditional breakpoint')
nmap('<leader>dL', function()
  vim.ui.input({ prompt = 'Log point message: ' }, function(msg)
    if msg and msg ~= '' then
      dap.set_breakpoint(nil, nil, msg)
    end
  end)
end, 'Log point')

nmap('<leader>dd', dap.continue, 'Start/continue')
nmap('<leader>dq', function()
  -- terminate() is async; close() before the adapter's terminated event lands
  -- would strand the virtual text, so clean up in its callback
  dap.terminate({}, { terminateDebuggee = true }, function()
    dap.close()
    dapui.close()
    require('nvim-dap-virtual-text').refresh()
  end)
end, 'Stop debugger')
nmap('<leader>dx', function()
  dap.clear_breakpoints()
  vim.notify('All breakpoints removed', vim.log.levels.INFO)
end, 'Remove all breakpoints')

nmap('<leader>di', dap.step_into, 'Step into')
nmap('<leader>do', dap.step_over, 'Step over')
nmap('<leader>dO', dap.step_out, 'Step out')
nmap('<leader>dr', dap.repl.toggle, 'Toggle REPL')
nmap('<leader>du', dapui.toggle, 'Toggle UI')
nmap('<leader>dk', function()
  require('dapui').eval(nil, { enter = true })
end, 'Eval under cursor')

vim.keymap.set('v', '<leader>dk', function()
  require('dapui').eval(nil, { enter = true })
end, { desc = 'Debug: Eval selection' })

nmap('<F5>', dap.continue, 'Start/continue')
nmap('<F10>', dap.step_over, 'Step over')
nmap('<F11>', dap.step_into, 'Step into')
nmap('<F12>', dap.step_out, 'Step out')
