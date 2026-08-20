-- Re-source the config without restarting.
-- Caveat: plugin setup() side effects and stale keymaps are not undone.
-- Restart for plugin spec changes (vim.pack.add) or anything that looks wrong
-- after a reload.
local M = {}

local prefix = 'kroka_2025'

function M.reload()
  -- clear autocmds this config owns so they are not registered twice
  for _, group in ipairs { 'kroka-lsp-attach', 'kroka-lint', 'kroka-treesitter', 'kroka-highlight-yank', 'kroka-statusline', 'kroka-cursorline' } do
    pcall(vim.api.nvim_del_augroup_by_name, group)
  end

  for name, _ in pairs(package.loaded) do
    if name:match('^' .. prefix) then
      package.loaded[name] = nil
    end
  end

  local ok, err = pcall(require, prefix)
  if not ok then
    vim.notify('Reload failed: ' .. tostring(err), vim.log.levels.ERROR)
    return
  end

  vim.cmd 'doautocmd FileType'
  vim.notify('Config reloaded', vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('ReloadConfig', M.reload, { desc = 'Reload nvim config' })

vim.keymap.set('n', '<leader>rc', M.reload, { desc = 'Reload config' })

return M
