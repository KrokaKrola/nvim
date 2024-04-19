if vim.g.vscode then
  return {}
end

return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
}
