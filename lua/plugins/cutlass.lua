return {
    'gbprod/cutlass.nvim',
    config = function()
        require("cutlass").setup({
            cut_key = nil,
            override_del = nil,
            exclude = {},
            registers = {
                select = "_",
                delete = "_",
                change = "_",
            },
        })

        -- local map = require("helpers").map
        -- map({ "n", "v" }, "m", "d")
        -- map({ "n", "v" }, "mm", "dd")
    end
}
