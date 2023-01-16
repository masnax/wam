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
      "#3f303a",
      "#5f405a",
      "#5f404a",
      "#6f606a",
      "#6f505a",
      "#8f808a",
      "#8f707a",
      "#bfa0aa",
      "#bf909a",
    },
  }
}


local npairs =V require('nvim-autopairs')
local cmp = require'cmp'
cmp.setup({
  snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end},
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),

  formatting = {
    format = require'lspkind'.cmp_format({
      mode = "symbol_text",
      menu = ({
        buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        luasnip = '[Snip]',
        path = '[Path]',
        nvim_lsp_signature_help = '[Sig]',
      }),
    }),
  },

  --sources = cmp.config.sources({},{}),
  sources = cmp.config.sources(
    {
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'path' },
    },
    {
    }
  )
})

cmp.event:on('confirm_done', require'nvim-autopairs.completion.cmp'.on_confirm_done())
cmp.setup.cmdline({'/','?'}, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {{ name = 'buffer' }}
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = {'gopls', "bashls" }
for _, lsp in pairs(servers) do
  require'lspconfig'[lsp].setup({
    capabilities = capabilities,
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
  })
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
