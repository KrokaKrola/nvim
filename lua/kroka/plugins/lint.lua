if vim.g.vscode then
  return {}
end

return {
  { -- linting
    'mfussenegger/nvim-lint',
    event = { 'bufreadpre', 'bufnewfile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        -- Python: ruff is a fast linter (note: ruff LSP already provides linting,
        -- so this is optional/redundant if you have ruff LSP enabled)
        python = { 'ruff' },
        -- csv = { 'csvlint' },
        -- yaml = { 'yamllint' },
        -- terraform = { 'tflint' },
        -- dockerfile = { 'hadolint' },
        -- javascript = { 'eslint' },
        -- typescript = { 'eslint' },
        -- javascriptreact = { 'eslint' },
        -- typescriptreact = { 'eslint' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Don't lint in floating windows (like hover docs) or special buffers
          local buftype = vim.bo.buftype
          if buftype == 'nofile' or buftype == 'prompt' or buftype == 'popup' then
            return
          end

          -- Skip floating windows
          local win = vim.api.nvim_get_current_win()
          local win_config = vim.api.nvim_win_get_config(win)
          if win_config.relative ~= '' then
            return
          end

          require('lint').try_lint()
        end,
      })
    end,
  },
}
