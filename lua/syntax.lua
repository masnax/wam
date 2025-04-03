require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "lua", "bash", "vim", "regex", "markdown", "markdown_inline", "git_config" },
  sync_install = false,
  highlight = {enable = true},
  indent = {enable = true},
  fold = {enable = true},
  textsubjects = {enable = true},
  rainbow = {
--    enable = true,
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

vim.api.nvim_set_hl(0, 'RainbowDelimiterRed',    {fg = "#30303f"})
vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow', {fg = "#50505f"})
vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue',   {fg = "#60606f"})
vim.api.nvim_set_hl(0, 'RainbowDelimiterOrange', {fg = "#70707f"})
vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen',  {fg = "#80808f"})
vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet', {fg = "#90909f"})
vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan',   {fg = "#b0b0bf"})
require('rainbow-delimiters.setup').setup()

local last_filter = 0
local cmp = require'cmp'
local entries = {}

local entry_filter = function(entry, ctx)
  if last_filter == 0 then
    return true
  end

  --print(last_filter .. ":" .. cmp.lsp.CompletionItemKind[entries[last_filter]])
  return entry:get_kind() == entries[last_filter]
end

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
      last_filter = 0
      entries = {}
      if cmp.visible() then
        cmp.abort()
      else
        cmp.complete()
      end
    end),
    ['<C-l>'] = cmp.mapping(function()
      if cmp.visible() then
       if last_filter == 0 then
          local map = {}
          for _, e in ipairs(cmp.get_entries()) do
            map[e:get_kind()] = e:get_kind()
          end

          for _, e in pairs(map) do
            table.insert(entries, e)
          end
       end

       last_filter = (last_filter + 1) % (#entries + 1)
       cmp.complete()
      end
    end),
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
      { name = 'nvim_lsp', entry_filter = entry_filter },
      { name = 'nvim_lsp_signature_help', entry_filter = entry_filter },
      { name = 'nvim_lsp_document_symbol', entry_filter = entry_filter },
      { name = 'path', entry_filter = entry_filter },
      { name = "fuzzy_buffer", entry_filter = entry_filter },
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


require'lsp_signature'.setup(
  {
    toggle_key = "<C-_>",
    auto_close_after = 3,
    floating_window = false,
    hint_enable = false,
    doc_lines = 1000,
    floating_window_above_cur_line = true,
    zindex = 2000,
  })
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {bg = "#aaaaff", fg = "#000000"})
vim.api.nvim_set_hl(0, "DiagnosticError", {fg = "#000000", bg = "#802040", bold = true})

vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
    format = function(diag)
      local split_lines = function(input, max_length)
        local result, line = "", ""

        for word in input:gmatch("%S+") do
          if #line + #word + 1 > max_length then
            result = result .. line .. "\n"
            line = word
          else
            line = line == "" and word or line .. " " .. word
          end
        end

        return result .. (line ~= "" and line or "")
      end

      return split_lines(diag.message, 80)
    end,
  },
  virtual_text = { current_line = true },
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
