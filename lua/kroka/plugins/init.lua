if vim.g.vscode then
  return {
    'numToStr/Comment.nvim',
    'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  }
end

return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'github/copilot.vim',
  { 'numToStr/Comment.nvim', opts = {} },
}
