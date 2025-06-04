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
    { import = "plugins.core.mason-nvim" },
    { import = "plugins.core.persistence" },
    { import = "plugins.core.plenary" },

    -- Treesitter parser support
    { import = "plugins.treesitter.nvim-treesitter" },
    { import = "plugins.treesitter.nvim-treesitter-context" },
    { import = "plugins.treesitter.nvim-treesitter-textobjects" },

    -- Colorscheme
    { import = "plugins.colorscheme.catppuccin" },
    { import = "plugins.colorscheme.kanagawa" },
    { import = "plugins.colorscheme.tokyonight" },

    -- User interface
    { import = "plugins.ui.bufferline" },
    { import = "plugins.ui.flash" },
    { import = "plugins.ui.git-signs" },
    { import = "plugins.ui.lualine" },
    { import = "plugins.ui.toggleterm-nvim" },
    { import = "plugins.ui.which-key" },

    -- Editor
    { import = "plugins.editor.mini-nvim" },
    { import = "plugins.editor.nvim-surround" },
    { import = "plugins.editor.ts-comments" },
    { import = "plugins.editor.vim-matchup" },

    -- Search and fuzzy finder
    { import = "plugins.search.grug-far" },
    { import = "plugins.search.telescope" },

    -- LSP server and client config
    { import = "plugins.lsp.nvim-lspconfig" },

    -- Autocompletion
    { import = "plugins.completion.luasnip" },
    { import = "plugins.completion.nvim-cmp" },

    -- Linting
    { import = "plugins.linting.nvim-lint" },

    -- Formatting
    { import = "plugins.formatting.conform" },

    -- Diagnostics
    { import = "plugins.diagnostics.trouble" },
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

-- Set the colorscheme after Lazy has loaded all plugins
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    vim.cmd("colorscheme catppuccin")
  end,
})

-- Open the first directory argument
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local args = vim.fn.argv()

    local dirs = {}
    for _, arg in ipairs(args) do
      if vim.fn.isdirectory(arg) == 1 then
        table.insert(dirs, arg)
      end
    end

    -- Exit if no directory is found
    if #dirs == 0 then
      return
    end

    -- Wipeout buffers associated with directories
    for _, dir in ipairs(dirs) do
      local bufnr = vim.fn.bufnr(dir)
      if bufnr ~= -1 then
        vim.cmd.bw(bufnr)
      end
    end

    -- Change the cwd
    vim.cmd.cd(dirs[1])

    -- Open telescope-file-browser
    require("telescope").extensions.file_browser.file_browser()
  end,
})
