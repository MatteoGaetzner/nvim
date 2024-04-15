return {
    'hrsh7th/nvim-cmp',

    -- Load cmp on InsertEnter
    event = 'InsertEnter',

    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'saadparwaiz1/cmp_luasnip',
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets'
    },

    config = function()
        local luasnip = require('luasnip')
        local cmp = require('cmp')

        local select_opts = { behavior = cmp.SelectBehavior.Select }

        ---@diagnostic disable-next-line
        cmp.setup({
            preselect = cmp.PreselectMode.Item,
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            sources = {
                { name = 'path' },
                { name = 'luasnip',  keyword_length = 1 },
                { name = 'nvim_lsp', keyword_length = 1 },
                { name = 'buffer',   keyword_length = 1 },
            },
            ---@diagnostic disable-next-line
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
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
                ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
                ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<C-c>'] = cmp.mapping.abort(),
                ['<C-y>'] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true
                }),
                ['<CR>'] = cmp.mapping(function(fallback)
                    fallback()
                end, { 'i', 's' }),
                ['<C-j>'] = cmp.mapping(function(fallback)
                    if luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                ['C-k>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
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
    end

}
