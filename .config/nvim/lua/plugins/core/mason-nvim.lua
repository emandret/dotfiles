return {
  {
    -- Mason is a Neovim package manager to install:
    -- LSP servers (used by nvim-lspconfig and mason-lspconfig)
    -- linters (used by nvim-lint)
    -- formatters (used by conform.nvim)
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<Leader>cm", "<Cmd>Mason<CR>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      PATH = "append", -- Make sure the system PATH takes precedence over Mason's bin path
      ensure_installed = {
        "ansible-language-server",
        "ansible-lint",
        "asm-lsp",
        "asmfmt",
        "ast-grep",
        "autopep8",
        "awk-language-server",
        "bash-language-server",
        "bibtex-tidy",
        "black",
        "clang-format",
        "clangd",
        "cmake-language-server",
        "cmakelang",
        "cmakelint",
        "crlfmt",
        "css-lsp",
        "docker-compose-language-service",
        "dockerfile-language-server",
        "dotenv-linter",
        "eslint-lsp",
        "flake8",
        "gitleaks",
        "goimports",
        "golangci-lint",
        "golines",
        "gomodifytags",
        "google-java-format",
        "gopls",
        "gotests",
        "groovy-language-server",
        "hadolint",
        "helm-ls",
        "html-lsp",
        "isort",
        "java-language-server",
        "jdtls",
        "jinja-lsp",
        "jq",
        "json-lsp",
        "jsonlint",
        "jsonnet-language-server",
        "jsonnetfmt",
        "jupytext",
        "kube-linter",
        "lua-language-server",
        "markdownlint",
        "nginx-language-server",
        "npm-groovy-lint",
        "opa",
        "php-cs-fixer",
        "prettier",
        "pylint",
        "pyright",
        "regal",
        "rubyfmt",
        "rust-analyzer",
        "semgrep",
        "shellcheck",
        "shfmt",
        "sqlfluff",
        "sqls",
        "stylua",
        "systemd-language-server",
        "systemdlint",
        "terraform-ls",
        "terraform",
        "tex-fmt",
        "texlab",
        "tflint",
        "trivy",
        "typescript-language-server",
        "vim-language-server",
        "yaml-language-server",
        "yamlfix",
        "yamlfmt",
        "yamllint",
        "yapf",
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
