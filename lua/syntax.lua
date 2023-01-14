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
      "#d53a4c",
      "#458588",
      "#d65d0e",
      --"#689d6a",
   --   "#ff0000",
   --   "#ff7700",
   --   "#ffff00",
   --   "#00ff77",
   --   "#00ffff",
   --   "#0000ff",
   --   "#7700ff",
    },
  }
}



vim.g.coq_settings = {
  ["auto_start"] = 'shut-up',
  ["limits"] = { ["completion_auto_timeout"] = 0.15  },
  ["clients"] = {
    ["tree_sitter"] = { ["enabled"] = false },
    ["buffers"] = { ["enabled"] = false },
    ["snippets"] = { ["enabled"] = false },
  },
  ["keymap"] = {
    ["pre_select"] = true,
    ["recommended"] = false,
  },
  ["completion"] = {
    ["skip_after"] = {"{", "}", "[", "]"},
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
  require'lspconfig'[lsp].setup(coq.lsp_ensure_capabilities({
    on_attach = function(client, bufnr)
      local lsp_opts = { noremap=true, silent=true }
      vim.api.nvim_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_prev({float=false})<CR>', lsp_opts)
      vim.api.nvim_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_next({float=false})<CR>', lsp_opts)
      vim.api.nvim_set_keymap('n', 'E', '<cmd>lua vim.diagnostic.open_float()<CR>', lsp_opts)
      vim.api.nvim_set_keymap('n', '?', '<cmd>lua vim.lsp.buf.hover()<CR>', lsp_opts)
      vim.api.nvim_set_keymap('n', 'C', '<cmd>lua vim.lsp.buf.code_action()<CR>', lsp_opts)

      if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_exec(
          [[
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]],
          false
        )
      end

    end,
    gopls = {
      settings = {
        gopls = {
          buildFlags = {"-tags=test"},
          analyses = { unusedparams = false, },
          codelenses = { gc_details = false, },
          staticcheck = false,
          completeUnimported = false,
          usePlaceholders = false,
        }
      }
    }
  }))
end


require'lsp_signature'.setup({toggle_key = "<C-_>", auto_close_after = 3})
require'nvim-gps'.setup()
require'lsp_lines'.setup()

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = {only_current_line = true},
  float = {border = "rounded"},
})

require'indent_blankline'.setup {
  show_current_context = true,
  context_char = '┃',
--  context_char = '⋅',
  char = "",
}

local npairs = require('nvim-autopairs')
local remap = vim.api.nvim_set_keymap
npairs.setup { map_cr = false, map_bs = false }
_G.MUtils= {}

MUtils.CR = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
      return npairs.esc('<c-y>')
    else
      return npairs.esc('<c-e>') .. npairs.autopairs_cr()
    end
  else
    return npairs.autopairs_cr()
  end
end
remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })

MUtils.BS = function()
  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
    return npairs.esc('<c-e>') .. npairs.autopairs_bs()
  else
    return npairs.autopairs_bs()
  end
end

remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true })

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
