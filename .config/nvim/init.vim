"if forced into compatible mode, force ourselves out
if &compatible
  set nocompatible
endif

"disable perl support
let g:loaded_perl_provider = 0

"plugin installations"
call plug#begin('~/.config/nvim/plugged')
"Plug 'lifepillar/vim-solarized8'
Plug 'ishan9299/nvim-solarized-lua'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-vsnip'
Plug 'petertriho/cmp-git'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plug 'google/vim-jsonnet'
Plug 'onsails/lspkind-nvim'
Plug 'p00f/nvim-ts-rainbow'
Plug 'ellisonleao/glow.nvim'
Plug 'hoob3rt/lualine.nvim'
Plug 'yamatsum/nvim-cursorline', { 'branch': 'nightly'}
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'gennaro-tedesco/nvim-jqx'
Plug 'b3nj5m1n/kommentary'
Plug 'ggandor/lightspeed.nvim'
Plug 'karb94/neoscroll.nvim'
Plug 'folke/which-key.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'mbbill/undotree'
Plug 'b0o/schemastore.nvim'
call plug#end()

"cmp setup
lua << EOF
local cmp = require'cmp'

cmp.setup({
  snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
})

  -- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

  -- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require'lspconfig'.gopls.setup{capabilities = capabilities}
require'lspconfig'.pyright.setup{capabilities = capabilities}
require'lspconfig'.bashls.setup{capabilities = capabilities}
require'lspconfig'.dockerls.setup{capabilities = capabilities}
require'lspconfig'.jsonls.setup{
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
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
require'lspconfig'.yamlls.setup{
  settings = {
    schemaStore = {
      enable = true
    },
  },
  capabilities = capabilities
}
require'lspconfig'.jsonnet_ls.setup{capabilities = capabilities}


require'nvim-treesitter.configs'.setup{
  ensure_installed = { "go","bash","json","dockerfile","python","yaml", "diff", "jq", "jsonnet", "make", "markdown", "markdown_inline", "mermaid", "terraform", "vim", "javascript" },
  highlight = {
    enable = true
  },
  incremental_selection = {
    enable = true
  },
  indent = {
    enable = true
  },
  rainbow = {
    enable = true
  }
}

require'lspkind'.init()
require'lualine'.setup{
  options = { theme = 'solarized_dark' },
}

require('neoscroll').setup()
require("which-key").setup{}
require('glow').setup()

require'nvim-cursorline'
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
colorscheme solarized-flat
set tabstop=2
set expandtab
set autoindent
set softtabstop=2
set shiftwidth=2
set formatoptions=jctn1roq
set ruler
set noerrorbells
set novisualbell
set completeopt=menuone,noselect
set foldmethod=expr foldlevelstart=1 foldnestmax=2
set foldexpr=nvim_treesitter#foldexpr()
set number
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize=25
"mapping stuff
lua << EOF
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn.call("vsnip#available", {1}) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['cmp#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

EOF

nnoremap <F5> :UndotreeToggle<CR>

"transparency
let g:solarized_termtrans=1
highlight Normal guibg=none ctermbg=NONE 
highlight NonText guibg=none ctermbg=NONE

"indent stuff
lua vim.g.indent_blankline_char = "│"
highlight IndentBlankLineChar guifg=DarkGreen gui=nocombine
lua vim.g.indent_blankline_show_trailing_blankline_indent = false
