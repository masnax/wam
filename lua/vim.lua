vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 150
vim.opt.tw = 120
vim.opt.mmp = 2000
vim.opt.clipboard = "unnamed"
vim.opt.hidden = true
vim.opt.undodir = vim.env.HOME.."/.cache/nvim/undo"
vim.opt.undofile = true
vim.opt.cursorline = true

-- Autocmds
vim.cmd([[
  function! Ignore_LXD_Import_Alias()
  	:silent! GoFmt
  	:silent! GoImport
    if match(  join(getline(1, 200), "\n")  ,"lxd \"github.com/lxc/lxd/client")!=-1
      :mark a
      :silent! %s/lxd "github.com/"github.com/
      :silent! %s_"\t*github.com/lxc/lxd/client"\n\t*"github.com/lxc/lxd/client"_"github.com/lxc/lxd/client"_
      :'a
    endif
  endfunction

  augroup GO_LSP
  	autocmd!
  "	autocmd BufWritePost *.go :silent! lua vim.lsp.buf.formatting()
  "	autocmd BufWritePre *.go :silent! lua OrgImports(1000)
  	autocmd BufWritePre *.go :silent! call Ignore_LXD_Import_Alias()
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
:nnoremap CC :ColorizerToggle<CR>
:nnoremap <Esc> :silent! noh<CR>
:nnoremap ;; :Telescope smart_open<cr>
:nnoremap ;; :Telescope file_browser path=%:p:h<cr>
:nnoremap U :Telescope undo<cr>
:nnoremap q: <nop>
:nnoremap q/ <nop>
:nnoremap qq <nop>


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
