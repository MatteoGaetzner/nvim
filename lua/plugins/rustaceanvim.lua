return {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false,   -- This plugin is already lazy
    ft = { 'rust' },
    config = function()
        ---@type RustaceanOpts
        vim.g.rustaceanvim = {
            ---@type RustaceanLspClientOpts
            server = {
                default_settings = {
                    -- rust-analyzer language server configuration
                    ['rust-analyzer'] = {
                        ['cargo'] = {
                            ['features'] = 'all'
                        }
                    },
                },
            },
        }
    end
}
