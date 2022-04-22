require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go" },
  sync_install = false,
  highlight = {enable = true},
  indent = {enable = true},
  fold = {enable = true},
  rainbow = {
    enable = true,
    extended_mode = true,
   -- colors = {
   --   "#ff0000",
   --   "#ff7700",
   --   "#ffff00",
   --   "#00ff77",
   --   "#00ffff",
   --   "#0000ff",
   --   "#7700ff",
   -- },
  }
}

-- Folding
vim.cmd([[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldtext=substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend))
set foldnestmax=3
set foldminlines=1
set foldlevel=99
]])

vim.o.foldtext = [[substitute(getline(v:foldstart),'\\\\t',repeat('\\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
vim.opt.foldmethod="indent"


vim.g.coq_settings = { ["auto_start"] = 'shut-up' }
local coq = require "coq"
require'lspconfig'.gopls.setup(coq.lsp_ensure_capabilities())
require'nvim-autopairs'.setup { map_cr = false, map_bs = false }


require'lsp_signature'.setup()


local single = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"}
local double = { '╔', '═', '╗', '║', '╝', '═', '╚', '║' }

require'navigator'.setup {
  lsp_installer = false,
  lsp_signature_help = true,
--  ts_fold = true,
  treesitter_analysis = false,
  width = 0.7,
  border = double,
  default_mapping = false,
  lsp = {
    code_action = {enable = false, sign = true, sign_priority = 40, virtual_text = true},
    format_on_save = false,
    gopls = {
      settings = {
        gopls = {
          analyses = {
            unusedparams = false,
          },
          staticcheck = false,
          completeUnimported = false,
          usePlaceholders = false,
        }
      }
    }
  },
  keymaps = {
    {key = '<Space>', func = "require('navigator.def_impl').def_impl_sync()"},
    {key = '<Space><Space>', func = "require('navigator.reference').async_ref()"},
--    {key = '<Space>', func = "require('navigator.definition').definition_preview()"},
--    {key = '<Space>x', func = "require('navigator.definition').definition()"},
    {key = '[e', func = "diagnostic.goto_next({ border = 'rounded', max_width = 80})"},
    {key = ']e', func = "diagnostic.goto_prev({ border = 'rounded', max_width = 80})"},
    {key = '[r', func = "require('navigator.treesitter').goto_next_usage()" },
    {key = ']r', func = "require('navigator.treesitter').goto_previous_usage()" },
  },
}
