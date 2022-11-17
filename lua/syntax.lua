require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "lua", "bash" },
  sync_install = false,
  highlight = {enable = true},
  indent = {enable = true},
  fold = {enable = true},
  textsubjects = {enable = true},
  rainbow = {
    enable = true,
    extended_mode = true,
    colors = {
      "#cc241d",
      "#a89984",
      "#8a7096",
      "#d79921",
      "#689d6a",
      "#458588",
      "#d65d0e",
    },
  }
}



vim.g.coq_settings = {
  ["auto_start"] = 'shut-up',
  ["limits"] = { ["completion_auto_timeout"] = 0.15  },
  ["clients"] = {
    ["tree_sitter"] = { ["enabled"] = false },
  },
  ["keymap"] = {
    ["pre_select"] = true,
    ["recommended"] = false,
  },
}

vim.cmd([[
ino <silent><expr> <Esc>   pumvisible() ? "\<C-e>" : "\<Esc>"
ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"
]])

local coq = require "coq"

local servers = {'gopls', "bashls" }
for _, lsp in pairs(servers) do
  require'lspconfig'[lsp].setup(coq.lsp_ensure_capabilities())
end


require'nvim-autopairs'.setup { map_cr = false, map_bs = false }
require'lsp_signature'.setup({toggle_key = "<C-_>", auto_close_after = 3})
require'nvim-gps'.setup()
require'lsp_lines'.setup()

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true,
})

require'indent_blankline'.setup {
  show_current_context = true,
  context_char = '┃',
--  context_char = '⋅',
  char = "",
}

vim.cmd [[highlight IndentBlanklineContextChar guifg=#292734]]

require'paint'.setup {
  highlights = {
    {
      filter = { filetype = "go" },
      pattern = "%s*//%s*TODO:",
      hl = "@constant",
    },
    {
      filter = { filetype = "go" },
      pattern = "%s*//%s*FIXME:",
      hl = "@constant",
    },
  },
}
