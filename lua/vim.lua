vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 150
vim.opt.tw = 0
vim.opt.mmp = 2000
vim.opt.clipboard = "unnamed"
vim.opt.hidden = true
vim.opt.undodir = vim.env.HOME.."/.cache/nvim/undo"
vim.opt.undofile = true
vim.opt.cursorline = true
vim.opt.timeoutlen = 250

function go_imports()
  vim.cmd([[
      :silent! GoFmt
      :silent! GoImport
      ]])

  local start_pattern = "^\\s*import ($"
  local end_pattern = "^\\s*)$"
  local lxd_pattern = "\\s*lxd \"github.com/canonical/lxd/client\"$"

  local imports = {}
  local in_import_block = false

  -- iterate over every line.
  for i, line in ipairs(vim.fn.getline(1, '$')) do
    -- check if we hit the 'import (' line.
    if not in_import_block and vim.fn.match(line, start_pattern) > -1 then
      in_import_block = true
    end

    if in_import_block then
      -- check if we're out of the import with ')' and exit.
      local end_match = vim.fn.match(line, end_pattern)
      if end_match > -1 then
        in_import_block = false
        break
      end

      -- if we're still in the import, replace any redundant imports.
      if vim.fn.match(line, lxd_pattern) > -1 then
        local new_line = string.gsub(line, "lxd \"github.com", "\"github.com")
        vim.fn.setline(i, new_line)
      end
    end
  end
end

-- Autocmds
vim.cmd([[
  augroup GO_LSP
  	autocmd!
  "	autocmd BufWritePost *.go :silent! lua vim.lsp.buf.formatting()
  "	autocmd BufWritePre *.go :silent! lua OrgImports(1000)
  	autocmd BufWritePre *.go :silent! lua go_imports()
  augroup END

  augroup WHITESPACE
    autocmd!
    autocmd BufWritePre * :silent! :%s/\s\+$//e
  augroup END
]])

vim.cmd([[
set bg=dark
set tabstop=2 shiftwidth=2 expandtab

:command! WQ w<bar>:sleep 100m<bar>:bd
:command! Wq w<bar>:sleep 100m<bar>:bd
:command! W  w
:command! QA qa
:command! Qa qa
:command! Q  q
:cnoreabbrev Qa! qa!
:cnoreabbrev Wa! wa!

":cnoreabbrev q :silent! call CloseOnLast() |:echo ''
:cnoreabbrev wq w<bar>:sleep 100m<bar>:bd
":cnoremap q: q
":cnoremap q\ q
":cnoremap qq q

:noremap z( /(<CR> zfa) :noh<CR>
:noremap z{ /{<CR> zfa} :noh<CR>
:noremap <tab><tab> <C-w>
:map <C-X> <Nop>
unmap <C-X>
map <C-/> <Nop>
map ; <Nop>
map ' <Nop>
:noremap ;' :bn<CR>
:noremap '; :bp<CR>
:nnoremap cc :lua get_hl()<CR>
:nnoremap ff :filetype detect<CR>
:nnoremap CC :ColorizerToggle<CR>
:nnoremap <Esc> :silent! noh<CR>
:nnoremap ;; :Telescope smart_open<cr>
:nnoremap ;; :Telescope file_browser path=%:p:h<cr>
:nnoremap U :Telescope undo<cr>
:nnoremap q: <nop>
:nnoremap q/ <nop>
:nnoremap qq <nop>
:inoremap <S-Up> <Nop>
:inoremap <S-Down> <Nop>
:xnoremap p pgvy


function! JumpToNextWord()
    normal w
    while (strpart(getline('.'), col('.')-1, 1) !~ '\w')
        normal w
    endwhile
endfunction

function! JumpToPrevWord()
    normal b
    while (strpart(getline('.'), col('.')-1, 1) !~ '\w')
        normal b
    endwhile
endfunction


:map <Esc>B :call JumpToPrevWord()<CR>
:map <Esc>F :call JumpToNextWord()<CR>
:inoremap <Esc>B <C-\><C-o>:call JumpToPrevWord()<CR>
:inoremap <Esc>F <C-\><C-o>:call JumpToNextWord()<CR>

function! Start_New_Tab(path)
	execute 'e %:h/' . a:path
endfunction
:command! -nargs=1 TT :call Start_New_Tab(<f-args>)
]])
