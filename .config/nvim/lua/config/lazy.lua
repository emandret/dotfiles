-- $HOME/.local/share/nvim/lazy/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Core
    { import = "plugins.core.lazydev" },
    { import = "plugins.core.plenary" },
    { import = "plugins.core.persistence" },

    -- User interface
    { import = "plugins.ui.nvim-tree" },
    { import = "plugins.ui.bufferline" },
    { import = "plugins.ui.flash" },
    { import = "plugins.ui.lualine" },
    { import = "plugins.ui.tokyonight" },
    { import = "plugins.ui.which-key" },

    -- Syntax highlighting
    { import = "plugins.syntax.mini-nvim" },
    { import = "plugins.syntax.nvim-treesitter" },
    { import = "plugins.syntax.nvim-treesitter-textobjects" },

    -- Search and fuzzy finder
    { import = "plugins.search.grug-far" },
    { import = "plugins.search.telescope" },

    -- LSP servers and client config
    { import = "plugins.lsp.mason-nvim" },
    { import = "plugins.lsp.nvim-lspconfig" },

    -- Linting
    { import = "plugins.linting.nvim-lint" },

    -- Formatting
    { import = "plugins.formatting.conform" },

    -- Diagnostics
    { import = "plugins.diagnostics.trouble" },

    -- Git integration
    { import = "plugins.git.git-signs" },

    -- Completion
    { import = "plugins.completion.luasnip" },
    { import = "plugins.completion.nvim-cmp" },
  },

  checker = { -- Automatically check for plugin updates
    enabled = true, -- Check for plugin updates periodically
    notify = false, -- Notify on update
  },

  performance = {
    rtp = {
      disabled_plugins = { -- Disable some RTP plugins
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
