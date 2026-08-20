vim.pack.add {
  { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
  { src = 'https://github.com/nvim-lualine/lualine.nvim' },
}

require('nvim-web-devicons').setup {}

local function set_highlights()
  local hl = vim.api.nvim_set_hl
  hl(0, 'StatusLineLsp', { fg = '#ffacf0', bold = true })
  hl(0, 'StatusLineDiagErr', { fg = '#ffffff', bg = '#fa1000', bold = true })
  hl(0, 'StatusLineDiagWarn', { fg = '#773300', bg = '#ffac00', bold = true })
  hl(0, 'StatusLineDiagInfo', { fg = '#111133', bg = '#0facf0', bold = true })
  hl(0, 'StatusLineDiagHint', { fg = '#ffffff', bg = '#00b070', bold = true })
end

set_highlights()

-- colorscheme changes reset custom groups
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('kroka-statusline', { clear = true }),
  callback = set_highlights,
})

local mode_colors = {
  n = '#89b4fa',
  i = '#a6e3a1',
  v = '#f9e2af',
  V = '#f9e2af',
  ['\22'] = '#f9e2af',
  c = '#fab387',
  R = '#f38ba8',
  t = '#94e2d5',
}

local function lsp_names()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    return ''
  end
  local names = {}
  for _, c in ipairs(clients) do
    table.insert(names, c.name)
  end
  return '[' .. table.concat(names, ',') .. ']'
end

require('lualine').setup {
  options = {
    theme = 'tokyonight',
    globalstatus = true,
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_a = {
      {
        'mode',
        color = function()
          local m = vim.api.nvim_get_mode().mode
          return { bg = mode_colors[m] or mode_colors[m:sub(1, 1)] or mode_colors.n, fg = '#1e1e2e', gui = 'bold' }
        end,
      },
    },
    lualine_b = {
      { 'filename', path = 1, symbols = { modified = ' [+]', readonly = ' [-]' } },
    },
    lualine_c = {},
    lualine_x = {
      { 'branch', icon = '' },
      { 'location' },
      { 'filetype', colored = true, icon_only = true, padding = { left = 1, right = 0 } },
      { lsp_names, color = 'StatusLineLsp' },
      {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        diagnostics_color = {
          error = 'StatusLineDiagErr',
          warn = 'StatusLineDiagWarn',
          info = 'StatusLineDiagInfo',
          hint = 'StatusLineDiagHint',
        },
      },
    },
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { 'oil' },
}
