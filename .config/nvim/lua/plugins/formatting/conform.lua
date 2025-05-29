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
          lua = { "stylua" },
          sh = { "shfmt" },
          bash = { "shfmt" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          go = { "crlfmt" },
          python = { "black" },
          java = { "google-java-format" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          yaml = { "prettier" },
          json = { "prettier" },
          markdown = { "prettier" },
          latex = { "latexindent" },
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
