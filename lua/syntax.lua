local lang_ts = { "go", "lua", "bash", "vim", "regex", "markdown", "markdown_inline", "git_config", "comment", "typescript", "javascript" }
local ts = require'nvim-treesitter'


require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site'
}

ts.install(lang_ts)

-- highlights:
vim.api.nvim_create_autocmd('FileType', { pattern = lang_ts, callback = function() vim.treesitter.start() end })

-- indents:
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- folds:
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'

-- textsubjects:
-- not yet supported

vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
  }
})


vim.api.nvim_set_hl(0, 'RainbowDelimiterRed', {fg = "#50505f"})
vim.api.nvim_set_hl(0, 'RainbowDelimiterYellow',   {fg = "#60606f"})
vim.api.nvim_set_hl(0, 'RainbowDelimiterBlue', {fg = "#70707f"})
vim.api.nvim_set_hl(0, 'RainbowDelimiterOrange',  {fg = "#80808f"})
vim.api.nvim_set_hl(0, 'RainbowDelimiterGreen', {fg = "#90909f"})
vim.api.nvim_set_hl(0, 'RainbowDelimiterViolet',   {fg = "#b0b0bf"})
vim.api.nvim_set_hl(0, 'RainbowDelimiterCyan',    {fg = "#d0d0df"})
require('rainbow-delimiters.setup').setup()

local last_filter = 0
local entries = {}

local lsp_types = require('blink.cmp.types').CompletionItemKind
local src_filter = 0
local lsp_srcs = {}

local cmp_providers = { 'lsp', 'path', 'snippets', 'buffer', }
--cmp_providers = { 'go_deep' }
require('blink.cmp').setup({
  completion = {
    list = { selection = { preselect = true, auto_insert = false } },
    menu = {
      draw = {
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind", gap = 1 },
        },
      },
    },
    documentation = { auto_show = true, auto_show_delay_ms = 500 },
    ghost_text = { enabled = true },
  },
  keymap = {
    preset = 'default',
    ['<C-e>'] = false,
    ['<C-space>'] = {
      function(cmp)
        lsp_srcs = {}
        src_filter = 0
        if cmp.is_visible() then cmp.hide() else cmp.show() end
      end
    },
    ["<CR>"] = { "select_and_accept", "fallback" },
    ['<C-l>'] = {
      function(cmp)
        if not cmp.is_visible() then return end

        local cmp_items = cmp.get_items()
        if #lsp_srcs == 0 then
          local seen = {}
          local kinds = {}
          for i, item in ipairs(cmp_items) do
            if not seen[item.kind] and item.source_id == "lsp" then
              seen[item.kind] = true
              table.insert(kinds, item.kind)
            end
          end

          lsp_srcs = kinds
        end

        src_filter = (src_filter + 1) % (#lsp_srcs + 1)
        if src_filter == 0 then
          print("Filter cleared")
          cmp.cancel({callback = cmp.show})
        else
          print("Filter", src_filter .. "/" .. #lsp_srcs .. ": " .. lsp_types[lsp_srcs[src_filter]])
          cmp.cancel({callback = function() cmp.show({providers = {"lsp"}}) end })
        end

        return true
      end
    },
  },
  sources = {
    default = cmp_providers,
    providers = {
      snippets = {
        score_offset = -9999,
      },
      lsp = {
        max_items = 500,
        score_offset = 9999,
        transform_items = function(cmp, items)
          local subset = vim.tbl_filter(function(item)
            return src_filter > 0 and item.kind == lsp_srcs[src_filter]
          end, items)

          if #subset == 0 then
            return items
          end

          return subset
        end
      },
      go_deep = {
        name = "go_deep",
        module = "blink.compat.source",
        min_keyword_length = 2,
        max_items = 5,
        ---@module "cmp_go_deep"
        ---@type cmp_go_deep.Options
        opts = { filetypes = { "go" }},
      },
    }
  },
  --snippets = { preset = 'default' | 'luasnip' | 'mini_snippets' | 'vsnip' },
  snippets = {preset = 'luasnip'},
  signature = { enabled = true },
  fuzzy = {
    implementation = "prefer_rust_with_warning",
    use_proximity = true,
    sorts = {
      'exact',
      function(a, b)
        local a_snippet = a.source_id == "snippets"
        local b_snippet = b.source_id == "snippets"
        if a_snippet ~= b_snippet then return b_snippet end
      end,
      'sort_text',
      'score',
    },
  }
})

-- Setup lspconfig.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

local servers = {'gopls', "bashls" }
for _, lsp in pairs(servers) do
  vim.lsp.config(lsp, {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      if lsp == "gopls" then
        vim.opt_local.expandtab = true
        vim.lsp.inlay_hint.enable(vim.bo[bufnr].filetype ~= "gomod", {bufnr = bufnr})
      end

      local lsp_opts = { noremap=true, silent=true }
      vim.api.nvim_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_prev({float=false})<CR>', lsp_opts)
      vim.api.nvim_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.jump({count=1, float=false})<CR>', lsp_opts)
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
          usePlaceholders = false,
           -- completeUnimported = false, -- I think this was removed?
           -- completionBudget = "300ms",
        }
      }
    },
    settings = {
      Lua = {
        hint = {
          enable = true,
          arrayIndex = "Disable",  -- "Enable" | "Auto" | "Disable"
        },
      },
    },
  })

  vim.lsp.enable(lsp)
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

local dicons = require('icons').diagnostic
for txt, info in pairs(dicons) do
  local line = "Diagnostic"..txt
  local sign = "DiagnosticSign"..txt

  vim.api.nvim_set_hl(0, line, {fg = "#000000", bg = info.color, bold = true})
  vim.api.nvim_set_hl(0, sign, {fg = info.color, bg = none})
end

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = dicons.Error.icon,
      [vim.diagnostic.severity.WARN]  = dicons.Warn.icon,
      [vim.diagnostic.severity.HINT]  = dicons.Hint.icon,
      [vim.diagnostic.severity.INFO]  = dicons.Info.icon,
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  }
})

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
hi IblScope  guifg=#70708a
hi IblIndent guifg=#1c1c2d
]])

require'ibl'.setup({
  scope = { char = "┃", highlight = {"IblScope"}, show_start = true, show_end = true, include = {
    node_type = {
      ["*"] = { "table_constructor", "arguments", "parenthesized_expression"},
    },
  } },
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

--vim.api.nvim_set_keymap('n', 'S', '<cmd>lua ibl_sed()<CR>', { noremap = true, silent = true })

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

require('blink.pairs').setup({
  highlights = { enabled = false, cmdline = false, },
  mappings = {
    enabled = true,
    cmdline = true,
    disabled_filetypes = {},
    pairs = {
      ["'"] = {
        {
          "'",
          enter = false,
          space = false,
          when = function(ctx)
            return ctx.ft ~= 'plaintext'
            and ctx.ft ~= 'scheme'
            and (
              not ctx.char_under_cursor:match("'")
              or (ctx:text_before_cursor(2) == "''")
              or ctx:is_after_cursor("'")
            )
            and ctx.ts:blacklist('singlequote').matches
          end,
        },
      },
    },
  },
})


-- Disable autopairs during visual block insert.
vim.keymap.set("x", "I", function()
  vim.b.pairs = vim.fn.mode() ~= "\22"
  return "I"
end, { expr = true })

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function() vim.b.pairs = true end,
})

require("inc_rename").setup()
