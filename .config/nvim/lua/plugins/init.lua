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

-- Import plugins
require("lazy").setup({
  spec = {
    { import = "plugins.cmp" },
    { import = "plugins.colorscheme" },
    { import = "plugins.conform" },
    { import = "plugins.gitsigns" },
    { import = "plugins.lsp" },
    { import = "plugins.lualine" },
    { import = "plugins.nvimtree" },
    { import = "plugins.telescope" },
    { import = "plugins.toggleterm" },
    { import = "plugins.treesitter" },
  },
  checker = { enabled = true },
})
