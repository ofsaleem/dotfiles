call plug#begin('~/.config/nvimpager/plugged')
Plug 'ishan9299/nvim-solarized-lua'
Plug 'lifepillar/vim-solarized8'
call plug#end()

syntax enable
set termguicolors
set background=dark
colorscheme solarized-flat
let g:solarized_termtrans=1
let g:loaded_perl_provider = 0
nnoremap <f10> :call <SID>SynStack()<CR>
function! <SID>SynStack()
	if !exists("*synstack")
		return
	endif
	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
