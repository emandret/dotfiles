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
    { import = "plugins.colorscheme.cyberdream" },

    -- User interface
    { import = "plugins.ui.bufferline" },
    { import = "plugins.ui.flash" },
    { import = "plugins.ui.git-signs" },
    { import = "plugins.ui.lualine" },
    { import = "plugins.ui.nvim-tree" },
    { import = "plugins.ui.toggleterm-nvim" },
    { import = "plugins.ui.which-key" },

    -- Editor
    { import = "plugins.editor.mini-nvim" },
    { import = "plugins.editor.nvim-surround" },
    { import = "plugins.editor.rainbow-delimiters" },
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
    vim.cmd("colorscheme kanagawa-dragon")
  end,
})

local hijack_netrw = vim.api.nvim_create_augroup("HijackNetrw", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  group = hijack_netrw,
  callback = function()
    -- Early return if current buffer is already hijacked
    if vim.b[0].telescope_hijacked then
      return
    end

    -- Early return if netrw or not a directory
    local path = vim.fn.expand("%:p")
    if vim.bo[0].filetype == "netrw" or vim.fn.isdirectory(path) == 0 then
      return
    end

    -- Mark current buffer as hijacked and wipeout on hide
    vim.b[0].telescope_hijacked = true
    vim.bo[0].bufhidden = "wipe"

    -- Change window-local cwd
    local dir = vim.fn.expand("%:p:h")
    vim.cmd.lcd(dir)

    -- Open Telescope fuzzy finder
    vim.schedule(function()
      require("telescope.builtin").find_files()
    end)
  end,
})
