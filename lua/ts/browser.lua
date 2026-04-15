local action_state = require "telescope.actions.state"
local Path = require "plenary.path"
local os_sep = Path.path.sep
local fb_utils = require "telescope._extensions.file_browser.utils"
local fb_actions = require "telescope".extensions.file_browser.actions;

local M = {}

local function get_input(opts, callback)
  local fb_config = require "telescope._extensions.file_browser.config"
  if fb_config.values.use_ui_input then
    vim.ui.input(opts, callback)
  else
    async.run(function()
      return vim.fn.input(opts)
    end, callback)
  end
end

-- utility to get absolute path of target directory for create, copy, moving files/folders
local get_target_dir = function(finder)
  local entry_path
  if finder.files == false then
    local entry = action_state.get_selected_entry()
    entry_path = entry and entry.value -- absolute path
  end
  return finder.files and finder.path or entry_path
end

local insert_mode = function()
  if vim.api.nvim_get_mode().mode ~= "i" then
    vim.cmd("startinsert")
  end
end

M.create = function(bufnr)
  fb_actions.create(bufnr)
  insert_mode()
end

M.goto_path = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local finder = current_picker.finder

  --local base_dir = get_target_dir(finder) .. os_sep
  local base_dir = ""
  get_input({ prompt = "goto: ", default = base_dir, completion = "file" }, function(input)
    vim.cmd [[ redraw ]] -- redraw to clear out vim.ui.prompt to avoid hit-enter prompt
    if not input or vim.fn.isdirectory(input) == 0 then
      local msg = "Path"
      if input then
        msg = msg..":"..input
      end

      fb_utils.notify("action.goto_path", {msg = msg.." is not a directory", level = "ERROR", quiet = finder.quiet})
      return
    end

    finder.path = input
    finder.cwd = finder.path
    fb_utils.redraw_border_title(current_picker)
    current_picker:refresh(
      finder,
      { new_prefix = fb_utils.relative_path_prefix(finder), reset_prompt = true, multi = current_picker._multi }
    )
  end)
  --insert_mode()
end

M.set_cwd = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local finder = current_picker.finder
  local base_dir = get_target_dir(finder) .. os_sep

  get_input({ prompt = "CWD: ", default = base_dir, completion = "file" }, function(input)
    vim.cmd [[ redraw ]] -- redraw to clear out vim.ui.prompt to avoid hit-enter prompt
    if not input or vim.fn.isdirectory(input) == 0 then
      local msg = "CWD"
      if input then
        msg = msg..":"..input
      end

      fb_utils.notify("action.set_cwd", {msg = msg.." is not a directory", level = "ERROR", quiet = finder.quiet})
      return
    end

    finder.path = input
    finder.cwd = finder.path
    vim.cmd("cd " .. finder.path)
    current_picker:refresh(
      finder,
      { new_prefix = fb_utils.relative_path_prefix(finder), reset_prompt = true, multi = current_picker._multi }
    )
    fb_utils.redraw_border_title(current_picker)
    current_picker.prompt_border:change_title(vim.fn.getcwd())
    fb_utils.notify(
      "action.change_cwd",
      { msg = "CWD:"..input, level = "INFO", quiet = finder.quiet }
    )
  end)
  insert_mode()
end

return M
