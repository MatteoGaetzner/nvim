return {
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
			"rafamadriz/friendly-snippets"
		},
	},
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp"
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
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.2',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{ 'numToStr/Comment.nvim', lazy = false },
}
