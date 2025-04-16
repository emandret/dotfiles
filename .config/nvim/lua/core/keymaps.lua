-- -----------------------------------------------------------------------------
-- KEYMAPS
-- -----------------------------------------------------------------------------

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Map jj to ESC in insert mode
map("i", "jj", "<ESC>", opts)

-- Clear search pattern with Ctrl-/
map("n", "<C-_>", ":let @/=''<CR>", opts)

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
