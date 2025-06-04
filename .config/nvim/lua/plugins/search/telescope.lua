return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
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
      {
        "ahmedkhalf/project.nvim",
        config = function()
          require("project_nvim").setup({
            detection_methods = { "pattern" },
            patterns = { ".git" },
          })
          require("telescope").load_extension("projects")
        end,
      },
    },
    keys = {
      { "<Leader>b", "<Cmd>Telescope buffers<CR>", desc = "Find Buffers" },
      { "<Leader>h", "<Cmd>Telescope help_tags<CR>", desc = "Help Tags" },
      {
        "<Leader>p",
        function()
          vim.schedule(function()
            require("telescope").extensions.projects.projects()
          end)
        end,
        desc = "Find Projects",
      },
      {
        "<Leader>ff",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.getcwd() })
        end,
        desc = "Find Files (Project Root)",
      },
      {
        "<Leader>f.",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "Find Files (File Directory)",
      },
      {
        "<Leader>fg",
        function()
          require("telescope.builtin").live_grep({ cwd = vim.fn.getcwd() })
        end,
        desc = "Live Grep (Project Root)",
      },
      {
        "<Leader>g.",
        function()
          require("telescope.builtin").live_grep({ cwd = vim.fn.expand("%:p:h") })
        end,
        desc = "Live Grep (File Directory)",
      },
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
      }
    end,
  },
}
