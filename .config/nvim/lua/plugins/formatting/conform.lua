return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<Leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    opts = function()
      local plugin = require("lazy.core.config").plugins["conform.nvim"]
      ---@type conform.setupOpts
      local opts = {
        default_format_opts = {
          timeout_ms = 3000,
          async = false, -- Not recommended to change
          quiet = false, -- Not recommended to change
          lsp_format = "fallback", -- Not recommended to change
        },
        formatters_by_ft = {
          asm = { "asmfmt" },
          bash = { "shfmt" },
          bib = { "bibtex-tidy" },
          c = { "clang-format" },
          cmake = { "cmake_format" },
          cpp = { "clang-format" },
          cs = { "csharpier" },
          css = { "prettier" },
          dockerfile = { "prettier" },
          go = { "goimports", "golines" },
          html = { "prettier" },
          java = { "google-java-format" },
          javascript = { "prettier" },
          jsonnet = { "jsonnetfmt" },
          json = { "prettier" },
          latex = { "tex-fmt" },
          lua = { "stylua" },
          markdown = { "prettier" },
          php = { "php-cs-fixer" },
          python = { "isort", "black" },
          ruby = { "rubyfmt" },
          rust = { "rustfmt" },
          sh = { "shfmt" },
          sql = { "sqlfluff" },
          tex = { "latexindent" },
          typescript = { "prettier" },
          yaml = { "yamlfmt", "yamlfix" },
        },
        -- The options you set here will be merged with the builtin formatters.
        -- You can also define any custom formatters here.
        ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
        formatters = {
          injected = { options = { ignore_errors = true } },
          -- # Example of using dprint only when a dprint.json file is present
          -- dprint = {
          --   condition = function(ctx)
          --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
          --   end,
          -- },
          --
          -- # Example of using shfmt with extra args
          -- shfmt = {
          --   prepend_args = { "-i", "2", "-ci" },
          -- },
        },
      }
      return opts
    end,
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
}
