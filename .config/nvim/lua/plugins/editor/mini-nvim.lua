return {
  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      require("mini.ai").setup()
      require("mini.pairs").setup()
    end,
  },
}
