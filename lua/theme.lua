require'catppuccin'.setup()
require'rose-pine'.setup({
  disable_italics = true,
  --disable_background = true,
})

vim.cmd([[
colo catppuccin
colo rose-pine
luafile $HOME/.cache/nvim/colorscheme-edits
]])

_G.dump = function(o)
  local function dump2(o)
    if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump2(v) .. ','
      end
      return s .. '} '
    elseif type(o) == "string" then
      return tostring("\"" .. o .. "\"")
    else
      return tostring(o)
    end
  end

  print(dump2(o))
end

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

_G.colors = {
  renaissance = {
    black = "#1E231D",
    grey = "#616E77",
    greengrey = "#303730",
    bluegrey = "#5C677B",
    green1 = "#606046",
    green2 = "#608246",
    green3 = "#658440",
    green4 = "#698763",
    green5 = "#6D8467",
    green6 = "#738E57",
    green7 = "#929B7C",
    blue1 = "#78A9B7",
    blue2 = "#5B9EA6",
    blue3 = "#5F98B6",
    blue4 = "#6087A4",
    yellow1 = "#E7D9AA",
    yellow2 = "#CD9C5A",
    brown1 = "#A4845B",
    brown2 = "#7D6C5A",
    brown3 = "#6A5343",
    brown4 = "#5F3930",
    brown5 = "#6D4A46",
    red1 = "#9A5045",
    red2 = "#BC7062",
    red3 = "#C5917C",
    orange1 = "#B6845F",
    orange2 = "#BA6F38",
    orange3 = "#CD825A",
    orange4 = "#D49572",
    orange5 = "#DEA175",
    orange6 = "#ECC0A5",
  },

  baroque = {
    grey = "#71726C",
    black = "#231F20",
    greenblack = "#26281D",
    green1 = "#2A7771",
    green2 = "#414A35",
    green3 = "#475138",
    green4 = "#4A5022",
    green5 = "#4B4E21",
    green6 = "#596A62",
    green7 = "#5B7955",
    green8 = "#C2C76B",
    brown1 = "#30261A",
    brown2 = "#674A3C",
    brown3 = "#603D1D",
    brown4 = "#553830",
    brown5 = "#4E2E1F",
    brown6 = "#61312D",
    brown7 = "#724C28",
    brown8 = "#7D5941",
    brown9 = "#8E5721",
    brown10 = "#9B5B37",
    brown11 = "#A35D43",
    red1 = "#782B19",
    red2 = "#841617",
    red3 = "#841A1E",
    red4 = "#AC2023",
    red5 = "#BC5228",
    orange1 = "#D97F27",
    orange2 = "#B9905C",
    yellow1 = "#BB882C",
    yellow2 = "#D19A3F",
    yellow4 = "#B4934E",
    yellow5 = "#D7B262",
    yellow6 = "#D3AF71",
    yellow7 = "#FFCA60",
    yellow8 = "#F7D990",
    white1 = "#EED09C",
    white2 = "#F5E5C3",
    white3 = "#FFFCDD",
  },
  tangerine = {
    black0 = "#200000",
    black1 = "#141415",
    grey0 = "#3B4252",
    grey1 = "#434C5E",
    grey2 = "#4C566A",
    grey3 = "#616E88",
    white0 = "#E5E9F0",
    white1 = "#ECEFF4",
    green0 = "#AFFFDF",
    green1 = "#8FBCBB",
    green2 = "#517777",
    green3 = "#81A7A7",
    blue0 = "#5FB1FF",
    blue1 = "#4F81AC",
    blue2 = "#868062",
    blue3 = "#40E0E0",
    blue4 = "#2f6f9a",
    purple0 = "#4F50A0",
    purple1 = "#AF9FEA",
    red0 = "#ab1b5a",
    red1 = "#c02040",
    red2 = "#BF616A",
    orange0 = "#F85E5E",
    orange1 = "#FF7A0E",
    orange2 = "#D08770",
    yellow0 = "#e08e33",
    yellow1 = "#F3A760",
    yellow2 = "#FFBB7B",
  },
  belafonte = {
    black = "#20111a",
    grey1 = "#98999c",
    grey2 = "#958b83",
    white1 = "#d4ccb9",
    red1 = "#bd100d",
    green1 = "#858062",
    yellow1 = "#e9a448",
    blue1 = "#416978",
    blue2 = "#292734",
    brown1 = "#96522b",
    brown2 = "#45363b",
    brown3 = "#5e5252",
  },
  fire = {
    black1 = "#212123",
    purple1 = "#AB6192",
    purple2 = "#8a7096",
    purple3 = "#6a5076",
    white1 = "#E1A1A4",
    pink1 = "#CC4D5F",
    orange1 = "#E9674A",
    orange2 = "#d04f2A",
    red1 = "#D53A4C",
    yellow1 = "#FB9D5A",
    brown1 = "#A76255",
    grey1 = "#423746",
    grey2 = "#493C48",
  }
}
