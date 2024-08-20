require'notify'.setup {
  fps = 600,
  timeout = 1800,
  top_down = true,
  render = "minimal",
  stages = "slide",
}

require'noice'.setup {
  views = {
    cmdline_popup = {
      position = { row = "50%", col = "50%", },
      size = { width = 90, height = "auto", },
    },
--    popupmenu = {
--      size = { width = 60, height = 15, },
--      border = { style = "rounded", padding = {0,1 }, },
--      win_options = {
--        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
--      },
--    },
  },

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
