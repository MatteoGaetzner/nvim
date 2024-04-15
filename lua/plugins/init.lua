return {
    { 'nvim-lua/plenary.nvim' },
    { 'folke/neodev.nvim',    opts = {} },
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
    { 'numToStr/Comment.nvim', lazy = false },
}
