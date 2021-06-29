"if forced into compatible mode, force ourselves out
if &compatible
	set nocompatible
endif

"plugin installations"
call plug#begin('~/.config/nvim/plugged')
Plug 'lifepillar/vim-solarized8'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
call plug#end()

"language server activations
lua << EOF
require'lspconfig'.gopls.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.dockerls.setup{}
require'lspconfig'.jsonls.setup{
    commands = {
        Format = {
            function()
                vim.lsp.bug.range_formatting({},{0,0},{vim.fn.line("$"),0})
            end
        }
    }
}
require'lspconfig'.terraformls.setup{}
require'lspconfig'.vimls.setup{}
require'lspconfig'.yamlls.setup{}

require'compe'.setup({
    enabled = true,
    source = {
        path = true,
        buffer = true,
        nvim_lsp = true,
    },
})
EOF



"return to our last position in a file when reopening it
autocmd BufReadPost *
	\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
	\ |   exe "normal! g`\""
	\ | endif

"preferences
filetype plugin indent on
syntax enable
set termguicolors
set background=dark
"this ones a plugin, so itll fail if not found
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
set completeopt=menuone,noselect
