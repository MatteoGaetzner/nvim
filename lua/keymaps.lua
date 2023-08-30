local function map(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	---@cast keys LazyKeysHandler
	-- do not create the keymap if a lazy keys handler exists
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

-- Moving lines
map({ "n", "v" }, "<C-J>", ":move .+1<CR>==", { desc = "move line up" })
map({ "n", "v" }, "<C-K>", ":move .-2<CR>==", { desc = "move line down" })
map("i", "<C-J>", "<Esc>:move .+1<CR>==gi", { desc = "move line up" })
map("i", "<C-K>", "<Esc>:move .-2<CR>==gi", { desc = "move line down" })

-- Close tab
map({ "n", "v" }, "<leader>d", "<cmd>bd<cr>", { desc = "Close Tab" })

-- Go to tab by number
map({ "n", "v" }, "<leader>1", "1gt", { desc = "go to tab 1" })
map({ "n", "v" }, "<leader>2", "2gt", { desc = "go to tab 2" })
map({ "n", "v" }, "<leader>3", "3gt", { desc = "go to tab 3" })
map({ "n", "v" }, "<leader>4", "4gt", { desc = "go to tab 4" })
map({ "n", "v" }, "<leader>5", "5gt", { desc = "go to tab 5" })
map({ "n", "v" }, "<leader>6", "6gt", { desc = "go to tab 6" })
map({ "n", "v" }, "<leader>7", "7gt", { desc = "go to tab 7" })
map({ "n", "v" }, "<leader>8", "8gt", { desc = "go to tab 8" })
map({ "n", "v" }, "<leader>9", "9gt", { desc = "go to tab 9" })
map({ "n", "v" }, "<leader>0", ":tablast<CR>")

-- Cut movements
map("n", "m", "d", { desc = "normal mode cut" })
map("x", "m", "d", { desc = "visual mode cut" })
map("n", "mm", "dd", { desc = "normal mode cut line" })
map("n", "M", "D", { desc = "visual mode cut" })

-- Telescope fuzzy finder
local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files, {})
map('n', '<leader>fg', builtin.live_grep, {})
map('n', '<leader>fb', builtin.buffers, {})
map('n', '<leader>fh', builtin.help_tags, {})

-- Diagnostics
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)

-- LSP stuff
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		map('n', 'gD', vim.lsp.buf.declaration, opts)
		map('n', 'gd', vim.lsp.buf.definition, opts)
		map('n', 'K', vim.lsp.buf.hover, opts)
		map('n', 'gi', vim.lsp.buf.implementation, opts)
		map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		map('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		map('n', '<space>D', vim.lsp.buf.type_definition, opts)
		map('n', '<space>rn', vim.lsp.buf.rename, opts)
		map({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		map('n', 'gr', vim.lsp.buf.references, opts)
	end,
})

-- NvimTree
map('n', '<leader>e', ':NvimTreeFindFileToggle!<CR>', { noremap = true })
local function on_attach(bufnr)
	local api = require "nvim-tree.api"
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	map('n', 'l', api.node.open.edit, opts('Open'))
	map('n', 't', api.node.open.tab, opts('Open as Tab'))
end

local tree = require("nvim-tree")

local config = {
	on_attach = on_attach,
}

tree.setup(config)

-- Latex
map("n", "<leader>lf", ":lua FormatLatex()<CR>", { desc = "format file using latexindent" })
map({ "n", "x" }, "<leader>ll", ":VimtexCompile<cr>", { desc = "compile LaTeX document" })
