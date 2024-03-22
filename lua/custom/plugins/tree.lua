return {
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local nvm_tree = require 'nvim-tree'

      nvm_tree.setup()

      local api = require 'nvim-tree.api'

      vim.keymap.set('n', '<leader>E', api.tree.toggle, { desc = 'Open explorer view' })
      vim.keymap.set('n', '<leader>0', api.tree.open, { desc = 'Focus explorer, open if closed' })
    end,
  },
}
