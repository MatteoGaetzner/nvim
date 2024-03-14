return {
    "Julian/lean.nvim",
    dependencies = {
        'neovim/nvim-lspconfig',
        'nvim-lua/plenary.nvim',
        -- you also will likely want nvim-cmp or some completion engine
    },

    -- see details below for full configuration options
    opts = {
        lsp = {
            on_attach = on_attach,
            init_options = {
                -- Time (in milliseconds) which must pass since latest edit until elaboration begins.
                -- Lower values may make editing feel faster at the cost of higher CPU usage.
                editDelay = 100,
            }
        },

        -- Enable suggested mappings?
        mappings = true,

        -- Infoview support
        infoview = {
            -- Automatically open an infoview on entering a Lean buffer?
            autoopen = true,
            -- Set infoview windows' starting dimensions.
            -- Windows are opened horizontally or vertically depending on spacing.
            width = 50,
            height = 10,

            -- Put the infoview on the top or bottom when horizontal?
            -- top | bottom
            horizontal_position = "bottom",
        },
    }
}
