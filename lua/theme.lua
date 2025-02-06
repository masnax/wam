-- Use catppuccin as a fallback.
require'catppuccin'.setup()
-- Get standard colors
require'palettes.colors'

-- Append custom palettes to rose-pine.
local m = require('rose-pine')
local c = m.colorscheme
m.colorscheme = function(variant)
  package.loaded['rose-pine.palette'] = require('palettes.fire')
  return c(variant)
end

require'rose-pine'.setup({
--  disable_italics = true,
--  disable_background = true,
})

vim.cmd([[
autocmd BufWinEnter *  if &ft == '' | :ColorizerAttachToBuffer
colo catppuccin
colo rose-pine
luafile $HOME/.cache/nvim/colorscheme-edits
]])

_G.list_acs = function()
print("Triggered Autocommands:")
for cmd in vim.fn.split(vim.fn.execute('autocmd'), "\n") do
  if string.match(cmd, 'triggered') then
    print(cmd)
  end
end
end

_G.dump = function(o)
  local function dump2(o, spaces)
    if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s =  s .. '\n' .. string.rep(" ", spaces) ..  '['..k..'] = ' .. dump2(v, spaces + 1) .. ','
      end
      return s .. '\n' .. string.rep(" ", spaces - 1) .. '} '
    elseif type(o) == "string" then
      return tostring("\"" .. o .. "\"")
    else
      return tostring(o)
    end
  end

  print(dump2(o, 1))
end

-- lua hi(false, "TSVariable", {fg = "#000000", style = "bold,italic,underline"})
_G.hi = function(save, group, gui)
  local fg = gui.fg or get_color(group, "fg#") or "none"
  local bg = gui.bg or get_color(group, "bg#") or "none"

  if gui.fg then
    if string.match(gui.fg, "%u") and string.match(gui.fg, "#") == nil then
      fg = get_color(gui.fg, "fg#")
    end
  end

  if gui.bg then
    if string.match(gui.bg, "%u") and string.match(gui.bg, "#") == nil then
      bg = get_color(gui.bg, "bg#")
    end
  end

  local bold = get_color(group, "bold") == "1"
  local italic = get_color(group, "italic") == "1"
  local underline = get_color(group, "underline") == "1"

  if gui.style then
    bold = string.match(gui.style, "bold") ~= nil
    italic = string.match(gui.style, "italic") ~= nil
    underline = string.match(gui.style, "underline") ~= nil
  end

  vim.api.nvim_set_hl(0, group, {fg = fg, bg = bg, bold = bold, italic = italic, underline = underline})

  vim.cmd([[e]])
  if save then
    file = io.open(vim.env.HOME.."/.cache/nvim/colorscheme-edits", "a")
    io.output(file)
    io.write("vim.api.nvim_set_hl(0, \""..group.."\", {fg = \""..fg.."\", bg = \""..bg.."\", bold = "..tostring(bold)..", italic = "..tostring(italic)..", underline = "..tostring(underline).."})\n")
    io.close(file)
  end
end

_G.get_color = function(g, t)
  local fn = vim.fn
  local color = fn.synIDattr(fn.synIDtrans(fn.hlID(g)), t)
  if color == '' then
    return
  end

  return color
end

_G.get_hl = function()
  local M = require("nvim-treesitter-playground.hl-info")
  local highlighter = require "vim.treesitter.highlighter"
  local utils = require "nvim-treesitter-playground.utils"
  local buf = vim.api.nvim_get_current_buf()
  local result = {}

  local function add_to_result(matches, source)
    if #matches == 0 then
      return
    end

    table.insert(result, "# " .. source)

    for _, match in ipairs(matches) do
      table.insert(result, match)
    end
  end

  if highlighter.active[buf] then

    local get_matches = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      row = row - 1

      local results = utils.get_hl_groups_at_position(bufnr, row, col)
      local highlights = {}
      for _, hl in pairs(results) do
        local color = vim.api.nvim_get_hl_by_name("@"..hl.capture, {})
        local hl_info = ""
        for field, value in pairs(color) do
          if value ~= nil then


             if field == "foreground" or field == "background" then
              value = string.format("#%06x", value)
             end

            hl_info = hl_info .. "\n" .. "  - " .. tostring(field) .. ": " .. tostring(value)
          end
        end

        local line = "* **@" .. hl.capture .. "**"
        if hl.priority then
          line = line .. "(" .. hl.priority .. ")"
        end

        if hl_info ~= "" then
          line = line .. ": " .. hl_info
        end
        table.insert(highlights, line)
      end
      return highlights
    end

    local matches = get_matches()
    add_to_result(matches, "Treesitter")
  end

  if vim.b.current_syntax ~= nil or #result == 0 then
    local matches = M.get_syntax_hl()
    add_to_result(matches, "Syntax")
  end

  if #result == 0 then
    table.insert(result, "* No highlight groups found")
  end

  vim.lsp.util.open_floating_preview(result, "markdown", { border = "single", pad_left = 4, pad_right = 4 })
end
