vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local d = ev.data
    if d.spec.name == 'telescope-fzf-native.nvim' and (d.kind == 'install' or d.kind == 'update') then
      vim.system({ 'make' }, { cwd = d.path }):wait()
    end
  end,
})

vim.pack.add {
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim', version = 'master' },
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' },
}

require('telescope').setup {
  defaults = {
    -- fd is faster than the default finder and honours .gitignore
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
  },
  pickers = {
    find_files = {
      find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix', '--hidden', '--exclude', '.git' },
    },
  },
  extensions = {
    fzf = {},
  },
}

pcall(require('telescope').load_extension, 'fzf')

local builtin = require 'telescope.builtin'

vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Search files' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Search by grep' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search help' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Search keymaps' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search diagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Resume last search' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find buffers' })
