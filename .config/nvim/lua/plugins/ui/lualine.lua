return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin",
        globalstatus = true,
        disabled_filetypes = {
          winbar = {},
        },
      },
      sections = {
        lualine_c = {
          {
            function()
              return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
            end,
          },
          { "filename", path = 1 },
        },
      },
    },
  },
}
