local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

local M = {}

M.setup = function(servers)
  -- Bootstrap LSP server manager
  mason.setup()

  -- Ensure servers are installed
  mason_lspconfig.setup({
    ensure_installed = vim.tbl_keys(servers),
  })

  -- Setup client attach behavior for a filetype
  mason_lspconfig.setup_handlers({
    function(server_name)
      local opts = servers[server_name] or {}

      -- Instruct nvim-lspconfig to spawn a new generic client
      lspconfig[server_name].setup(opts)
    end,
  })
end

return M
