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
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    -- File explorer
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    -- Fuzzy finder
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" }
    },
    -- Treesitter parser support for syntax highlighting
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate"
    },
    -- LSP client config
    {
      "neovim/nvim-lspconfig"
    },
    -- Colorscheme
    {
      "folke/tokyonight.nvim",
      config = function()
        vim.cmd("colorscheme tokyonight")
      end
    },
  },

  -- Automatically check for plugin updates
  checker = { enabled = true },
})
