local map = require("helpers").map

map("n", "gvv", ":tabe ~/.config/nvim/init.lua<CR>", { desc = "open neovim config" })
map("n", "gvk", ":tabe ~/.config/nvim/lua/keymaps.lua<CR>", { desc = "open neovim config" })

-- Moving lines
map({ "n", "v" }, "<C-J>", ":move .+1<CR>==", { desc = "move line up" })
map({ "n", "v" }, "<C-K>", ":move .-2<CR>==", { desc = "move line down" })

-- Go to tab by number
map({ "n", "v" }, "<leader>1", "1gt", { desc = "go to tab 1" })
map({ "n", "v" }, "<leader>2", "2gt", { desc = "go to tab 2" })
map({ "n", "v" }, "<leader>3", "3gt", { desc = "go to tab 3" })
map({ "n", "v" }, "<leader>4", "4gt", { desc = "go to tab 4" })
map({ "n", "v" }, "<leader>5", "5gt", { desc = "go to tab 5" })
map({ "n", "v" }, "<leader>6", "6gt", { desc = "go to tab 6" })
map({ "n", "v" }, "<leader>7", "7gt", { desc = "go to tab 7" })
map({ "n", "v" }, "<leader>8", "8gt", { desc = "go to tab 8" })
map({ "n", "v" }, "<leader>9", "9gt", { desc = "go to tab 9" })
map({ "n", "v" }, "<leader>0", ":tablast<CR>")

-- Cut movements
map({ "n", "x" }, "m", "d", { desc = "normal, visual: cut motion" })
map("n", "mm", "dd", { desc = "normal: cut line" })
map("n", "M", "D", { desc = "normal: cut trailing" })

-- Telescope fuzzy finder
local builtin = require('telescope.builtin')
map('n', '<leader>f', builtin.find_files, {})
map('n', '<leader>g', builtin.live_grep, {})

-- Diagnostics
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)

-- LSP stuff
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        map('n', 'gD', vim.lsp.buf.declaration, opts)
        map('n', 'gd', vim.lsp.buf.definition, opts)
        map('n', 'K', vim.lsp.buf.hover, opts)
        map('n', 'gi', vim.lsp.buf.implementation, opts)
        map('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        map('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        map('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        map('n', '<space>D', vim.lsp.buf.type_definition, opts)
        map('n', '<space>rn', vim.lsp.buf.rename, opts)
        map({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        map('n', 'gr', vim.lsp.buf.references, opts)
    end,
})


-- Latex
map("n", "<leader>lf", ":lua FormatLatex()<CR>", { desc = "format file using latexindent" })
map({ "n", "x" }, "<leader>ll", ":VimtexCompile<cr>", { desc = "compile LaTeX document" })

-- Luasnip
map("n", "gs", ":lua require(\"luasnip.loaders\").edit_snippet_files()<cr>")

-- Rust

-- Nvim DAP
map("n", "<Leader>di", "<cmd>lua require'dap'.repl.open()<CR>", { desc = "Open REPL" })
map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
    "n",
    "<Leader>dd",
    "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    { desc = "Debugger set conditional breakpoint" }
)
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })

-- Rustacean
map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })
