return {
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<Leader>e", "<Cmd>NvimTreeToggle<CR>", desc = "Toggle File Explorer" },
    },
    opts = {
      disable_netrw = true,
      hijack_netrw = true,
      respect_buf_cwd = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      sort = {
        sorter = "case_sensitive",
      },
      renderer = {
        group_empty = true,
      },
      view = {
        relativenumber = true,
        float = {
          enable = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = screen_w * 0.8
            local window_h = screen_h * 0.8
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
            return {
              border = "rounded",
              relative = "editor",
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * 0.8)
        end,
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
  },
}
