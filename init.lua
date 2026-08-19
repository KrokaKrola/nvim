require 'kroka'

if vim.g.vscode then
  vim.cmd 'source $HOME/.config/nvim/vscode/settings.vim'
  vim.keymap.set('n', '<leader>dx', function()
    require('vscode').action('workbench.debug.viewlet.action.disableAllBreakpoints')
  end, { desc = 'Debug: Remove All Breakpoints' })
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
