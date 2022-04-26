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

vim.cmd([[
set bg=dark
set tabstop=2 shiftwidth=2 expandtab
:command! WQ wbd
:command! Wq wbd
:command! W  w
:command! QA qa
:command! Qa qa
:command! Q  bd

function! CloseOnLast()
	let cnt = 0

	for i in range(0, bufnr("$"))
		if buflisted(i)
			let cnt += 1
		endif
	endfor

	if cnt > 2
		bprevious|split|bnext|bdel
	elseif cnt == 2
		bdel
	else
		q
	endif
endfunction

:cnoreabbrev q :call CloseOnLast()
:cnoreabbrev wq w<bar>:call CloseOnLast()

:noremap z( /(<CR> zfa) :noh<CR>
:noremap z{ /{<CR> zfa} :noh<CR>
:noremap <tab><tab> <C-w>
:map <C-X> <Nop>
unmap <C-X>
map ; <Nop>
map ' <Nop>
:noremap ;' :bn<CR>
:noremap '; :bp<CR>
:nnoremap cc :TSHighlightCapturesUnderCursor<CR>
:nnoremap ;; :CHADopen<cr>

function! Start_New_Tab(path)
	execute 'e %:h/' . a:path
endfunction
:command! -nargs=1 TT :call Start_New_Tab(<f-args>)
]])

function OrgImports(wait_ms)
  local params = vim.lsp.util.make_range_params()
  params.context = {only = {"source.organizeImports"}}
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for _, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
      else
        vim.lsp.buf.execute_command(r.command)
      end
    end
  end
end

-- Autocmds
vim.cmd([[
augroup GO_LSP
	autocmd!
	autocmd BufWritePost *.go :silent! lua vim.lsp.buf.formatting()
	autocmd BufWritePre *.go :silent! lua OrgImports(1000)
augroup END
]])
