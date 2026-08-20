vim.pack.add {
  { src = 'https://github.com/folke/which-key.nvim' },
}

local wk = require 'which-key'

wk.setup {
  preset = 'modern',
  delay = function(ctx)
    return ctx.plugin and 0 or 300
  end,
  icons = {
    mappings = false,
    rules = false,
    separator = '→',
    group = '+',
    -- plain text instead of nerd-font glyphs for modifier keys
    keys = {
      Up = '<Up> ',
      Down = '<Down> ',
      Left = '<Left> ',
      Right = '<Right> ',
      C = 'C-',
      M = 'M-',
      D = 'D-',
      S = 'S-',
      CR = '<CR> ',
      Esc = '<Esc> ',
      NL = '<NL> ',
      BS = '<BS> ',
      Space = '<Space> ',
      Tab = '<Tab> ',
      ScrollWheelDown = '<ScrollWheelDown> ',
      ScrollWheelUp = '<ScrollWheelUp> ',
      F1 = '<F1> ',
      F2 = '<F2> ',
      F3 = '<F3> ',
      F4 = '<F4> ',
      F5 = '<F5> ',
      F6 = '<F6> ',
      F7 = '<F7> ',
      F8 = '<F8> ',
      F9 = '<F9> ',
      F10 = '<F10> ',
      F11 = '<F11> ',
      F12 = '<F12> ',
    },
  },
  win = {
    width = { min = 20, max = 0.6 },
    height = { min = 4, max = 20 },
    padding = { 0, 1 },
    title = false,
    border = 'rounded',
  },
  layout = {
    width = { min = 12, max = 28 },
    spacing = 1,
  },
  show_help = false,
  show_keys = false,
}

wk.add {
  { '<leader>s', group = 'Search' },
  { '<leader>r', group = 'Refactor' },
  { '<leader>h', group = 'Git hunk' },
  { '<leader>d', group = 'Document/Diagnostics' },
  { '<leader>w', group = 'Workspace' },
  { '<leader>c', group = 'Code' },
  { '<leader>t', group = 'Toggle' },
  { '<leader>S', group = 'Session' },
  { '<leader>f', desc = 'Format buffer' },
  { '<leader>j', desc = 'Toggle terminal' },
  { '<leader>e', desc = 'Diagnostic float' },
  { '<leader>q', desc = 'Record macro' },
  { '<leader>-', desc = 'Oil (float)' },
  { 'g', group = 'Goto' },
  { ']', group = 'Next' },
  { '[', group = 'Previous' },
}
