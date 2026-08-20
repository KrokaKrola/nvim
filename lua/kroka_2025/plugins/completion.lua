vim.pack.add {
  { src = 'https://github.com/rafamadriz/friendly-snippets' },
  { src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range '1' },
}

require('blink.cmp').setup {
  keymap = {
    preset = 'default',
    -- accept with Enter; takes the first item when nothing is selected
    ['<CR>'] = { 'select_and_accept', 'fallback' },
  },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      snippets = {
        opts = {
          -- personal snippets in ~/.config/nvim/snippets, on top of friendly-snippets
          search_paths = { vim.fn.stdpath 'config' .. '/snippets' },
        },
      },
    },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = { enabled = true },
}

-- jump between snippet tabstops outside the completion menu
vim.keymap.set({ 'i', 's' }, '<C-s>;', function()
  if vim.snippet.active { direction = 1 } then
    vim.snippet.jump(1)
  end
end, { desc = 'Snippet: next tabstop' })

vim.keymap.set({ 'i', 's' }, '<C-s>,', function()
  if vim.snippet.active { direction = -1 } then
    vim.snippet.jump(-1)
  end
end, { desc = 'Snippet: previous tabstop' })
