local M = {}

-- Path to your python3 binary that has access to pynvim and other
-- libraries that your Neovim config depends on
M.python3_host_prog = vim.fn.expand("/path/to/your/python3")

-- same for perl
M.perl_host_prog = "/usr/bin/perl"

return M
