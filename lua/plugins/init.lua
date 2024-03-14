return {
    { 'nvim-lua/plenary.nvim' },
    { 'folke/neodev.nvim',    opts = {} },
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
