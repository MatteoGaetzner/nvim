local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Keymaps
vim.g.mapleader = " "

-- NOTE: Set this path to the path to your python3 executable!
-- Function to check if a file exists
local function file_exists(path)
	local f = io.open(path, "r")
	if f then
		io.close(f)
		return true
	else
		return false
	end
end

-- Path to the custom Python 3 binary
local custom_python3_path = vim.fn.expand("~/.local/share/micromamba/envs/neovim-python3/bin/python3")

-- Check if the custom Python 3 binary exists
if file_exists(custom_python3_path) then
	vim.g.python3_host_prog = custom_python3_path
else
	-- Emit a warning message
	vim.api.nvim_out_write("Warning: Custom Python 3 binary not found. Falling back to system Python 3.\n")
	-- Set to default system Python 3 binary
	vim.g.python3_host_prog = "python3"
end

-- NOTE: Set this path to the path to your perl executable!
vim.g.perl_host_prog = "/usr/bin/perl"

-- Textwidth (following PEP 8)
vim.opt.textwidth = 79

-- Set backup directory to ~/.cache/nvim/backup
local backupdir = vim.fn.expand("~/.cache/nvim/backup")
vim.fn.mkdir(backupdir, "p") -- Create the directory if it doesn't exist

-- Configure Neovim to use the specified backup directory
vim.opt.backupdir = { backupdir }
vim.opt.directory = { backupdir }

-- Plugins spec.
local plugins = {
	{ 'nvim-lua/plenary.nvim' },
	{
		"hrsh7th/nvim-cmp",
		-- load cmp on InsertEnter
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
		},
	},
	{ "folke/neodev.nvim",    opts = {} },
	{
		'nvim-telescope/telescope.nvim',
		init = function()
			require('telescope').setup({
				pickers = {
					find_files = {
						hidden = true
					}
				},
			})
		end
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
		}
	},
	{
		'creativenull/efmls-configs-nvim',
		version = 'v1.x.x', -- version is optional, but recommended
		dependencies = { 'neovim/nvim-lspconfig' },
	},
	{ 'ThePrimeagen/harpoon' },
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.2',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{ 'numToStr/Comment.nvim', lazy = false },
	{
		"neanias/everforest-nvim",
		version = false,
		lazy = false,
		priority = 1000,
		config = function()
			require("everforest").setup({ ---@diagnostic disable-line
				diagnostic_line_highlight = true,
				italics = true,
				ui_contrast = "high",
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					-- disable rtp plugin, as we only need its queries for mini.ai
					-- In case other textobject modules are enabled, we will load them
					-- once nvim-treesitter is loaded
					require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
					load_textobjects = true ---@diagnostic disable-line
				end,
			},
		},
		cmd = { "TSUpdateSync" },
		keys = {
			{ "<c-space>", desc = "Increment selection" },
			{ "<bs>",      desc = "Decrement selection", mode = "x" },
		},
		---@type TSConfig
		opts = { ---@diagnostic disable-line
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		},
		---@param opts TSConfig
		config = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				---@type table<string, boolean>
				local added = {}
				opts.ensure_installed = vim.tbl_filter(function(lang)
					if added[lang] then
						return false
					end
					added[lang] = true
					return true
				end, opts.ensure_installed) ---@diagnostic disable-line
			end
			require("nvim-treesitter.configs").setup(opts)

			if load_textobjects then
				-- PERF: no need to load the plugin, if we only need its queries for mini.ai
				if opts.textobjects then ---@diagnostic disable-line
					for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
						if opts.textobjects[mod] and opts.textobjects[mod].enable then ---@diagnostic disable-line
							local Loader = require("lazy.core.loader")
							Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
							local plugin = require("lazy.core.config").plugins
							    ["nvim-treesitter-textobjects"]
							require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
							break
						end
					end
				end
			end
		end,
	},
}

require("lazy").setup(plugins, {})

-- Line numbers
vim.o.number = true
local augroup = vim.api.nvim_create_augroup("numbertoggle", {})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
	pattern = "*",
	group = augroup,
	callback = function()
		if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
			vim.opt.relativenumber = true
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
	pattern = "*",
	group = augroup,
	callback = function()
		if vim.o.nu then
			vim.opt.relativenumber = false
			vim.cmd "redraw"
		end
	end,
})

-- Everforest colorscheme
require("everforest").load()


-- Comment.nvim
require('Comment').setup()

-- Harpoon
vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')

-- Telescope fuzzy finder
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Mason and lspconfig (Mason must come first!)
require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "efm" },
}

-- EFM
--- Register linters and formatters per language
local black = require('efmls-configs.formatters.black')
local isort = require('efmls-configs.formatters.isort')
local shfmt = require('efmls-configs.formatters.shfmt')
local shellcheck = require('efmls-configs.linters.shellcheck')
local beautysh = require('efmls-configs.formatters.beautysh')
local yamllint = require('efmls-configs.linters.yamllint')
local languages = {
	python = { black, isort },
	sh = { shfmt, shellcheck },
	bash = { shfmt, shellcheck },
	zsh = { beautysh },
	yaml = { yamllint }
}

local efmls_config = {
	filetypes = vim.tbl_keys(languages),
	settings = {
		rootMarkers = { '.git/' },
		languages = languages,
	},
	init_options = {
		documentFormatting = true,
		documentRangeFormatting = true,
	},
}

local lspconfig = require('lspconfig')
lspconfig.efm.setup(vim.tbl_extend('force', efmls_config, {}))
lspconfig.pyright.setup {}
lspconfig.rust_analyzer.setup {}
lspconfig.lua_ls.setup {
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false,
			},
		},
	},
}


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})

-- Cmp
local cmp = require('cmp')
vim.opt.completeopt = { "menu", "menuone", "noselect" }

cmp.setup({ ---@diagnostic disable-line
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
		{ name = "path" },
	})
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', { ---@diagnostic disable-line
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- Format on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
