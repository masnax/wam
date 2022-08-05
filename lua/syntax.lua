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



vim.g.coq_settings = { ["auto_start"] = 'shut-up', ["limits"] = { ["completion_auto_timeout"] = 0.12  }  }
local coq = require "coq"

local servers = {'gopls', "bashls" }
for _, lsp in pairs(servers) do
  require'lspconfig'[lsp].setup(coq.lsp_ensure_capabilities())
end


require'nvim-autopairs'.setup { map_cr = false, map_bs = false }
require'lsp_signature'.setup({toggle_key = "<C-_>", auto_close_after = 3})
require'nvim-gps'.setup()


local single = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"}
local double = { '╔', '═', '╗', '║', '╝', '═', '╚', '║' }

require'navigator'.setup {
  on_attach = function(client, bufnr)
    local lsp_opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']e', '<cmd>lua vim.diagnostic.goto_prev({float=false})<CR>', lsp_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[e', '<cmd>lua vim.diagnostic.goto_next({float=false})<CR>', lsp_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'E', '<cmd>lua vim.diagnostic.open_float()<CR>', lsp_opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '?', '<cmd>lua vim.lsp.buf.hover()<CR>', lsp_opts)
    --vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-/>', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap=true, silent=true})
  end,
  lsp_installer = false,
  lsp_signature_help = true,
--  ts_fold = true,
  treesitter_analysis = true,
  width = 0.7,
  border = double,
  default_mapping = false,
  lsp = {
    code_action = {enable = true, sign = true, sign_priority = 40, virtual_text = false},
    code_lens_action = {enable = true, sign = true, sign_priority = 40, virtual_text = true},
    format_on_save = false,
    diagnostic = {
      virtual_text = false,
    },
    gopls = {
      settings = {
        gopls = {
          analyses = { unusedparams = false, },
          codelenses = { gc_details = false, },
          staticcheck = false,
          completeUnimported = false,
          usePlaceholders = false,
        }
      }
    }
  },
  keymaps = {
    {key = '[r', func = "require('navigator.treesitter').goto_next_usage()" },
    {key = ']r', func = "require('navigator.treesitter').goto_previous_usage()" },
  },
}

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

