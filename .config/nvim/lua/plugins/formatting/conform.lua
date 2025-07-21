return {
  {
    "stevearc/conform.nvim",
    lazy = false,
    dependencies = { "mason.nvim" },
    cmd = "ConformInfo",
    keys = {
      {
        "<Leader>cf",
        function()
          local conform = require("conform")
          local mode = vim.api.nvim_get_mode().mode

          if mode:match("^[vV]") then
            conform.format({
              range = {
                ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
                ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
              },
              async = true,
              lsp_fallback = true,
            })
          else
            conform.format({ async = true, lsp_fallback = true })
          end
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    opts = function()
      ---@type conform.setupOpts
      local opts = {
        format_on_save = {
          timeout_ms = 3000,
        },
        default_format_opts = {
          lsp_format = "fallback", -- Not recommended to change
          async = false, -- Not recommended to change
          quiet = false, -- Not recommended to change
        },
        formatters_by_ft = {
          asm = { "asmfmt" },
          bash = { "shfmt" },
          bib = { "bibtex-tidy" },
          c = { "clang-format" },
          cmake = { "cmake_format" },
          cpp = { "clang-format" },
          css = { "prettier" },
          dockerfile = { "prettier" },
          go = { "goimports", "golines" },
          html = { "prettier" },
          java = { "google-java-format" },
          javascript = { "prettier" },
          json = { "prettier" },
          jsonnet = { "jsonnetfmt" },
          lua = { "stylua" },
          markdown = { "prettier" },
          php = { "php_cs_fixer" },
          python = { "isort", "black" },
          ruby = { "rubyfmt" },
          rust = { "rustfmt" },
          sh = { "shfmt" },
          sql = { "sqlfluff" },
          tex = { "tex-fmt" },
          typescript = { "prettier" },
          yaml = { "yamlfmt", "yamlfix" },
        },
        -- The options you set here will be merged with the builtin formatters.
        -- You can also define any custom formatters here.
        ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
        formatters = {
          injected = { options = { ignore_errors = false } },
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
