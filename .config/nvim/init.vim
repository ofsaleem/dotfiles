if &compatible
	set nocompatible
endif

call plug#begin('~/.config/nvim/plugged')
Plug 'lifepillar/vim-solarized8'
call plug#end()


filetype plugin indent on
syntax enable
set termguicolors
set background=dark
colorscheme solarized8_flat
set tabstop=4
set expandtab
set autoindent
set shiftwidth=4
set smarttab
set formatoptions=croqla
set ruler
set noerrorbells
set novisualbell
set softtabstop

