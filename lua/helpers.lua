-- We return the map function -- and potentially more functions in
-- the future -- from this module, which is why we need this M table.
-- We return it later with the map function attatched to it

local M = {}

function M.map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	vim.keymap.set(mode, lhs, rhs, opts)
end

return M
