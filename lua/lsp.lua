require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "lua" },
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



vim.g.coq_settings = { ["auto_start"] = 'shut-up' }
local coq = require "coq"

local servers = {'gopls' }
for _, lsp in pairs(servers) do
  require'lspconfig'[lsp].setup(coq.lsp_ensure_capabilities({
    on_attach = function(client, bufnr)
      local lsp_opts = { noremap=true, silent=true }
      vim.api.nvim_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', lsp_opts)
      vim.api.nvim_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_next()<CR>', lsp_opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '?', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap=true, silent=true})
    end,
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
  }))
end


require'nvim-autopairs'.setup { map_cr = false, map_bs = false }
require'lsp_signature'.setup({toggle_key = "<C-/>", auto_close_after = 5})
