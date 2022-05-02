-- This is a line
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values


local function get_locations(locs, action, opts)
  local params = vim.lsp.util.make_position_params(opts.winnr)
  local function lsp_hook_get(err, result, id)
    if err then
      vim.api.nvim_err_writeln("Error when executing " .. action .. " : " .. err.message)
      return
    end
    local flattened_results = {}
    if result then
      -- textDocument/definition can return Location or Location[]
      if not vim.tbl_islist(result) then
        flattened_results = { result }
      end

      vim.list_extend(flattened_results, result)
    end

    local offset_encoding = vim.lsp.get_client_by_id(id).offset_encoding

    if #flattened_results == 0 then
      return
    else
      local locations = vim.lsp.util.locations_to_items(flattened_results, offset_encoding)
      if next(locs) == nil then
        locs = locations
      else
        for _, v in pairs(locations) do
          table.insert(locs, v)
        end
      end
    end
  end

  local results = vim.lsp.buf_request_sync(opts.bufnr, action, params, 500)
  if results then
    for k, v in pairs(results) do
      lsp_hook_get(v["error"], v["result"], k)
    end
  end

  return locs
end



local config = require("telescope-config")
local def_impl = function(opts)
  opts = opts or {}
  local store = get_locations({}, "textDocument/definition", opts)
  store = get_locations(store, "textDocument/implementation", opts)

  if next(store) == nil then
    vim.api.nvim_err_writeln("Found no matches")
    return
  end

  pickers.new(opts, {
    prompt_title = "LSP Defs / Impls",
    finder = finders.new_table {
      results = store,
      entry_maker = opts.entry_maker or make_entry.gen_from_quickfix(opts),
    },
    previewer = conf.qflist_previewer(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(_, map)
      for k, v in pairs(config.i) do
        map('n', k, v)
        map('i', k, v)
      end
        return true
    end
  }):find()
end

local builtin = require('telescope.builtin')
builtin.def_impl = def_impl
