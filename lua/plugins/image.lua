return {
    "3rd/image.nvim",
    config = function()
        require("image").setup({
            rocks = {
                hererocks = true, -- recommended if you do not have global installation of Lua 5.1.
            }
        })
    end
}
