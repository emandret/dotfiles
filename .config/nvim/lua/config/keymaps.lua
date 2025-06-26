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

-- Clear search pattern with Leader-/
map("n", "<Leader>/", ":let @/=''<CR>", opts)

-- Remap j/k to their visual line counterparts and vice-versa
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)
map("n", "gj", "j", opts)
map("n", "gk", "k", opts)

-- Disable arrow keys in normal mode
map("n", "<Left>", "<NOP>", opts)
map("n", "<Down>", "<NOP>", opts)
map("n", "<Up>", "<NOP>", opts)
map("n", "<Right>", "<NOP>", opts)

-- Disable arrow keys in visual mode
map("v", "<Left>", "<NOP>", opts)
map("v", "<Down>", "<NOP>", opts)
map("v", "<Up>", "<NOP>", opts)
map("v", "<Right>", "<NOP>", opts)

-- Use the up and down arrow keys to navigate the wildmenu in command-line mode
map("c", "<Up>", [[pumvisible() ? "\<C-p>" : "\<Up>"]], { expr = true })
map("c", "<Down>", [[pumvisible() ? "\<C-n>" : "\<Down>"]], { expr = true })

-- Use the left arrow key to cancel a suggestion
map("c", "<Left>", [[pumvisible() ? "\<C-e>" : "\<Left>"]], { expr = true })

-- Use the right arrow key to accept a suggestion
map("c", "<Right>", [[pumvisible() ? "\<C-y>" : "\<Right>"]], { expr = true })

-- Enable shell-like keybindings in command-line mode
map("c", "<C-a>", "<Home>", opts)
map("c", "<C-e>", "<End>", opts)
map("c", "<C-h>", "<BS>", opts)
map("c", "<C-u>", "<C-u>", opts)
map("c", "<C-w>", "<C-w>", opts)

-- LSP keymaps
map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
map("n", "gO", "<Cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
map("n", "gra", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
map("n", "grd", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
map("n", "gri", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
map("n", "grn", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
map("n", "grr", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
map("n", "grt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
map("n", "gq", "<Cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
map("i", "<C-s>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
