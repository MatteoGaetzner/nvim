return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function()
        require('luasnip.loaders.from_vscode').lazy_load()
        require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/luasnip-snippets/" })
        require("luasnip.loaders.from_snipmate").lazy_load()

        local luasnip = require("luasnip")

        luasnip.config.set_config({
            history = true,                             -- Keep last snippet in memory, to be able to jump back into it, once outside the snippet completion process
            updateevents = "TextChanged, TextChangedI", -- Make snippets update while typing
            enable_autosnippets = true,
        })
    end
}
