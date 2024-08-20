--change       = {text = '▌'},
--delete       = {text = '▊'},
--add          = {text = '┆+'},
--changedelete = { text = 'ꔖ'},
--
require'gitsigns'.setup {
  signs = {
    topdelete    = {text = '▔'},
    add          = {text = '┃+'},
    change       = {text = '┃~'},
    delete       = {text = '┃_'},
    changedelete = {text = '█'},
    untracked    = {text = '?'},
  },
  signs_staged = {
    topdelete    = {text = '▔'},
    add          = {text = '┃+'},
    change       = {text = '┃~'},
    delete       = {text = '┃_'},
    changedelete = {text = '█'},
    untracked    = { text = '?'},
  },
  current_line_blame = true,
  current_line_blame_formatter = '  ❯❯❯ <abbrev_sha> (<author>, <author_time:%R>) <summary>',
  current_line_blame_opts = {delay = 500},
  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, opts)
      opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    -- Navigation
    map('n', '[g', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
    map('n', ']g', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

    -- Actions
    map('n', 'gs', ':Gitsigns stage_hunk<CR>')
    map('n', 'gu', ':Gitsigns reset_hunk<CR>')
    map('n', 'gS', '<cmd>Gitsigns stage_buffer<CR>')
    map('n', 'gU', '<cmd>Gitsigns undo_stage_hunk<CR>')
--    map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
    map('n', 'gd', '<cmd>Gitsigns preview_hunk<CR>')
    map('n', 'gD', '<cmd>Gitsigns diffthis<CR>')
--   map('n', '<leader>hD', '<cmd>lua require"gitsigns".diffthis("~")<CR>')

    -- Text object
--    map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
--    map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}


  vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'GitSignsAdd' })
  vim.api.nvim_set_hl(0, 'GitSignsAddLn', { link = 'GitSignsAddLn' })
  vim.api.nvim_set_hl(0, 'GitSignsAddNr', { link = 'GitSignsAddNr' })
  vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'GitSignsChange' })
  vim.api.nvim_set_hl(0, 'GitSignsChangeLn', { link = 'GitSignsChangeLn' })
  vim.api.nvim_set_hl(0, 'GitSignsChangeNr', { link = 'GitSignsChangeNr' })
  vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'GitSignsChange' })
  vim.api.nvim_set_hl(1, 'GitSignsChangedeleteLn', { link = 'GitSignsChangeLn' })
  vim.api.nvim_set_hl(0, 'GitSignsChangedeleteNr', { link = 'GitSignsChangeNr' })
  vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'GitSignsDelete' })
  vim.api.nvim_set_hl(0, 'GitSignsDeleteLn', { link = 'GitSignsDeleteLn' })
  vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', { link = 'GitSignsDeleteNr' })
  vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { link = 'GitSignsDelete' })
  vim.api.nvim_set_hl(0, 'GitSignsTopdeleteLn', { link = 'GitSignsDeleteLn' })
  vim.api.nvim_set_hl(0, 'GitSignsTopdeleteNr', { link = 'GitSignsDeleteNr' })


  vim.api.nvim_set_hl(0, 'GitSignsChangedelete',       { fg="#7b1a66"})
  vim.api.nvim_set_hl(0, 'GitSignsTopdelete',          { fg="#7b1a66"})
  vim.api.nvim_set_hl(0, 'GitSignsDelete',             { fg="#7b1a66"})
  vim.api.nvim_set_hl(0, 'GitSignsAdd',                { fg="#3a3a5a"})
  vim.api.nvim_set_hl(0, 'GitSignsChange',             { fg="#3a56db"})

  vim.api.nvim_set_hl(0, 'GitSignsStagedChangedelete', { fg="#43776b"})
  vim.api.nvim_set_hl(0, 'GitSignsStagedTopdelete',    { fg="#43776b"})
  vim.api.nvim_set_hl(0, 'GitSignsStagedDelete',       { fg="#43776b"})
  vim.api.nvim_set_hl(0, 'GitSignsStagedAdd',          { fg="#43776b"})
  vim.api.nvim_set_hl(0, 'GitSignsStagedChange',       { fg="#43776b"})
