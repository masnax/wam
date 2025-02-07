require'notify'.setup {
  fps = 600,
  timeout = 1800,
  top_down = true,
  render = "minimal",
--  stages = "slide",
  stages = "static",
}

require'noice'.setup {
  cmdline = {
    opts = {
      position = { row = "65%", col = "50%", },
      size = { width = "50%", height = "auto", },
    },
    format = {
      edit = { pattern = "^:%s*ed?i?t?%s+", title = vim.fn.getcwd(), icon = "+" }
    }
  },

  messages = {
    enabled = true,
    -- view = "cmdline" -- comment this line out to enable top right notifications.
  },

--  popupmenu = {
--    opts = {
--      size = { width = 60, height = 15, },
--      border = { style = "rounded", padding = {0,1 }, },
--      win_options = {
--        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
--      },
--    }
--  },

  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
--      ["cmp.entry.get_documentation"] = true,
    },
    signature = { enabled = false },
  },

  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = false, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = true, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
}
