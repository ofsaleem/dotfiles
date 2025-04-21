"if forced into compatible mode, force ourselves out
if &compatible
  set nocompatible
endif

"disable perl support
let g:loaded_perl_provider = 0

"disable ruby support
let g:loaded_ruby_provider = 0

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
Plug 'hiphish/rainbow-delimiters.nvim'
Plug 'ellisonleao/glow.nvim'
Plug 'hoob3rt/lualine.nvim'
Plug 'yamatsum/nvim-cursorline', { 'branch': 'nightly'}
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'gennaro-tedesco/nvim-jqx'
Plug 'b3nj5m1n/kommentary'
Plug 'ggandor/leap.nvim'
Plug 'karb94/neoscroll.nvim'
Plug 'folke/which-key.nvim'
"Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'mbbill/undotree'
Plug 'b0o/schemastore.nvim'
Plug 'nvim-tree/nvim-web-devicons'
call plug#end()

"cmp setup
lua << EOF

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end


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
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.fn["vsnip#available"](1) == 1 then
          feedkey("<Plug>(vsnip-expand-or-jump)", "")
        elseif has_words_before() then
          cmp.complete()
        else
          fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
          feedkey("<Plug>(vsnip-jump-prev)", "")
        end
      end, { "i", "s" }),
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
require('leap').add_default_mappings()
require('rainbow-delimiters')

local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
require("ibl").setup { scope = { highlight = highlight } }

hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
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

nnoremap <F5> :UndotreeToggle<CR>

"transparency
let g:solarized_termtrans=1
highlight Normal guibg=none ctermbg=NONE 
highlight NonText guibg=none ctermbg=NONE

