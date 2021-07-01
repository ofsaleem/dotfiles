"if forced into compatible mode, force ourselves out
if &compatible
	set nocompatible
endif

"plugin installations"
call plug#begin('~/.config/nvim/plugged')
Plug 'lifepillar/vim-solarized8'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

"language server activations
lua << EOF

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

require'lspconfig'.gopls.setup{capabilities = capabilities}
require'lspconfig'.pyright.setup{capabilities = capabilities}
require'lspconfig'.bashls.setup{capabilities = capabilities}
require'lspconfig'.dockerls.setup{capabilities = capabilities}
require'lspconfig'.jsonls.setup{
    commands = {
        Format = {
            function()
                vim.lsp.bug.range_formatting({},{0,0},{vim.fn.line("$"),0})
            end
        }
    },
    capabilities = capabilities
}
require'lspconfig'.terraformls.setup{capabilities = capabilities}
require'lspconfig'.vimls.setup{capabilities = capabilities}
require'lspconfig'.yamlls.setup{capabilities = capabilities}

require'compe'.setup({
    enabled = true,
    source = {
        path = true,
        buffer = true,
        nvim_lsp = true,
        tags = true,
        nvim_treesitter = true
    },
    documentation = true
})

require'nvim-treesitter.configs'.setup{
    ensure_installed = "go","bash","json","dockerfile","python","yaml",
    highlight = {
        enable = true
    },
    incremental_selection = {
        enable = true
    },
    indent = {
        enable = true
    }
}

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
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

