vim.pack.add {
  { src = 'https://github.com/stevearc/oil.nvim' },
}

require('oil').setup {
  default_file_explorer = true,
  delete_to_trash = true,
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ['<C-h>'] = false,
    ['<C-l>'] = false,
    ['q'] = 'actions.close',
  },
}

vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })
vim.keymap.set('n', '<leader>-', function()
  require('oil').open_float()
end, { desc = 'Open parent directory (float)' })
