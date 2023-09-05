return {
	'ojroques/nvim-osc52',
	config = function()
		local function copy(lines, _)
			require('osc52').copy(table.concat(lines, '\n'))
		end

		local function paste()
			return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
		end

		vim.g.clipboard = {
			name = 'osc52',
			copy = { ['+'] = copy, ['*'] = copy },
			paste = { ['+'] = paste, ['*'] = paste },
		}

		require("osc52").setup {
			silent = false, -- Disable message on successful copy
			trim   = true, -- Trim surrounding whitespaces before copy
		}
	end
}
