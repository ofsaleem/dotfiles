-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out  = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- set leader to spacebar
vim.g.mapleader = " "
-- set local leader to backslash
vim.g.maplocalleader = "\\"
-- disable ruby support
vim.g.loaded_ruby_provider = 0


-- preferences
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.formatoptions = "jctn1roq"
vim.opt.ruler = true
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.foldmethod = "expr"
vim.opt.foldlevelstart = 1
vim.opt.foldnestmax = 2
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.number = true
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- plugins
require("lazy").setup({
  spec = {
    "ishan9299/nvim-solarized-lua",
    {
      "neovim/nvim-lspconfig",
      event = "FileType",
      config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local status_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
        if status_ok then
          capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
        end
        vim.lsp.config("*", {
          capabilities = capabilities,
        })
        vim.lsp.config('jsonls', {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
          commands = {
            Format = {
              function()
                vim.lsp.buf.format({ async = true })
              end
            }
          },
        })
        vim.lsp.config('yamlls', {
          settings = {
            schemaStore = {
              enable = true
            },
          },
        })
        vim.lsp.config('vtsls', {
          cmd = { 'vtsls', '--stdio' },
          filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
          root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
        })
        vim.lsp.enable({ 'gopls', 'pyright', 'bashls', 'dockerls', 'jsonls', 'terraformls', 'jsonnet_ls', 'vimls', 'yamlls', 'vtsls' })
      end
    },
    {
      "hrsh7th/nvim-cmp",
      event = { "InsertEnter" },
      dependencies = { "onsails/lspkind-nvim" },
      config = function()
        local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end
        local feedkey = function(key, mode)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
        end
        
        local cmp = require("cmp")
        cmp.setup({
          formatting = {
            format = require("lspkind").cmp_format({
              mode = "symbol_text",
              maxwidth = 50, 
              ellipsis_char = "...",
            })
          },
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
                fallback() -- the fallback function sends an already mapped key. in this case its probably tab
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function()
              if cmp.visible() then
                cmp.select_prev_item()
              elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
              end
            end),
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = false }), -- accept currently selected item. set 'select' to 'false' to only confirm explicitly selected items
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
            { name = 'render-markdown' },
          }, {
            { name = 'buffer' },
          })
        })
        
        -- specific filetypes
        cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
            { name = 'git' },
          }, {
            { name = 'buffer' },
          })
        })

        -- use buffer source for / and ?
        cmp.setup.cmdline({ '/', '?' }, {
          mapping =  cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })

        -- use cmdline and path source for :
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })

      end
    },
    "hrsh7th/vim-vsnip",
    "hrsh7th/cmp-vsnip",
    {
      "petertriho/cmp-git",
      dependencies = { "hrsh7th/nvim-cmp" },
      opts = {},
    },
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/vim-vsnip-integ",
    "rafamadriz/friendly-snippets",
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        local configs = require("nvim-treesitter")
        configs.setup({
          ensure_installed = { "go", "bash", "json", "dockerfile", "python", "yaml", "diff", "jq", "jsonnet", "make", "markdown", "markdown_inline", "mermaid", "terraform", "vim", "javascript", "latex", "lua" },
          highlight = {
            enabled = true,
            additional_vim_regex_highlighting = false,
          },
          incremental_selection = {
            enable = true,
          },
          indent = {
            enable = false, -- experimental feature that supposedly sucks, but i can always reenable it here
          },
        })
      end,
    },
    {
      "hiphish/rainbow-delimiters.nvim",
      config = function()
        vim.g.rainbow_delimiters = {
          strategy = {
            [''] = 'rainbow-delimiters.strategy.global',
            vim = 'rainbow-delimiters.strategy.local',
          },
          query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
          },
          priority = {
            [''] = 110,
            lua = 210,
          },
          highlight = { -- these are references here, they are actually defined in the IBL config. if we change a name, update the refs
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
          },
        }
      end,
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        options = {
          theme = "solarized_dark",
        },
      },
    },
    {
      "yamatsum/nvim-cursorline",
      opts = {},
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        local highlight = {
          "RainbowRed",
          "RainbowYellow",
          "RainbowBlue",
          "RainbowOrange",
          "RainbowGreen",
          "RainbowViolet",
          "RainbowCyan",
        }
        local dim = {
          "Gray1",
          "Gray2",
          "Gray3",
          "Gray4",
          "Gray5",
          "Gray6",
          "Gray7",
        }
        local hooks = require("ibl.hooks")
        
        --  register highlights so they persist across colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
          vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
          vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
          vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
          vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
          vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
          vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
          vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
          -- for indents without scope
          vim.api.nvim_set_hl(0, "Gray1", { fg = "#073642" }) -- Deepest backdrop tone
          vim.api.nvim_set_hl(0, "Gray2", { fg = "#2a3d42" })
          vim.api.nvim_set_hl(0, "Gray3", { fg = "#44555b" })
          vim.api.nvim_set_hl(0, "Gray4", { fg = "#586e75" }) -- Official Comment color
          vim.api.nvim_set_hl(0, "Gray5", { fg = "#657b83" }) -- Content gray
          vim.api.nvim_set_hl(0, "Gray6", { fg = "#839496" }) -- Standard text color
          vim.api.nvim_set_hl(0, "Gray7", { fg = "#93a1a1" }) -- Brightest gray/white
        end)
        
        -- bind scope highlights from extmarks
        hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        require("ibl").setup({
          indent = {
            highlight = dim,
          },
          scope = {
            highlight = highlight,
            show_exact_scope = true,
          },
        })
      end,
    },
    {
      "gennaro-tedesco/nvim-jqx",
      event = {"BufReadPost"},
      ft = { "json", "yaml" },
    },
    "numToStr/Comment.nvim",
    {
      "https://codeberg.org/andyg/leap.nvim",
      lazy = false,
      config = function()
        -- jump
        vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
        vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
        -- visit (jump, operate, jump back)
        vim.keymap.set({ 'n', 'x', 'o' }, 'gs', function()
          require('leap').visit { input = (vim.fn.mode(true) == 'n') and 'v' or '' }
        end)
        vim.keymap.set({ 'x', 'o' }, 'ar', '<Plug>(leap-visit-text-object)')
        vim.keymap.set({ 'x', 'o' }, 'ir', '<Plug>(leap-visit-inner-text-object)')
-- visit line
        vim.keymap.set('o', 'rr', function()
          return (vim.v.count == 0 and '1' or '') .. '<Plug>(leap-visit)'
        end, { expr = true })
        -- autopaste on return
        vim.api.nvim_create_autocmd('User', {
          pattern = 'VisitDone',
          group = vim.api.nvim_create_augroup('Visit', {}),
          callback = function(event)
            if
              (event.data.mode:match('^[vV\22]') or (vim.v.operator == 'y'))
              and event.data.register == '"'
            then
              vim.cmd('normal! p')
            end
          end,
        })
        -- treeselect
        vim.keymap.set({ 'x', 'o' }, 'an', function()
          require('leap.treesitter').select {
            opts = require('leap.user').with_traversal_keys('n', 'N')
          }
        end)
      end,
    },
    {
      "karb94/neoscroll.nvim",
      opts = {},
    },
    {
      "folke/which-key.nvim",
      opts = {},
    },
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    {
      "mbbill/undotree",
      keys = {
        { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
      },
    },
    "b0o/schemastore.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
  },
  checker = { enabled = true },
})

-- return to our last position in file
vim.api.nvim_create_autocmd('BufRead', {
  callback = function(opts)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          not (ft:match('commit') or ft:match('rebase'))
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})

vim.cmd.colorscheme("solarized-flat") -- this is a plugin that will fail if its not found
-- transparency
vim.g.solarized_termtrans = 1
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
