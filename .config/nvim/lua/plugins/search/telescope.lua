return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-project.nvim",
        config = function()
          require("telescope").load_extension("project")
        end,
      },
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
      { "<Leader>fe", "<Cmd>Telescope file_browser<CR>", desc = "Telescope file browser" },
      { "<Leader>ff", "<Cmd>Telescope find_files<CR>", desc = "Telescope find files" },
      { "<Leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Telescope live grep" },
      { "<Leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Telescope help tags" },
      { "<Leader>fp", "<Cmd>Telescope project<CR>", desc = "Telescope project" },
    },
    opts = function()
      local actions = require("telescope.actions")
      local project_actions = require("telescope._extensions.project.actions")

      return {
        defaults = {
          mappings = {
            n = {
              ["q"] = actions.close,
              ["d"] = project_actions.delete_project,
              ["r"] = project_actions.rename_project,
              ["c"] = project_actions.add_project,
              ["C"] = project_actions.add_project_cwd,
              ["f"] = project_actions.find_project_files,
              ["b"] = project_actions.browse_project_files,
              ["s"] = project_actions.search_in_project_files,
              ["R"] = project_actions.recent_project_files,
              ["w"] = project_actions.change_working_directory,
              ["o"] = project_actions.next_cd_scope,
            },
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<c-d>"] = project_actions.delete_project,
              ["<c-v>"] = project_actions.rename_project,
              ["<c-a>"] = project_actions.add_project,
              ["<c-A>"] = project_actions.add_project_cwd,
              ["<c-f>"] = project_actions.find_project_files,
              ["<c-b>"] = project_actions.browse_project_files,
              ["<c-s>"] = project_actions.search_in_project_files,
              ["<c-r>"] = project_actions.recent_project_files,
              ["<c-l>"] = project_actions.change_working_directory,
              ["<c-o>"] = project_actions.next_cd_scope,
            },
          },
        },
        extensions = {
          project = {
            base_dirs = {
              { path = "~", max_depth = 1 },
              { path = "~/git", max_depth = 2 },
            },
            order_by = "recent",
            search_by = "title",
            theme = "dropdown",
            hidden_files = true,
            ignore_missing_dirs = true,
            sync_with_nvim_tree = true,
          },
        },
      }
    end,
  },
}
