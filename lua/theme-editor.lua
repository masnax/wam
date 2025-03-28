local api = vim.api
local ts = vim.treesitter

local function get_hl_group_and_colors()
  local M = require("nvim-treesitter-playground.hl-info")
  local highlighter = require "vim.treesitter.highlighter"
  local utils = require "nvim-treesitter-playground.utils"
  local buf = vim.api.nvim_get_current_buf()
  local result = {}

  local maps = {}

  if highlighter.active[buf] then

    local get_matches = function()
      local bufnr = vim.api.nvim_get_current_buf()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      row = row - 1

      local results = utils.get_hl_groups_at_position(bufnr, row, col)
      local map_groups = {}
      for _, hl in pairs(results) do
        local map_entry = {}
        local color = vim.api.nvim_get_hl_by_name("@"..hl.capture, {})
        local hl_info = ""
        for field, value in pairs(color) do
          if value ~= nil then


            if field == "foreground" or field == "background" then
              value = string.format("#%06x", value)
            end

            map_entry[tostring(field)] = tostring(value)
          end
        end

        local line = "* **@" .. hl.capture .. "**"
        if hl.priority then
          line = line .. "(" .. hl.priority .. ")"
        end

        if next(map_entry) ~= nil then
          map_groups["@"..hl.capture] = map_entry
        end
      end
      return map_groups
    end



    maps = get_matches()
  end

  return maps
end

local function update_highlight(opts_list)
  local truefalse = { ["true"] = true, ["false"] = false }
  for _, opts in ipairs(opts_list) do
  local hl_def = {
    fg = opts.fg or nil,
    bg = opts.bg or nil,
    bold = truefalse[opts.bold] or nil,
    italic = truefalse[opts.italic] or nil,
    underline = truefalse[opts.underline] or nil
  }

    vim.api.nvim_set_hl(0, opts["# Group"], hl_def)
  end
end

local function open_popup()
  local maps = get_hl_group_and_colors()
  local bufnr = api.nvim_create_buf(false, true)
  local win_opts = {
    relative = "cursor",
    row = 1,
    col = 0,
    width = 1,
    height = 0,
    style = "minimal",
    border = "single",
  }

    local lines = {}
  for group, cfg in pairs(maps) do
    -- Fill buffer with default values
    local lines_gapped = {
      "# Group: " .. group,
      (cfg.foreground and "  fg: " .. cfg.foreground),
      (cfg.background and "  bg: " .. cfg.background),
      (cfg.bold and "  bold: " .. cfg.bold),
      (cfg.italic and "  italic: " .. cfg.italic),
      (cfg.underline and "  underline: " .. cfg.underline),
    }

    for _, v in pairs(lines_gapped) do
      if win_opts.width < #v + 1 then
        win_opts.width = #v + 1
      end

      win_opts.height = win_opts.height + 1
      table.insert(lines, v)
    end
  end

  local win_id = api.nvim_open_win(bufnr, true, win_opts)

  api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  -- Make buffer editable
  api.nvim_buf_set_option(bufnr, "modifiable", true)
  api.nvim_buf_set_option(bufnr, "filetype", "markdown")
  api.nvim_buf_set_option(bufnr, 'completeopt', 'longest,noinsert')
  require'cmp'.setup.buffer({enabled = false})

  local function close_preview()
    local new_lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)

    local index = 0
    local opts = {}
    for _, line in ipairs(new_lines) do
      local types = {"# Group", "fg", "bg", "bold", "italic", "underline"}
      for _, t in ipairs(types) do
        if string.match(line, t .. ": (.+)") then
          if t == "# Group" then
            index = index + 1
            opts[index] = {}
          end

          opts[index][t] = line:match(t .. ": (.+)")
          opts[index][t] = opts[index][t]:gsub("%s+", "")
        end
      end
    end

    update_highlight(opts)
    api.nvim_win_close(win_id, true)
  end

  -- Auto-close on `BufLeave`
  api.nvim_create_autocmd("BufLeave", {
    buffer = bufnr,
    once = true,
    callback = close_preview,
  })

  api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", "", {
    noremap = true,
    silent = true,
    callback = function() api.nvim_win_close(win_id, true) end
  })
  api.nvim_buf_set_keymap(bufnr, "i", "<Esc>", "", {
    noremap = true,
    silent = true,
    callback = function() api.nvim_win_close(win_id, true) end
  })




end

vim.keymap.set('n', "hh", open_popup, {noremap = true, silent = true})
vim.api.nvim_create_user_command("HighlightPopup", open_popup, {})
