local M = {}

-- Path to your python3 binary that has access to pynvim and other
-- libraries that your Neovim config depends on
-- M.python3_host_prog = vim.fn.expand("~/.conda/envs/neovim-python3/bin/python3")
-- M.python3_host_prog = vim.fn.expand("~/.mambaforge/envs/neovim/bin/python3")
M.python3_host_prog = vim.fn.expand("~/.local/share/micromamba/envs/neovim-python3/bin/python3")

-- same for perl
M.perl_host_prog = "/usr/bin/perl"

return M
