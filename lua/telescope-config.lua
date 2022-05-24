vim.cmd([[
:nnoremap // :lua require('telescope.builtin').live_grep({grep_open_files=true})<CR>
:nnoremap \\ :lua require('telescope.builtin').live_grep()<CR>
:nnoremap T :lua require('telescope.builtin').lsp_type_definitions({jump_type="never"})<CR>
:nnoremap <Space> :lua require('telescope.builtin').def_impl({jump_type="never"})<CR>
:nnoremap <Space><Space> :lua require('telescope.builtin').lsp_references({jump_type="never"})<CR>
:nnoremap E :lua require('telescope.builtin').diagnostics()<CR>
:nnoremap '' :lua require('telescope.builtin').lsp_document_symbols()<CR>
]])

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
  },
  n = i,
}


require('telescope').setup({
  defaults = {
   layout_strategy = 'flex',
   layout_config = {
      width = 0.99,
      height = 0.99,
      flex = {flip_columns = 200, },
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
})

return keymaps
