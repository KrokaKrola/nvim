-- Nvim 0.12 bundles parsers only for c, lua, markdown, vim, vimdoc and query;
-- nvim-treesitter supplies the rest plus their highlight queries.
vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
}

local languages = {
  'bash',
  'c',
  'cpp',
  'go',
  'gomod',
  'gosum',
  'javascript',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'rust',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

-- parser compilation needs the tree-sitter CLI, installed via mason
vim.env.PATH = vim.fn.stdpath 'data' .. '/mason/bin:' .. vim.env.PATH

local ts = require 'nvim-treesitter'
ts.setup {}

local function ensure_installed()
  local missing = {}
  local installed = ts.get_installed 'parsers'
  local have = {}
  for _, p in ipairs(installed) do
    have[p] = true
  end
  for _, lang in ipairs(languages) do
    if not have[lang] then
      table.insert(missing, lang)
    end
  end
  if #missing > 0 then
    ts.install(missing)
  end
end

ensure_installed()

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('kroka-treesitter', { clear = true }),
  callback = function(event)
    local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
    if not lang then
      return
    end
    -- only start when a parser is actually present
    if not pcall(vim.treesitter.get_parser, event.buf, lang, { error = false }) then
      return
    end
    pcall(vim.treesitter.start, event.buf, lang)
  end,
})
