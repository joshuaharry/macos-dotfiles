-- Configure tabs/spaces/line numbers
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Useful vanilla keybindings
vim.api.nvim_set_keymap('n', 'q', ':q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>w', '<C-w><C-w>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>j', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>k', ':bprev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', 'za', { noremap = true, silent = true })


-- Make sure that vim-closetag works on ERB files. We have to set this
-- global variable *before* we configure our plugin manager; otherwise,
-- the plugin doesn't actually work for mysterious raisins.
vim.g.closetag_filetypes = "eruby,template"

-- Bootstrap the Plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install Plugins
require("lazy").setup({
  -- Manage language server installations
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {"pyright", "gopls"},
      handlers = { 
        function(server_name) 
          require("lspconfig")[server_name].setup({})
        end 
      },
    },
  },
  "neovim/nvim-lspconfig",
  -- Manage comments
  {
    'numToStr/Comment.nvim',
    opts = {}
  },
  -- Manage auto pairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },
  -- Manage snippets
  {
    'dcampos/nvim-snippy',
    opts = {
      mappings = {
        is = {
          ['<Tab>'] = 'expand_or_advance',
          ['<S-Tab>'] = 'previous',
        },
      },
    },
  },
  'dcampos/cmp-snippy',
  -- Manage autocomplete
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path"
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require('snippy').expand_snippet(args.body)
          end,
        },
        completion = {
          autocomplete = false,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-n>'] = cmp.mapping(function() 
              if cmp.visible() then
                cmp.select_next_item()
              else
                cmp.complete()
              end
          end),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-space>'] = cmp.mapping.complete(),
          ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i','c'}),
          -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'snippy' },
          { name = "path" },
          { name= 'buffer' },
        })
      })
    end
  },
  {
    'projekt0n/github-nvim-theme',
    config = function ()
      vim.cmd.colorscheme("github_light_high_contrast")
    end
  },
})
