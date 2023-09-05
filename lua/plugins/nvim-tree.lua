local map = require("helpers").map

map('n', '<leader>e', ':NvimTreeFindFileToggle!<CR>', { noremap = true })

local function on_attach(bufnr)
	local api = require "nvim-tree.api"
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	map('n', '?', api.tree.toggle_help, opts('Help'))
	map('n', 'h', api.node.open.horizontal, opts('Open: Horizontal Split'))
	map('n', 'l', api.node.open.edit, opts('Open'))
	map('n', 't', api.node.open.tab, opts('Open as Tab'))
	map('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
	map('n', 'y', api.fs.copy.node, opts('Copy'))
end

-- pass to setup along with your other options
return {
	'nvim-tree/nvim-tree.lua',
	dependencies = {
		'nvim-tree/nvim-web-devicons'
	},
	config = function()
		require("nvim-tree").setup {
			on_attach = on_attach,
		}
	end
}
