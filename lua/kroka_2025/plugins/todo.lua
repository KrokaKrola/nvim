-- Commenting itself is built in since 0.11 (gcc / gc); this only adds
-- highlighting and search for TODO-style keywords.
vim.pack.add {
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/folke/todo-comments.nvim' },
}

require('todo-comments').setup {
  signs = false,
}

vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = 'Next todo comment' })

vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = 'Previous todo comment' })

vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope<CR>', { desc = 'Search todo comments' })
