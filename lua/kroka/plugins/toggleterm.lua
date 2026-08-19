if vim.g.vscode then
  return {}
end

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = 15,
    open_mapping = [[<C-Space>]],
    direction = "float",
    shade_terminals = true,
  },
  keys = {
    { "<C-Space>", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal", mode = { "n", "t" } },
    { "<leader>tt", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle horizontal terminal" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle float terminal" },
  },
}
