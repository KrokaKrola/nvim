vim.pack.add {
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
  { src = 'https://github.com/folke/lazydev.nvim' },
}

require('mason').setup()

-- Per-server overrides; merged onto lspconfig defaults by vim.lsp.config.
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      completion = { callSnippet = 'Replace' },
    },
  },
})

vim.lsp.config('pyright', {
  settings = {
    pyright = {
      -- ruff owns import organization
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        typeCheckingMode = 'basic',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
})

vim.lsp.config('ruff', {
  on_attach = function(client, _)
    -- pyright provides hover; conform runs ruff for formatting
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.documentFormattingProvider = false
  end,
})

vim.lsp.config('clangd', {
  -- keep clangd's completions compatible with the completion plugin
  cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu' },
})

vim.lsp.config('gopls', {
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
    },
  },
})

-- rust_analyzer omitted: installed via rustup, kept in sync with the toolchain
local servers = { 'lua_ls', 'pyright', 'ruff', 'gopls', 'vtsls', 'clangd', 'jsonls', 'yamlls' }

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      cargo = { allFeatures = true },
      checkOnSave = true,
      check = { command = 'clippy' },
    },
  },
})

vim.lsp.config('jsonls', {
  settings = {
    json = {
      validate = { enable = true },
    },
  },
})

vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      validate = true,
      keyOrdering = false,
    },
  },
})

require('mason-lspconfig').setup {
  ensure_installed = servers,
  -- ts_ls conflicts with vtsls; stylua ships a `--lsp` mode that would
  -- otherwise shadow lua_ls
  automatic_enable = { exclude = { 'ts_ls', 'stylua' } },
}

-- not managed by mason; enable directly
vim.lsp.enable 'rust_analyzer'

require('mason-tool-installer').setup {
  ensure_installed = {
    'stylua',
    'prettierd',
    'eslint_d',
    'gofumpt',
    'goimports',
    'clang-format',
    'yamllint',
    'taplo',
  },
}

require('lazydev').setup()

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kroka-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    local builtin = require 'telescope.builtin'

    map('gd', builtin.lsp_definitions, 'Goto definition')
    map('gr', builtin.lsp_references, 'Goto references')
    map('<leader>rf', builtin.lsp_references, 'Find references')
    map('gI', builtin.lsp_implementations, 'Goto implementation')
    map('<leader>D', builtin.lsp_type_definitions, 'Type definition')
    map('<leader>ds', builtin.lsp_document_symbols, 'Document symbols')
    map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, 'Workspace symbols')
    map('<leader>rr', vim.lsp.buf.rename, 'Rename symbol')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
    map('gh', vim.lsp.buf.hover, 'Hover documentation')
    map('gl', vim.diagnostic.open_float, 'Show line diagnostics')
    map('gD', vim.lsp.buf.declaration, 'Goto declaration')
  end,
})

vim.diagnostic.config {
  virtual_text = true,
  severity_sort = true,
  float = { border = 'rounded', source = true },
}
