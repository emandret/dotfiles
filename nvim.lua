-- -----------------------------------------------------------------------------
-- GENERAL SETTINGS
-- -----------------------------------------------------------------------------

-- Enable truecolors and dark background
vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Set encoding to UTF-8
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- Enable mouse in all modes
vim.opt.mouse = "a"

-- Allow backspace to remove indentation, line breaks, start of insert
vim.opt.backspace = "indent,eol,start"

-- Yank and paste from the system clipboard
vim.opt.clipboard = "unnamed,unnamedplus"

-- Hide unsaved buffers
vim.opt.hidden = true

-- Reload modified files
vim.opt.autoread = true

-- Enable swapfiles
vim.opt.swapfile = true
vim.opt.directory = vim.fn.expand("~/.swapfiles")

-- Timeout in ms for which a key can be considered for a mapped sequence
vim.opt.timeoutlen = 200

-- Show the status line
vim.opt.laststatus = 2

-- Show the mode and incomplete commands in the bottom right corner
vim.opt.showmode = true
vim.opt.showcmd = true

-- Show the current absolute line number and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Show the cursor position in the status line
vim.opt.ruler = true

-- Enable folds
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 10

-- Ignore case in search patterns except if it contains uppercase letters
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Highlight search matches incrementally as the pattern is being typed
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Highlight matching pairs of brackets, curly braces, parentheses
vim.opt.showmatch = true

-- -----------------------------------------------------------------------------
-- INDENTATION SETTINGS
-- -----------------------------------------------------------------------------

-- Set the width of tab characters in columns
vim.opt.tabstop = 2

-- How many whitespaces shall be inserted for each indent level
vim.opt.shiftwidth = 2

-- Indent new lines and enable syntax-based indentation
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Convert tabs into spaces and use the shiftwidth value for soft tabs
vim.opt.expandtab = true
vim.opt.softtabstop = -1

-- -----------------------------------------------------------------------------
-- KEYMAPS
-- -----------------------------------------------------------------------------

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

map("i", "jj", "<ESC>", opts)

-- Clear search pattern with Ctrl-/
map("n", "<c-_>", ":let @/=''<CR>", opts)

-- Remap j/k to their visual line counterparts and vice-versa
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)
map("n", "gj", "j", opts)
map("n", "gk", "k", opts)

-- Disable arrow keys in normal mode
map("n", "<LEFT>", "<NOP>", opts)
map("n", "<DOWN>", "<NOP>", opts)
map("n", "<UP>", "<NOP>", opts)
map("n", "<RIGHT>", "<NOP>", opts)

-- Disable arrow keys in visual mode
map("v", "<LEFT>", "<NOP>", opts)
map("v", "<DOWN>", "<NOP>", opts)
map("v", "<UP>", "<NOP>", opts)
map("v", "<RIGHT>", "<NOP>", opts)

-- -----------------------------------------------------------------------------
-- AUTOCMDS
-- -----------------------------------------------------------------------------

local autocmd = vim.api.nvim_create_autocmd

-- Restore cursor position
autocmd("BufReadPost", {
  callback = function()
    local line = vim.fn.line
    if line([['"]]) > 1 and line([['"]]) <= line("$") then
      vim.cmd('normal! g`"')
    end
  end
})


-- Trim trailing whitespaces on save
autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]]
})

-- -----------------------------------------------------------------------------
-- FILETYPES
-- -----------------------------------------------------------------------------

vim.filetype.add({
  filename = {
    ["Makefile"]    = "make",
    ["Dockerfile"]  = "dockerfile",
    ["Jenkinsfile"] = "groovy",
  },
  pattern = {
    [".*%.makefile"] = "make",
    [".*%.mk"]       = "make",
    [".*%.h"]        = "cpp",
    [".*%.hpp"]      = "cpp",
    [".*%.c"]        = "cpp",
    [".*%.cc"]       = "cpp",
    [".*%.cpp"]      = "cpp",
    [".*%.tf"]       = "terraform",
    [".*%.tfvars"]   = "terraform",
    [".*%.ya?ml"]    = "yaml",
    [".*%.groovy"]   = "groovy",
  }
})

-- -----------------------------------------------------------------------------
-- FORMATTERS
-- -----------------------------------------------------------------------------

local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.bo.tabstop = 8
    vim.bo.shiftwidth = 8
    vim.bo.softtabstop = 0
    vim.bo.expandtab = false
  end,
})

autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.bo.equalprg = "prettier --parser markdown"
  end,
})

autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.bo.equalprg = "clang-format -style=Microsoft"
  end,
})

autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.bo.equalprg = "black --quiet -"
  end,
})

autocmd("FileType", {
  pattern = "terraform",
  callback = function()
    vim.bo.equalprg = "terraform fmt -"
  end,
})

autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    vim.bo.equalprg = "yamlfmt"
  end,
})

-- -----------------------------------------------------------------------------
-- PLUGINS
-- -----------------------------------------------------------------------------

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end

vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim and load plugins
require("lazy").setup({
  spec = {
    -- Status line
    { "nvim-lualine/lualine.nvim" },
    -- File explorer
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
    -- Fuzzy finder
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    -- Treesitter parser support for syntax highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    -- LSP client config
    { "neovim/nvim-lspconfig" },
    -- Colorscheme
    { "folke/tokyonight.nvim" },
  },

  -- Automatically check for plugin updates
  checker = { enabled = true },
})
