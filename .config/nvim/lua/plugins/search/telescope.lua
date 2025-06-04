return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-file-browser.nvim",
        config = function()
          require("telescope").load_extension("file_browser")
        end,
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
        config = function()
          local ok, _ = pcall(require("telescope").load_extension, "fzf")
          if not ok then
            vim.notify("telescope-fzf-native.nvim: Failed to load", vim.log.levels.ERROR)
          end
        end,
      },
    },
    keys = {
      { "<Leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Telescope buffers" },
      { "<Leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Telescope find files" },
      { "<Leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Telescope live grep" },
      { "<Leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Telescope help tags" },
      { "<Leader>fe", "<Cmd>Telescope file_browser<CR>", desc = "Telescope file browser" },
    },
    opts = function()
      local actions = require("telescope.actions")

      return {
        defaults = {
          mappings = {
            n = {
              ["q"] = actions.close,
            },
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
          },
        },
        extensions = {
          file_browser = {
            cwd = vim.fn.getcwd(),
            cwd_to_path = true,
            hijack_netrw = true,
          },
        },
      }
    end,
  },
}
