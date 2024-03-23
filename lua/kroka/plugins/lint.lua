return {
  { -- linting
    'mfussenegger/nvim-lint',
    event = { 'bufreadpre', 'bufnewfile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        json = { 'jsonlint' },
        csv = { 'csvlint' },
        yaml = { 'yamllint' },
        terraform = { 'tflint' },
        dockerfile = { 'hadolint' },
        -- javascript = { 'eslint' },
        -- typescript = { 'eslint' },
        -- javascriptreact = { 'eslint' },
        -- typescriptreact = { 'eslint' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'bufenter', 'bufwritepost', 'insertleave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
}
