local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- disable netrw (should be at the very start of init.lua)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Don't highlight search results
vim.opt.hlsearch = false

-- keep cursor in the vertical center
vim.opt.scrolloff = 5

-- Keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = ';'

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Set tabstop, shiftwidth and use spaces instead of tabs
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.softtabstop = 4
vim.o.tabstop = 4

-- NOTE: Set this path to the path to your python3 executable!
-- Function to check if a file exists
local function file_exists(path)
    local f = io.open(path, "r")
    if f then
        io.close(f)
        return true
    else
        return false
    end
end

-- Check if the custom Python 3 binary exists
local function error_msg_if_not_exist(fp, default, msg)
    local out = default
    if file_exists(fp) then
        out = fp
    else
        vim.api.nvim_out_write(msg)
    end
    return out
end

LOCAL = require("local")

vim.g.python3_host_prog = error_msg_if_not_exist(LOCAL.python3_host_prog, "python3",
    "Warning: Custom Python 3 binary not found. Falling back to system Python 3.\n")
-- NOTE: Set this path to the path to your perl executable!
vim.g.perl_host_prog = error_msg_if_not_exist(LOCAL.perl_host_prog, "perl", "")

-- Textwidth (following PEP 8)
vim.opt.textwidth = 79
vim.o.formatoptions = vim.o.formatoptions:gsub('[tcrl]', '')

-- Set backup directory to ~/.cache/nvim/backup
local backupdir = vim.fn.expand("~/.cache/nvim/backup")
vim.fn.mkdir(backupdir, "p") -- Create the directory if it doesn't exist

-- Configure Neovim to use the specified backup directory
vim.opt.backupdir = { backupdir }
vim.opt.directory = { backupdir }

-- Load plugins
require("lazy").setup("plugins")

-- Line numbers
vim.o.number = true
local augroup = vim.api.nvim_create_augroup("numbertoggle", {})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
    pattern = "*",
    group = augroup,
    callback = function()
        if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
            vim.opt.relativenumber = true
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
    pattern = "*",
    group = augroup,
    callback = function()
        if vim.o.nu then
            vim.opt.relativenumber = false
            vim.cmd "redraw"
        end
    end,
})

-- Comment.nvim
require('Comment').setup()

-- Mason and lspconfig (Mason must come first!)
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "efm", "gopls", "texlab" },
}

-- EFM

--- Register linters and formatters per language
local black = require('efmls-configs.formatters.black')
local isort = require('efmls-configs.formatters.isort')
local shfmt = require('efmls-configs.formatters.shfmt')
local shellcheck = require('efmls-configs.linters.shellcheck')
local beautysh = require('efmls-configs.formatters.beautysh')
local yamllint = require('efmls-configs.linters.yamllint')
local latexindent = require('efmls-configs.formatters.latexindent')
-- local clang_format = require('efmls-configs.formatters.clang_format')

--- Markdown
local alex = require('efmls-configs.linters.alex')
local prettier = require('efmls-configs.formatters.prettier')

local languages = {
    python = { black, isort },
    sh = { shfmt, shellcheck },
    bash = { shfmt, shellcheck },
    zsh = { beautysh },
    yaml = { yamllint },
    markdown = { alex, prettier },
    tex = { latexindent },
    -- cpp = { clang_format }
}

local efmls_config = {
    filetypes = vim.tbl_keys(languages),
    settings = {
        rootMarkers = { '.git/' },
        languages = languages,
    },
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
    },
}

local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

lspconfig.texlab.setup({})
lspconfig.gopls.setup({})
lspconfig.efm.setup(vim.tbl_extend('force', efmls_config, {}))
lspconfig.pyright.setup({
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
            },
        },
    }
})
lspconfig.marksman.setup {}
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            workspace = {
                checkThirdParty = false,
            },
        },
    },
}
lspconfig.clangd.setup {}


-- Format on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Keymaps
require("keymaps")

-- Define a function to load the language-specific configuration
function load_language_specific_config(filetype)
    local filepath = 'language-specifics.' .. filetype
    pcall(require, filepath) -- try require(...) catch noop
end

-- Set up an autocmd for FileType event
vim.api.nvim_exec2([[
  augroup LoadLanguageSpecificConfig
    autocmd!
    autocmd FileType * lua load_language_specific_config(vim.bo.filetype)
  augroup END
]], {})
