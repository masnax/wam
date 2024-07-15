local get_hex = require('cokeline/hlgroups').get_hl_attr
local mappings = require('cokeline/mappings')

local errors_fg = get_hex('DiagnosticError', 'fg')
local warnings_fg = get_hex('DiagnosticWarn', 'fg')

local red = vim.g.terminal_color_1
local yellow = vim.g.terminal_color_3

local components = {
  outer_space = {
    text = ' ',
    bg = function(buffer)
      if not buffer.is_focused then
        return "none"
      end
      return get_hex('Normal', 'bg')
    end,
  },

  inner_space = { text = ' ', bg = function(buffer) if not buffer.is_focused then return palette.surface_light end return nil end},
  corner_begin = {
    text = '',
    bg =  get_hex('Normal', 'bg'),
    fg = function(buffer)
      if not buffer.is_focused then
        return palette.surface_light
      end
      return get_hex('ColorColumn', 'bg')
    end,
  },
  corner_end = {
    text = '',
    bg = get_hex('Normal', 'bg'),
    fg = function(buffer)
      if not buffer.is_focused then
        return palette.surface_light
      end
      return get_hex('ColorColumn', 'bg')
    end,
  },

  devicons = {
        text = function(buffer)
      return
        (mappings.is_picking_focus() or mappings.is_picking_close())
          and buffer.pick_letter .. ' '
           or buffer.devicon.icon
    end,
    fg = function(buffer)
      if not buffer.is_focused then
        return palette.highlight_med
      else
      return
        (mappings.is_picking_focus() and yellow)
        or (mappings.is_picking_close() and red)
        or buffer.devicon.color
      end
    end,
    style = function(_)
      return
        (mappings.is_picking_focus() or mappings.is_picking_close())
        and 'italic,bold'
         or nil
    end,
    bg = function(buffer)
      if not buffer.is_focused then
        return palette.surface_light
      end
      return nil
    end,
    truncation = { priority = 1 }
  },

  filename = {
    text = function(buffer)
      return buffer.filename
    end,
    style = function(buffer)
      return
        ((buffer.is_focused and buffer.diagnostics.errors ~= 0)
          and 'bold,underline')
        or (buffer.is_focused and 'bold')
        or (buffer.diagnostics.errors ~= 0 and 'underline')
        or nil
    end,
    bg = function(buffer)
      if not buffer.is_focused then
        return palette.surface_light
      end
      return nil
    end,
    truncation = {
      priority = 2,
      direction = 'left',
    },
  },

  diagnostics = {
    text = function(buffer)
      return
        (buffer.diagnostics.errors ~= 0 and '  ' .. buffer.diagnostics.errors)
        or (buffer.diagnostics.warnings ~= 0 and '  ' .. buffer.diagnostics.warnings)
        or ''
    end,
    fg = function(buffer)
      return
        (buffer.diagnostics.errors ~= 0 and errors_fg)
        or (buffer.diagnostics.warnings ~= 0 and warnings_fg)
        or nil
    end,
    bg = function(buffer) if not buffer.is_focused then return palette.surface_light end return nil end,
    truncation = { priority = 1 },
  },

  close_or_unsaved = {
    text = function(buffer)
      return buffer.is_modified and '●' or ''
    end,
    fg = function(buffer)
      return buffer.is_modified and green or nil
    end,
    bg = function(buffer) if not buffer.is_focused then return palette.surface_light end return nil end,
    delete_buffer_on_left_click = true,
    truncation = { priority = 1 },
  },
}

require('cokeline').setup({
  mappings = {
    cycle_prev_next = true
  },
  default_hl = {
    fg = function(buffer)
      return
        buffer.is_focused
        and palette.foam
        or palette.highlight_highest
        --or get_hex('Normal', 'fg')
    end,
    bg = get_hex('ColorColumn', 'bg'),
  },

  components = {
    components.outer_space,
    components.corner_begin,
    components.devicons,
    components.inner_space,
    components.filename,
    components.diagnostics,
    components.inner_space,
    components.inner_space,
    components.close_or_unsaved,
    components.corner_end,
  },
})

vim.cmd([[hi TablineFill guibg=none]])
