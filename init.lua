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

-- disable netrw (should be at the very start of init.lua)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Don't highlight search results
vim.opt.hlsearch = false

-- keep cursor in the vertical center
vim.opt.scrolloff = 5

-- Keymaps
vim.g.mapleader = " "

-- Clipboard
vim.opt.clipboard = "unnamedplus"

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

-- Check if the custom Python 3 binary exists
local function error_msg_if_not_exist(fp, default, msg)
	local out = default
	if file_exists(fp) then
		out = fp
	else
		vim.api.nvim_out_write(msg)
	end
	return out
end

LOCAL = require("local")

vim.g.python3_host_prog = error_msg_if_not_exist(LOCAL.python3_host_prog, "python3",
	"Warning: Custom Python 3 binary not found. Falling back to system Python 3.\n")
-- NOTE: Set this path to the path to your perl executable!
vim.g.perl_host_prog = error_msg_if_not_exist(LOCAL.perl_host_prog, "perl", "")

-- Textwidth (following PEP 8)
vim.opt.textwidth = 79

-- Set backup directory to ~/.cache/nvim/backup
local backupdir = vim.fn.expand("~/.cache/nvim/backup")
vim.fn.mkdir(backupdir, "p") -- Create the directory if it doesn't exist

-- Configure Neovim to use the specified backup directory
vim.opt.backupdir = { backupdir }
vim.opt.directory = { backupdir }

-- Load plugins
require("lazy").setup("plugins")

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

-- Comment.nvim
require('Comment').setup()

-- Mason and lspconfig (Mason must come first!)
require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "efm", "gopls", "texlab" },
}

-- EFM

--- Register linters and formatters per language
local black = require('efmls-configs.formatters.black')
local isort = require('efmls-configs.formatters.isort')
local shfmt = require('efmls-configs.formatters.shfmt')
local shellcheck = require('efmls-configs.linters.shellcheck')
local beautysh = require('efmls-configs.formatters.beautysh')
local yamllint = require('efmls-configs.linters.yamllint')
local latexindent = require('efmls-configs.formatters.latexindent')

--- Markdown
local alex = require('efmls-configs.linters.alex')
local prettier = require('efmls-configs.formatters.prettier')

local languages = {
	python = { black, isort },
	sh = { shfmt, shellcheck },
	bash = { shfmt, shellcheck },
	zsh = { beautysh },
	yaml = { yamllint },
	markdown = { alex, prettier },
	tex = { latexindent }
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
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
	'force',
	lsp_defaults.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
)

lspconfig.texlab.setup({})
lspconfig.gopls.setup({})
lspconfig.efm.setup(vim.tbl_extend('force', efmls_config, {}))
lspconfig.pyright.setup({
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = 'openFilesOnly',
			},
		},
	}
})
lspconfig.rust_analyzer.setup {}
lspconfig.marksman.setup {}
lspconfig.lua_ls.setup {
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false,
			},
		},
	},
}

-- Snippets
local ls = require("luasnip")
-- ls.setup({
-- 	snip_env = {
-- 		s = function(...)
-- 			local snip = ls.s(...)
-- 			-- we can't just access the global `ls_file_snippets`, since it will be
-- 			-- resolved in the environment of the scope in which it was defined.
-- 			table.insert(getfenv(2).ls_file_snippets, snip)
-- 		end,
-- 		parse = function(...)
-- 			local snip = ls.parser.parse_snippet(...)
-- 			table.insert(getfenv(2).ls_file_snippets, snip)
-- 		end,
-- 	},
-- })

require('luasnip.loaders.from_vscode').lazy_load()
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/luasnip-snippets/" })
require("luasnip.loaders.from_snipmate").lazy_load()

-- Cmp
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require('cmp')

ls.config.set_config({
	history = true,                      -- Keep last snippet in memory, to be able to jump back into it, once outside the snippet completion process
	updateevents = "TextChanged, TextChangedI", -- Make snippets update while typing
	enable_autosnippets = true,
})

local select_opts = { behavior = cmp.SelectBehavior.Select }

---@diagnostic disable-next-line
cmp.setup({
	snippet = {
		expand = function(args)
			ls.lsp_expand(args.body)
		end
	},
	sources = {
		{ name = 'path' },
		{ name = 'nvim_lsp', keyword_length = 1 },
		{ name = 'buffer',   keyword_length = 1 },
		{ name = 'luasnip',  keyword_length = 1 },
	},
	---@diagnostic disable-next-line
	window = {
		documentation = cmp.config.window.bordered()
	},
	---@diagnostic disable-next-line
	formatting = {
		fields = { 'menu', 'abbr', 'kind' },
		format = function(entry, item)
			local menu_icon = {
				nvim_lsp = '⚙️',
				luasnip = '⚡️',
				buffer = '📄',
				path = '📍',
			}

			item.menu = menu_icon[entry.source.name]
			return item
		end,
	},
	---@diagnostic disable-next-line
	mapping = {
		['<Up>'] = cmp.mapping.select_prev_item(select_opts),
		['<Down>'] = cmp.mapping.select_next_item(select_opts),

		['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
		['<C-n>'] = cmp.mapping.select_next_item(select_opts),

		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),

		-- ['<C-e>'] = cmp.mapping.abort(),
		['<C-l>'] = cmp.mapping.confirm({ select = true }),
		['<CR>'] = cmp.mapping.confirm({ select = false }),

		['<C-f>'] = cmp.mapping(function(fallback)
			if ls.jumpable(1) then
				ls.jump(1)
			else
				fallback()
			end
		end, { 'i', 's' }),

		['<C-b>'] = cmp.mapping(function(fallback)
			if ls.jumpable(-1) then
				ls.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
				-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
				-- they way you will only jump inside the snippet region
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
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

-- Keymaps
require("keymaps")
