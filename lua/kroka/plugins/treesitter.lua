if vim.g.vscode then
  return {}
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    -- vim.g.loaded_nvim_treesitter=1 (set in lazy.lua) blocks the plugin file,
    -- so query_predicates never loads. We only want parsers + query files on rtp.
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },
}
