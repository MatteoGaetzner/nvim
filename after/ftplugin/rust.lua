local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
    "n",
    "<leader>a",
    function()
        -- Code actions
        vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    end,
    { silent = true, buffer = bufnr }
)

-- Activate format on save. Needed, even given
-- the general format-on-save setup.
vim.g.rustfmt_autosave = 1
