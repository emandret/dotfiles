return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      hijack_directories = { enable = false },
      view = {
        width = 40,
        side = "left",
        signcolumn = "no",
        cursorline = true,
        number = false,
        relativenumber = false,
        preserve_window_proportions = true,
      },
      update_focused_file = {
        enable = true,
        update_cwd = false,
      },
      filters = { dotfiles = true },
      renderer = {
        group_empty = true,
        indent_markers = {
          enable = true,
          inline_arrows = false,
          icons = {
            corner = "\u{2514}",
            edge = "\u{2502}",
            item = "\u{2502}",
            bottom = "\u{2500}",
            none = " ",
          },
        },
        icons = {
          show = {
            folder = false,
            folder_arrow = true,
            file = true,
            git = true,
          },
        },
      },
      sort = { sorter = "case_sensitive" },
    },
    keys = {
      { "<Leader>tt", "<Cmd>NvimTreeToggle<CR>", desc = "Toggle File Tree (nvim-tree)" },
      { "<Leader>tc", "<Cmd>NvimTreeFindFile<CR>", desc = "Find Current File in Tree (nvim-tree)" },
      { "<Leader>tr", "<Cmd>NvimTreeRefresh<CR>", desc = "Refresh File Tree" },
    },
  },
}
