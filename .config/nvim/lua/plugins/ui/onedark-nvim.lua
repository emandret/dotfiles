return {
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- Load before all the other plugins start
    config = function()
      require("onedark").setup({ style = "darker" })
      require("onedark").load()
    end,
  },
}
