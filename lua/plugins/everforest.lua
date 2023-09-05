return {
	"neanias/everforest-nvim",
	version = false,
	lazy = false,
	priority = 1000,
	config = function()
		local everforest = require("everforest")
		everforest.setup({
			diagnostic_line_highlight = true,
			italics = true,
			ui_contrast = "high",
		})
		everforest.load()
	end,
}
