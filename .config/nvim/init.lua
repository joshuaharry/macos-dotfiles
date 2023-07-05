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
vim.g.closetag_filetypes = "eruby,svelte"

-- Use lazy.nvim to manage plugins
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

-- Install useful plugins
require("lazy").setup({
  "nvim-treesitter/nvim-treesitter",
  "windwp/nvim-autopairs",
  "windwp/nvim-ts-autotag",
  -- TreeSitter struggles with indenting TSX files, so we use this plugin
  -- as a workaround for now.
  "MaxMEllon/vim-jsx-pretty",
  -- Ditto with Svelte...
  "evanleck/vim-svelte",
  "heavenshell/vim-jsdoc",
  "dcampos/nvim-snippy",
  "tpope/vim-commentary",
  {
    "neoclide/coc.nvim",
    branch = "release",
    build = "yarn install --frozen-lockfile",
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  "Olical/conjure",
  "alvan/vim-closetag",
})

require("nvim-autopairs").setup({})
require('snippy').setup({
  mappings = {
    is = {
      ['<Tab>'] = 'expand_or_advance',
      ['<S-Tab>'] = 'previous',
    },
    nx = {
      ['<leader>x'] = 'cut_text',
    },
  },
})
require('nvim-treesitter.configs').setup({
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = {
    "c",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "python",
    "tsx",
    "typescript",
    "javascript",
    "svelte",
    "json",
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- Automatically install missing parsers when entering buffer
  auto_install = true,
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = true,
  },
})

-- Useful plugin-specific keybidnings
vim.api.nvim_set_keymap('n', '<leader>p', ':call CocAction("format")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sf', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sb', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sh', ':Telescope help_tags<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gy', '<Plug>(coc-type-definition)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-n>', 'coc#pum#visible() ? coc#pum#next(1) : coc#refresh()',
  { noremap = true, silent = true, expr = true })
vim.api.nvim_set_keymap('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : v:lua.MPairs.completion_confirm()',
  { noremap = true, silent = true, expr = true })

vim.cmd([[colorscheme desert]])
