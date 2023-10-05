local M = {}

-- Function to check if a file exists
local function file_exists(filepath)
	local stat = vim.loop.fs_stat(filepath)
	return stat and stat.type or false
end

-- List of Python3 binary paths to check
local python3_paths = {
	vim.fn.expand("~/.conda/envs/neovim-python3/bin/python3"),
	vim.fn.expand("~/.mambaforge/envs/neovim/bin/python3"),
	vim.fn.expand("~/.local/share/micromamba/envs/neovim-python3/bin/python3")
}

-- Check each Python3 path and set it if it exists
local python3_set = false
for _, path in pairs(python3_paths) do
	if file_exists(path) then
		M.python3_host_prog = path
		python3_set = true
		break
	end
end

-- If no valid Python3 binary is found, show an error message
if not python3_set then
	print("Error: No valid Python3 binary found.")
end

-- For Perl; can be similarly extended as Python if needed
M.perl_host_prog = "/usr/bin/perl"

return M
