return {
  {
    -- Add vim-matchup to highlight matching `()`, `[]`, and `{}` in Treesitter buffers.
    "andymass/vim-matchup",
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
}
