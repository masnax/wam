local ts = require('telescope.builtin')
local make_entry = require "telescope.make_entry"
local function nnoremap(key, func)
  vim.keymap.set('n', key, func, {noremap = true, silent = true})
end

vim.cmd([[
:nnoremap T :lua require('telescope.builtin').lsp_type_definitions({jump_type="never"})<CR>
:nnoremap EE :lua require('telescope.builtin').diagnostics()<CR>
]])

vim.keymap.set('n', '<Space>g', function()
  ts.grep_string({search = vim.fn.input("Grep > "), use_regex = true})
end)

nnoremap('<Space>', function()
  local opts = {jump_type="never", wrap_results=true, show_line=false,  fname_width=2000, default_text=":file:"}
  opts.entry_maker = test_mock_tags(make_entry.gen_from_quickfix(opts), "filename")
  ts.def_impl(opts)
end)

nnoremap('<Space><Space>', function()
  local opts = {jump_type="never", include_declaration=false, wrap_results=true, show_line=false,  fname_width=2000, default_text=":file:"}
  opts.entry_maker = test_mock_tags(make_entry.gen_from_quickfix(opts), "filename")
  ts.lsp_references(opts)
end)

nnoremap('//', function() ts.live_grep({grep_open_files=true, wrap_results=true}) end)
--nnoremap('\\', function() ts.live_grep({wrap_results=true}) end)
nnoremap('\\\\', function()
  local opts = {hidden=true, default_text = ":file:"}
  opts.entry_maker = test_mock_tags(make_entry.gen_from_file(opts), 1)
  ts.find_files(opts)
end)

nnoremap(';;', function()
  local opts = { path='%:p:h', _entry_cache = {}, default_text = ":file:" }
  opts.entry_maker = function(local_opts)
    local fb_make_entry = require "telescope._extensions.file_browser.make_entry"
    return test_mock_tags(fb_make_entry(vim.tbl_extend("force", opts, local_opts)), 1)
  end
  require'telescope'.extensions.file_browser.file_browser(opts)
end)

nnoremap("''", function() ts.lsp_document_symbols({wrap_results=true, fname_width=2000, symbol_width=50}) end)


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
    ["<C-L>"] = function(bufnr)
      if vim.fn.pumvisible() == 1 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, false, true), 'n', true)
      else
      actions.complete_tag(bufnr)
      end
    end,
    ["<C-/>"] = actions.which_key,
    ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
  },
  n = i,
}


local fb_actions = require "telescope".extensions.file_browser.actions;
local conf = require("telescope.config").values
local fzf_sorter = require("telescope").extensions.fzf.native_fzf_sorter
-- lcocal default_sorter = conf.generic_sorter({})
local tag_sorter = conf.prefilter_sorter { tag = "test_mock", sorter = fzf_sorter({fuzzy = true, case_mode = "smart_case"}) }
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
    mappings = {
      i = {["<C-l>"] = keymaps["i"]["<C-L>"]},
    },
    --sorting_strategy = "ascending",
    -- layout_config = { horizontal = { prompt_position = "top", }, },
  },
  pickers = {
    find_files = { mappings = keymaps, sorter = tag_sorter },
    live_grep = { mappings = keymaps },
    lsp_type_definitions = { mappings = keymaps },
    lsp_references = { mappings = keymaps, sorter = tag_sorter },
    diagnostics = { mappings = keymaps },
  },
  extensions = {
     fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    },
    file_browser = {
      prompt_title = vim.fn.getcwd(),
      sorter = conf.file_sorter(),
      sorter = conf.prefilter_sorter { tag = "test_mock", sorter = conf.file_sorter() },
      mappings = {
        i = {
          ["<TAB>"] = actions.toggle_selection,
          ["<C-Space>"] = open_in_hover,
          ["<CR>"] = function(prompt_bufnr, dir)
            local entry = action_state.get_selected_entry()
            if entry and entry.Path:is_dir() then
              fb_actions.open_dir(prompt_bufnr, "default")
            else
              telescope_custom_actions.multi_selection_open(prompt_bufnr)
            end
          end,
        },
        n = {
          ["n"] = function(bufnr)
            fb_actions.create(bufnr)
            vim.api.nvim_feedkeys("i", "n", false)
          end,
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
require('telescope').load_extension('fzf')
return keymaps
