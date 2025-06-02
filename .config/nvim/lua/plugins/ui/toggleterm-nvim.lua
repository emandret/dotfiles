return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        direction = "vertical",
        size = 120,
        insert_mappings = true,
        terminal_mappings = true,
        start_in_insert = true,
        persist_size = true,
      })
    end,
  },
}
