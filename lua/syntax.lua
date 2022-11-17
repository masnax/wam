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
  ["limits"] = { ["completion_auto_timeout"] = 0.12  },
  ["clients"] = {
    ["tree_sitter"] = { ["enabled"] = false },
  }
}

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

