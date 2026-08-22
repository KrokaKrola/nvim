local nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = desc })
end

-- Faster navigation
nmap('J', '5j', 'Move 5 lines down')
nmap('K', '5k', 'Move 5 lines up')

-- Comfortable additions
nmap('U', '<C-r>', 'Redo change')
nmap('H', '^', 'Go to the start of the line')
nmap('L', '$', 'Go to the end of the line')

-- Diagnostics
nmap('[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, 'Go to previous diagnostic')
nmap(']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, 'Go to next diagnostic')
nmap('<leader>e', vim.diagnostic.open_float, 'Show diagnostic error messages')
nmap('<leader>dl', function()
  vim.diagnostic.setloclist { open = true }
end, 'Diagnostics: location list')
nmap(']e', function()
  vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR, float = true }
end, 'Next error')
nmap('[e', function()
  vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR, float = true }
end, 'Previous error')

-- Window navigation
nmap('<C-h>', '<C-w><C-h>', 'Move focus to the left window')
nmap('<C-l>', '<C-w><C-l>', 'Move focus to the right window')
nmap('<C-j>', '<C-w><C-j>', 'Move focus to the lower window')
nmap('<C-k>', '<C-w><C-k>', 'Move focus to the upper window')

nmap('<Esc>', '<cmd>nohlsearch<CR>', 'Clear search highlight')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Quit
nmap('q', '<cmd>wqa<CR>', 'Write all and quit')
nmap('Q', '<cmd>qa!<CR>', 'Quit without saving')

-- macro recording, displaced by the q mapping above
nmap('<leader>q', 'q', 'Record macro')

local terminal = require 'kroka_2025.terminal'

nmap('<leader>j', terminal.toggle, 'Toggle terminal')
-- close from inside the terminal (<leader> is Space, unusable in terminal mode)
vim.keymap.set('t', '<C-q>', function()
  vim.cmd 'stopinsert'
  terminal.toggle()
end, { desc = 'Toggle terminal' })

-- window navigation from terminal mode, matching the normal-mode bindings
for _, key in ipairs { 'h', 'j', 'k', 'l' } do
  vim.keymap.set('t', '<C-' .. key .. '>', '<C-\\><C-n><C-w>' .. key, { desc = 'Move focus' })
end

-- Quickfix / location list
local function toggle_list(open_cmd, close_cmd, list_getter)
  return function()
    for _, win in ipairs(vim.fn.getwininfo()) do
      if win.quickfix == 1 and win.loclist == (open_cmd == 'lopen' and 1 or 0) then
        vim.cmd(close_cmd)
        return
      end
    end
    if vim.tbl_isempty(list_getter()) then
      vim.notify('List is empty', vim.log.levels.INFO)
      return
    end
    vim.cmd(open_cmd)
  end
end

nmap('<leader>xq', toggle_list('copen', 'cclose', vim.fn.getqflist), 'Toggle quickfix list')
nmap(
  '<leader>xl',
  toggle_list('lopen', 'lclose', function()
    return vim.fn.getloclist(0)
  end),
  'Toggle location list'
)

-- wrap around instead of erroring at the ends
local function cycle(next_cmd, first_cmd)
  return function()
    local ok = pcall(vim.cmd, next_cmd)
    if not ok then
      pcall(vim.cmd, first_cmd)
    end
  end
end

nmap(']q', cycle('cnext', 'cfirst'), 'Next quickfix entry')
nmap('[q', cycle('cprev', 'clast'), 'Previous quickfix entry')
nmap(']l', cycle('lnext', 'lfirst'), 'Next location list entry')
nmap('[l', cycle('lprev', 'llast'), 'Previous location list entry')
