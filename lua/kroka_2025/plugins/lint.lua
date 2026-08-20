vim.pack.add {
  { src = 'https://github.com/mfussenegger/nvim-lint' },
}

local lint = require 'lint'

-- python omitted: ruff LSP already reports diagnostics
lint.linters_by_ft = {
  javascript = { 'eslint_d' },
  javascriptreact = { 'eslint_d' },
  typescript = { 'eslint_d' },
  typescriptreact = { 'eslint_d' },
  yaml = { 'yamllint' },
}

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('kroka-lint', { clear = true }),
  callback = function()
    local buftype = vim.bo.buftype
    if buftype ~= '' then
      return
    end
    if vim.api.nvim_win_get_config(0).relative ~= '' then
      return
    end
    lint.try_lint()
  end,
})
