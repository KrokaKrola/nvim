-- Bottom terminal, reusing the same buffer so shell state survives toggles
local M = {}

local term = { buf = nil, win = nil }

function M.is_open()
  return term.win ~= nil and vim.api.nvim_win_is_valid(term.win)
end

function M.hide()
  if M.is_open() then
    vim.api.nvim_win_hide(term.win)
  end
  term.win = nil
end

function M.toggle()
  if M.is_open() then
    M.hide()
    return
  end

  vim.cmd 'below 15split'
  term.win = vim.api.nvim_get_current_win()

  if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
    vim.api.nvim_win_set_buf(term.win, term.buf)
  else
    vim.cmd 'terminal'
    term.buf = vim.api.nvim_get_current_buf()
    vim.bo[term.buf].buflisted = false
  end

  vim.cmd 'startinsert'
end

return M
