return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          local ok, _ = pcall(require("telescope").load_extension, "fzf")
          if not ok then
            vim.notify("telescope-fzf-native.nvim: Failed to load", vim.log.levels.ERROR)
          end
        end,
      },
    },
    keys = {
      { "<Leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Telescope find files" },
      { "<Leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Telescope live grep" },
      { "<Leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Telescope buffers" },
      { "<Leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Telescope help tags" },
    },
    opts = function()
      local actions = require("telescope.actions")

      return {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
    end,
  },
}
