
require'palettes.fire'

local options = {
  lsp = require "feline.providers.lsp",
  lsp_severity = vim.diagnostic.severity,
}

options.icon_styles = {
   default = {
      left = "",
      right = " ",
      main_icon = "  ",
      vi_mode_icon = " ",
      position_icon = " ",
   },
   arrow = {
      left = "",
      right = "",
      main_icon = "  ",
      vi_mode_icon = " ",
      position_icon = " ",
   },

   block = {
      left = " ",
      right = " ",
      main_icon = "   ",
      vi_mode_icon = "  ",
      position_icon = "  ",
   },

   round = {
      left = "",
      right = "",
      main_icon = "  ",
      vi_mode_icon = " ",
      position_icon = " ",
   },

   slant = {
      left = " ",
      right = " ",
      main_icon = "  ",
      vi_mode_icon = " ",
      position_icon = " ",
   },
}


options.mode_colors = {
   ["n"] = { "N", colors.belafonte.white },
   ["no"] = { "NP", colors.belafonte.white },
   ["i"] = { "I", colors.belafonte.white },
   ["ic"] = { "I", colors.belafonte.white },
   ["t"] = { "T", colors.belafonte.white },
   ["v"] = { "V", colors.belafonte.white },
   ["V"] = { "VL", colors.belafonte.white },
   [""] = { "VB", colors.belafonte.white },
   ["R"] = { "R", colors.belafonte.white },
   ["Rv"] = { "VR", colors.belafonte.white },
   ["s"] = { "S", colors.belafonte.white },
   ["S"] = { "SL", colors.belafonte.white },
   [""] = { "SB", colors.belafonte.white },
   ["c"] = { "C", colors.belafonte.white },
   ["cv"] = { "C", colors.belafonte.white },
   ["ce"] = { "C", colors.belafonte.white },
   ["r"] = { "P", colors.belafonte.white },
   ["rm"] = { "M", colors.belafonte.white },
   ["r?"] = { "?", colors.belafonte.white },
   ["!"] = { "!", colors.belafonte.white },
}

options.separator_style = options.icon_styles.round

options.file_info = {
  provider = function()
    local readonly_str = ''
    local modified_str = ''
    if vim.bo.readonly then
      readonly_str = " "
    end

    if vim.bo.modified then
      if vim.bo.readonly then
        readonly_str = ""
      end
      modified_str = options.separator_style.main_icon
    end

    return readonly_str..""..modified_str
  end,

  hl = {fg = colors.fire.black1, bg = colors.fire.red1},
}

options.mode = {
   provider = function()
    return options.mode_colors[vim.fn.mode()][1]
   end,
   hl = {bg = colors.fire.red1, fg = colors.baroque.brown1},
   right_sep = {str = options.separator_style.right, hl = {fg = colors.fire.red1, bg=palette.highlight_low }},
}

options.file_name = {
   provider = function()
      local filename = vim.fn.expand "%:."
      local extension = vim.fn.expand "%:e"
      local icon = require("nvim-web-devicons").get_icon(filename, extension)
      if icon == nil then
         icon = " "
         return icon
      end
      if next(vim.lsp.buf_get_clients()) ~= nil then
      return " " .. icon .. " " .. filename .. "  "
      else
      return " " .. icon .. " " .. filename .. " "
      end
   end,
   hl = function()
    local fg = colors.fire.purple1
    if vim.bo.modified then
      fg = colors.fire.red1
    end
    return {fg = fg, bg = colors.fire.black1 }
  end,
}

options.diff = {
   add = {
      provider = "git_diff_added",
      icon = "  ",
      hl = {fg = colors.belafonte.white1, bg = palette.highlight_higher },
   },

   change = {
      provider = "git_diff_changed",
      icon = "  ",
      hl = {fg = colors.belafonte.white1, bg = palette.highlight_higher },
   },

   remove = {
      provider = "git_diff_removed",
      icon = "  ",
      hl = {fg = colors.belafonte.white1, bg = palette.highlight_higher },
   },

}

options.git_branch = {
   provider = function()
    return " "..(vim.b.gitsigns_head or ''), ''
  end,
   hl = {bg = palette.highlight_med, fg = palette.foam},
   left_sep = {str = options.separator_style.left, hl = {fg = palette.highlight_med, bg=palette.highlight_higher }},
}

options.diagnostic = {
   error = {
      provider = "diagnostic_errors",
      enabled = function()
         return options.lsp.diagnostics_exist(options.lsp_severity.ERROR)
      end,

      icon = "  ",

      hl = {bg = palette.highlight_low },
   },

   warning = {
      provider = "diagnostic_warnings",
      enabled = function()
         return options.lsp.diagnostics_exist(options.lsp_severity.WARN)
      end,
      icon = "  ",
      hl = {bg = palette.highlight_low },
   },

   hint = {
      provider = "diagnostic_hints",
      enabled = function()
         return options.lsp.diagnostics_exist(options.lsp_severity.HINT)
      end,
      icon = "  ",
      hl = {bg = palette.highlight_low },
   },

   info = {
      provider = "diagnostic_info",
      enabled = function()
         return options.lsp.diagnostics_exist(options.lsp_severity.INFO)
      end,
      icon = "  ",
      hl = {bg = palette.highlight_low },
   },
}

options.nvim_gps = {
   provider = function()
      -- nvim-gps loads at cursorMoved so need to handle this
      local gps_loaded, gps = pcall(require, "nvim-navic")

      if not gps_loaded then
         return
      end

      return " " .. gps.get_location()
   end,

   enabled = function()
      local gps_loaded, gps = pcall(require, "nvim-navic")

      if not gps_loaded then
         return false
      end

      return gps.is_available()
   end,

   hl = {fg = colors.fire.purple2, bg = colors.fire.black1 }
}

options.empty_space = {
   provider = " ",
   hl = {bg = 'none', fg = 'none'},
}
options.empty_space_right = {
   provider = options.separator_style.right,
   hl = {bg = 'none', fg = palette.highlight_low},
}

options.empty_space_left = {
   provider = options.separator_style.left,
   hl = {bg = palette.highlight_med, fg = palette.highlight_low},
}

options.empty_space_left2 = {
   provider = options.separator_style.left,
   hl = {bg = 'none', fg = palette.highlight_higher},
}

options.current_line = {
   provider = function()
      local current_line = vim.fn.line "."
      local total_line = vim.fn.line "$"

      return current_line .. "/" .. total_line .. " "
   end,

  hl = {fg = colors.tangerine.yellow2, bg = palette.highlight_low},
}

options.position = {
  provider = function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    col = vim.str_utfindex(vim.api.nvim_get_current_line(), col) + 1

    return string.format('%s%03d', options.separator_style.position_icon, col)
  end,
  left_sep = {str = options.separator_style.left, hl = {fg = colors.fire.red1, bg=palette.highlight_low }},
  hl = {bg = colors.fire.red1, fg = colors.baroque.brown1},
}

local function add_table(tbl, inject)
   if inject then
      table.insert(tbl, inject)
   end
end

-- components are divided in 3 sections
options.left = {}
options.middle = {}
options.right = {}

-- left
add_table(options.left, {provider = " "..options.separator_style.left, hl = {fg = colors.fire.red1, bg = 'none'}})
add_table(options.left, options.file_info)
add_table(options.left, options.mode)
--add_table(options.left, options.file_name)
add_table(options.left, options.diagnostic.error)
add_table(options.left, options.diagnostic.warning)
add_table(options.left, options.diagnostic.hint)
add_table(options.left, options.diagnostic.info)
add_table(options.left, options.empty_space_right)


add_table(options.middle, {provider = options.separator_style.left, hl = {fg = colors.fire.black1, bg = 'none'}})
add_table(options.middle, options.file_name)
add_table(options.middle, options.nvim_gps)
add_table(options.middle, {provider = options.separator_style.right, hl = {fg = colors.fire.black1, bg = 'none'}})

-- right
add_table(options.right, options.empty_space_left2)
add_table(options.right, options.diff.add)
add_table(options.right, options.diff.change)
add_table(options.right, options.diff.remove)
add_table(options.right, options.git_branch)
add_table(options.right, options.empty_space_left)
add_table(options.right, options.current_line)
add_table(options.right, options.position)
add_table(options.right, {provider = options.separator_style.right.." ", hl = {fg = colors.fire.red1, bg = 'none'}})

-- Initialize the components table
options.components = { active = {} }

options.components.active[1] = options.left
options.components.active[2] = options.middle
options.components.active[3] = options.right




vim.api.nvim_set_hl(0, "StatusLine", {bg = "none"})
require('feline').setup{ components = options.components }
