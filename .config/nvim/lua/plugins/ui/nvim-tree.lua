return {
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- Call the default keybindings
        api.config.mappings.default_on_attach(bufnr)

        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = "nvim-tree: " .. desc, noremap = true, silent = true })
        end

        -- Custom keybindings
        map("s", api.node.open.horizontal, "Open: Horizontal Split")
        map("v", api.node.open.vertical, "Open: Vertical Split")
      end,
    },
    keys = {
      { "<Leader>e", "<Cmd>NvimTreeToggle<CR>", desc = "Toggle File Explorer" },
    },
  },
}
