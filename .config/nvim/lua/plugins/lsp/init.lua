local servers = require("plugins.lsp.servers")

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("plugins.lsp.client").setup(servers)
  end
}
