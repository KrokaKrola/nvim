vim.pack.add {
  { src = 'https://github.com/folke/tokyonight.nvim' },
}

require('tokyonight').setup {
  styles = {
    comments = { italic = false },
  },
  -- dim inactive splits so the focused one is obvious
  dim_inactive = true,
  on_highlights = function(hl, c)
    -- default separator is nearly the same as the background
    hl.WinSeparator = { fg = c.blue0, bold = true }
  end,
}

vim.cmd.colorscheme 'tokyonight-night'

-- thicker separator glyph than the default thin line
vim.opt.fillchars:append { vert = '│', horiz = '─' }

-- cursorline only in the focused window
local cursorline_group = vim.api.nvim_create_augroup('kroka-cursorline', { clear = true })

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
  group = cursorline_group,
  callback = function()
    if vim.bo.buftype == '' then
      vim.wo.cursorline = true
    end
  end,
})

vim.api.nvim_create_autocmd('WinLeave', {
  group = cursorline_group,
  callback = function()
    vim.wo.cursorline = false
  end,
})
