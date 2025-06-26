return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- Options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "\u{2022}", -- Unicode for bullet point (U+2022)
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = "\u{274C}", -- Unicode for cross mark (U+274C)
              [vim.diagnostic.severity.WARN] = "\u{26A0}\u{FE0F}", -- Unicode for warning sign (U+26A0) + emoji rendering (U+FE0F)
              [vim.diagnostic.severity.HINT] = "\u{1F4A1}", -- Unicode for light bulb (U+1F4A1)
              [vim.diagnostic.severity.INFO] = "\u{2139}\u{FE0F}", -- Unicode for information (U+2139) + emoji rendering (U+FE0F)
            },
          },
        },
        -- Enable inlay hints
        inlay_hints = {
          enabled = true,
        },
        -- Disable code lenses
        codelens = {
          enabled = false,
        },
        -- Add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- Options for vim.lsp.buf.format
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP server settings
        ---@type lspconfig.options
        servers = {
          ansiblels = {},
          asm_lsp = {},
          awk_ls = {},
          bashls = {},
          clangd = {},
          cmake = {},
          cssls = {},
          docker_compose_language_service = {},
          dockerls = {},
          eslint = {},
          gopls = {
            settings = {
              gopls = {
                analyses = {
                  unusedparams = true,
                  unreachable = true,
                },
                staticcheck = true,
                completeUnimported = true,
              },
            },
          },
          groovyls = {},
          helm_ls = {},
          html = {},
          java_language_server = {},
          jdtls = {},
          jinja_lsp = {},
          jsonls = {},
          jsonnet_ls = {},
          lua_ls = {
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
          nginx_language_server = {},
          pyright = {},
          rust_analyzer = {},
          sqls = {},
          systemd_ls = {},
          terraformls = {},
          texlab = {},
          ts_ls = {},
          vimls = {},
          yamlls = {},
        },
        -- You can do any additional LSP server setup here
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
      return ret
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
      if type(opts.diagnostics.signs) ~= "boolean" then
        for severity, icon in pairs(opts.diagnostics.signs.text) do
          local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
          name = "DiagnosticSign" .. name
          vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
        end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- Get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig").get_mappings().lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- Run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        mlsp.setup({
          automatic_enable = true,
          ensure_installed = ensure_installed,
          handlers = { setup },
        })
      end
    end,
  },
}
