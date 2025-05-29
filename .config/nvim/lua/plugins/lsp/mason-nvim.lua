return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<Leader>cm", "<Cmd>Mason<CR>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        -- LSP servers (nvim-lspconfig and mason-lspconfig)
        "ansible-language-server",
        "bash-language-server",
        "clangd",
        "dockerfile-language-server",
        "gopls",
        "jdtls",
        "json-lsp",
        "ltex-ls",
        "lua-language-server",
        "pyright",
        "typescript-language-server",
        "yaml-language-server",

        -- Linters (nvim-lint)
        "ansible-lint",
        "eslint_d",
        "flake8",
        "hadolint",
        "jsonlint",
        "shellcheck",
        "yamllint",

        -- Formatters (conform.nvim)
        "black",
        "clang-format",
        "crlfmt",
        "google-java-format",
        "latexindent",
        "prettier",
        "shfmt",
        "stylua",
        -- Note: you can find additional packages to install at:
        -- https://mason-registry.dev/registry/list
        -- Use the search bar to search for specific keywords.
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- Trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
}
