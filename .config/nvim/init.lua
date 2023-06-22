-- Configure tabs/spaces/line numbers
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.g.mapleader = " "

-- Useful vanilla keybindings
vim.api.nvim_set_keymap('n', 'q', ':q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>w', '<C-w><C-w>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>j', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>k', ':bprev<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', 'za', { noremap = true, silent = true })

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
  {
    "neoclide/coc.nvim",
    branch = "master",
    build = "yarn install --frozen-lockfile",
  },
})

vim.cmd.colorscheme('desert')

require("nvim-autopairs").setup({})

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
