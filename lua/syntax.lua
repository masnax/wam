require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "lua", "bash", "vim", "regex", "markdown", "markdown_inline", "git_config" },
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
    ['<C-Space>'] = cmp.sync(function()
      if cmp.visible() then
        cmp.abort()
      else
        cmp.complete()
      end
    end),
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

  matching = {
    disallow_partial_fuzzy_matching = true,
  },

  completion = {
    keyword_length = 1,
  },

  --sources = cmp.config.sources({},{}),
  sources = cmp.config.sources(
    {
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lsp_document_symbol' },
      { name = 'path' },
      { name = "fuzzy_buffer" },
    },
    {
      { name = "buffer" },
    }
  )
})

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
--local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

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

      if client.server_capabilities.documentSymbolProvider then
        require'nvim-navic'.attach(client, bufnr)
      end

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
require'lsp_lines'.setup()

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = {only_current_line = true},
  float = {border = "rounded"},
})

vim.cmd([[
hi IblScope  guifg=#40304a
hi IblIndent guifg=#1c1c2d
]])

require'ibl'.setup({
  scope = { char = "┃", highlight = {"IblScope"}, show_start = true, show_end = true},
  indent = { char = "▏", highlight = {"IblIndent"}},
  whitespace = {},
})

function ibl_sed()
    local ibl = require'ibl.scope'
    local cfg = require'ibl.config'
    local bufnr = vim.api.nvim_get_current_buf()
    local node = ibl.get(bufnr, cfg.default_config)

    local s = node:start() + 1
    local e = node:end_() + 1

    local sed_range = string.format(':%s,%ss/', s,e)
    -- Temporarliy highlight the line as red
    local old_scope_hl = vim.api.nvim_get_hl(0, {name = 'IblScope'})
    vim.api.nvim_set_hl(0, "@ibl.scope.char.1", {fg=palette.gold})


    vim.cmd('call feedkeys("'..sed_range..'")')

    -- reset the line color on dialog exit
    vim.cmd(string.format([[
        augroup TempHighlightChange
            autocmd CmdlineLeave * hi @ibl.scope.char.1 guifg='#%x'
            autocmd CmdlineLeave * augroup! TempHighlightChange
        augroup END
    ]], old_scope_hl.fg))
end

vim.api.nvim_set_keymap('n', 'S', '<cmd>lua ibl_sed()<CR>', { noremap = true, silent = true })

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

require('nvim-autopairs').setup({
  check_ts = true,
  ts_config = { bash = false, shell = false, sh = false },
})
cmp.event:on(
  'confirm_done',
  require'nvim-autopairs.completion.cmp'.on_confirm_done()
)

require("inc_rename").setup()
