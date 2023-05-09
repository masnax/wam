vim.cmd([[
:nnoremap // :lua require('telescope.builtin').live_grep({grep_open_files=true})<CR>
:nnoremap \\ :lua require('telescope.builtin').live_grep()<CR>
:nnoremap T :lua require('telescope.builtin').lsp_type_definitions({jump_type="never"})<CR>
:nnoremap <Space> :lua require('telescope.builtin').def_impl({jump_type="never", fname_width=2000})<CR>
:nnoremap <Space><Space> :lua require('telescope.builtin').lsp_references({jump_type="never", include_declaration=false, fname_width=2000})<CR>
:nnoremap EE :lua require('telescope.builtin').diagnostics()<CR>
:nnoremap '' :lua require('telescope.builtin').lsp_document_symbols()<CR>
]])

vim.keymap.set('n', '<Space>g', function()
  require('telescope.builtin').grep_string({search = vim.fn.input("Grep > "), use_regex = true})
end)

local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local telescope_custom_actions = {}

function telescope_custom_actions._multiopen(prompt_bufnr, open_cmd)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local selected_entry = action_state.get_selected_entry()
  local num_selections = #picker:get_multi_selection()
  if not num_selections or num_selections <= 1 then
    actions.add_selection(prompt_bufnr)
  end
  actions.send_selected_to_qflist(prompt_bufnr)
  vim.cmd("cfdo " .. open_cmd)
end

function telescope_custom_actions.multi_selection_open_vsplit(prompt_bufnr)
  telescope_custom_actions._multiopen(prompt_bufnr, "vsplit")
end
function telescope_custom_actions.multi_selection_open_split(prompt_bufnr)
  telescope_custom_actions._multiopen(prompt_bufnr, "split")
end
function telescope_custom_actions.multi_selection_open_tab(prompt_bufnr)
  telescope_custom_actions._multiopen(prompt_bufnr, "tabe")
end
function telescope_custom_actions.multi_selection_open(prompt_bufnr)
  telescope_custom_actions._multiopen(prompt_bufnr, "edit")
end

function open_in_hover(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  actions.close(prompt_bufnr)

  local Popup = require("nui.popup")
  local event = require'nui.utils.autocmd'.event

  local popup = Popup({
    enter = true,
    focusable = true,
    border = "single",
    position = "50%",
    size = {width = "80%", height = "80%"},
  })

  local table_val = ""
  local function key_exists(table, key)
    if type(table) == "table" then
      if table[key] ~= nil then
        table_val = table[key]
        return true
      else
        for k, v in pairs(table) do
          if type(v) == "table" then
            if key_exists(v, key) then
              table_val = v[key]
              return true
            end
          end
        end
      end
    end
    return false
  end

  if key_exists(entry, "filename") ~= true then
    if key_exists(entry, "value") ~= true then
      return
    end
  end

  popup:mount()
  popup:on(event.BufLeave, function()
    popup:unmount()
  end)

  vim.api.nvim_buf_set_keymap(popup.bufnr, 'n', '<Esc>', ':lua vim.api.nvim_buf_delete('..popup.bufnr..', {force = true})<CR>', {nowait=true, silent=true})
  vim.api.nvim_buf_set_option(popup.bufnr, "buflisted", false)
  vim.api.nvim_buf_set_option(popup.bufnr, "buftype", "nofile")
  vim.api.nvim_buf_set_option(popup.bufnr, "swapfile", false)
  vim.api.nvim_buf_set_option(popup.bufnr, "swapfile", false)

  vim.api.nvim_command("set nomodified")
  vim.api.nvim_command("set nomodeline")
  vim.api.nvim_command("set readonly")
  vim.api.nvim_command("file " .. popup.bufnr .. "-preview--" .. table_val)
  vim.api.nvim_command("$read" .. table_val)
  table_val = "0"
  key_exists(entry, "lnum")
  vim.api.nvim_command(":"..table_val)
  vim.api.nvim_command("filetype detect")
end

local keymaps = {
  i = {
    ["<ESC>"] = actions.close,
    ["<C-J>"] = actions.move_selection_next,
    ["<C-K>"] = actions.move_selection_previous,
    ["<TAB>"] = actions.toggle_selection,
    ["<S-Up>"] = actions.toggle_selection + actions.move_selection_previous,
    ["<S-Down>"] = actions.move_selection_next + actions.toggle_selection,
    ["<CR>"] = telescope_custom_actions.multi_selection_open,
    ["<C-V>"] = telescope_custom_actions.multi_selection_open_vsplit,
    ["<C-S>"] = telescope_custom_actions.multi_selection_open_split,
    ["<C-T>"] = telescope_custom_actions.multi_selection_open_tab,
    ["<C-DOWN>"] = actions.cycle_history_next,
    ["<C-UP>"] = actions.cycle_history_prev,
    ["<A-UP>"] = actions.preview_scrolling_up,
    ["<A-DOWN>"] = actions.preview_scrolling_down,
    ["<C-Space>"] = open_in_hover,
  },
  n = i,
}


local fb_actions = require "telescope".extensions.file_browser.actions;
require('telescope').setup({
  defaults = {
    layout_strategy = 'flex',
    layout_config = {
      width = 0.99,
      height = 0.99,
      flex = {flip_columns = 100, },
      vertical = { preview_height = 0.8 },
      horizontal = { preview_width = 0.6 },
    },
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
    --sorting_strategy = "ascending",
    -- layout_config = { horizontal = { prompt_position = "top", }, },
  },
  pickers = {
    find_files = { mappings = keymaps },
    live_grep = { mappings = keymaps },
    lsp_type_definitions = { mappings = keymaps },
    lsp_references = { mappings = keymaps },
    diagnostics = { mappings = keymaps },
  },
  extensions = {
    file_browser = {
      mappings = {
        i = {
          ["<C-Space>"] = open_in_hover,
        },
        n = {
          ["c"] = fb_actions.change_cwd,
          ["h"] = fb_actions.toggle_hidden,
          ["."] = fb_actions.toggle_hidden,
          ["<Space>"] = fb_actions.change_cwd,
          ["<CR>"] = function(prompt_bufnr)
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            local finder = current_picker.finder
            local os_sep = require'plenary.path'.path.sep
            local fb_utils = require "telescope._extensions.file_browser.utils"
            local input = current_picker:_get_prompt()
            finder.cwd = input
            finder.path = input

            fb_utils.redraw_border_title(current_picker)
            current_picker:refresh(finder, { reset_prompt = true, multi = current_picker._multi })
            fb_utils.notify(
              "action.change_cwd",
              { msg = input, level = "INFO", quiet = finder.quiet }
            )
          end,
        }
      }
    },
  }
})
require("telescope").load_extension("file_browser")
require("telescope").load_extension("undo")
require("telescope").load_extension("smart_open")
return keymaps
