-- Configure tabs/spaces/line numbers
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.background = "light"
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Useful vanilla keybindings
vim.api.nvim_set_keymap("n", "q", ":q<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>w", "<C-w><C-w>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>j", ":bnext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>k", ":bprev<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>f", "za", { noremap = true, silent = true })

-- Make sure that vim-closetag works on ERB files. We have to set this
-- global variable *before* we configure our plugin manager; otherwise,
-- the plugin doesn't actually work for mysterious raisins.
vim.g.closetag_filetypes = "eruby,template,typescriptreact,javascriptreact"

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
			ensure_installed = {
				"pyright",
				"gopls",
				"svelte",
				"tsserver",
				"eslint",
				"solargraph",
			},
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
				["solargraph"] = function()
					require("lspconfig").solargraph.setup({
						filetypes = { "ruby", "rakefile" },
						settings = {
							solargraph = {
								diagnostics = true,
							},
						},
					})
				end,
			},
		},
	},
	"neovim/nvim-lspconfig",
	-- Manage comments
	{
		"numToStr/Comment.nvim",
		opts = {},
	},
	-- Manage auto pairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	-- Manage HTML completions
	"alvan/vim-closetag",
	-- Manage snippets
	{
		"dcampos/nvim-snippy",
		opts = {
			mappings = {
				is = {
					["<Tab>"] = "expand_or_advance",
					["<S-Tab>"] = "previous",
				},
			},
		},
	},
	"dcampos/cmp-snippy",
	-- Manage autocomplete
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			-- Set up jump to definition
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { noremap = true, silent = true })

			-- Make error messages appear inside popups
			vim.o.updatetime = 250
      
			vim.diagnostic.config({
				virtual_text = true,
				float = {
					source = "always",
					width = 80,
					border = border,
				},
			})

			vim.api.nvim_create_autocmd({
				"CursorHold",
				"CursorHoldI",
			}, {
				callback = function()
					if not cmp.visible() then
						vim.diagnostic.open_float(nil, { focus = false })
					end
				end,
			})

			cmp.setup({
				snippet = {
					expand = function(args)
						require("snippy").expand_snippet(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-n>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.select_next_item()
						else
							cmp.complete()
						end
					end),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-space>"] = cmp.mapping.complete(),
					["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
					-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "snippy" },
					{ name = "path" },
					{ name = "buffer" },
				}),
			})
		end,
	},
	-- Manage colorscheme
	{
		"NLKNguyen/papercolor-theme",
		config = function()
			vim.cmd.colorscheme("papercolor")
		end,
	},
	-- Manage Fuzzy Finding
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			vim.api.nvim_set_keymap("n", "<leader>sf", ":Telescope find_files<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<leader>sg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<leader>sb", ":Telescope buffers<CR>", { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "<leader>sh", ":Telescope help_tags<CR>", { noremap = true, silent = true })
		end,
	},
	-- Manage Formatting
	{
		"sbdchd/neoformat",
		config = function()
			vim.api.nvim_set_keymap("n", "<leader>p", ":Neoformat<CR>", { noremap = true, silent = true })
		end,
	},
	-- Manage Syntax Highlighting
	--
	-- If and when indentation and syntax highlighting in React and Svelte files
	-- works with TreeSitter, we might want to consider using that; until then,
	-- the classic plugins will suffice.
	--
	-- JSX
	{
		"maxmellon/vim-jsx-pretty",
		dependencies = {
			"yuezk/vim-js",
			"HerringtonDarkholme/yats.vim",
		},
	},
	-- Svelte
	{
		"evanleck/vim-svelte",
		dependencies = {
			"pangloss/vim-javascript",
			"othree/html5.vim",
		},
	},
})
