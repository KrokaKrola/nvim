vim.pack.add {
  { src = 'https://github.com/folke/persistence.nvim' },
}

require('persistence').setup {}

vim.keymap.set('n', '<leader>Sr', function()
  require('persistence').load()
end, { desc = 'Session: restore for cwd' })

vim.keymap.set('n', '<leader>Sl', function()
  require('persistence').load { last = true }
end, { desc = 'Session: restore last' })

vim.keymap.set('n', '<leader>Sd', function()
  require('persistence').stop()
end, { desc = 'Session: stop saving' })
