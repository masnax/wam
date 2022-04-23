vim.cmd([[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldtext=substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend))
set foldnestmax=5
set foldminlines=1
set foldlevel=99
"set foldmethod=indent
]])

vim.o.foldtext = [[substitute(getline(v:foldstart),'\\\\t',repeat('\\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]

vim.api.nvim_set_keymap('n', 'za', [[<cmd>lua require('fold-cycle').open()<cr>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'zz', [[<cmd>lua require('fold-cycle').close()<cr>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'zC', [[<cmd>lua require('fold-cycle').close_all()<cr>]], {noremap = false, silent = true})
