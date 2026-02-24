return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local colors = {
        bg = "#202020",
        bg_dark = "#101010",
        fg = "#FFFFFF",
        fg_dark = "#646464",
        red = "#640000",
        orange = "#643200",
        green = "#006400",
        blue = "#000064",
      }

      local empty = require("lualine.component"):extend()
      function empty:draw(default_highlight)
        self.status = ""
        self.applied_separator = ""
        self:apply_highlights(default_highlight)
        self:apply_section_separators()
        return self.status
      end

      local function search_result()
        if vim.v.hlsearch == 0 then
          return ""
        end
        local last_search = vim.fn.getreg("/")
        if not last_search or last_search == "" then
          return ""
        end
        local searchcount = vim.fn.searchcount({ maxcount = 9999 })
        return last_search .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
      end

      local function modified()
        if vim.bo.modified then
          return "+"
        elseif vim.bo.modifiable == false or vim.bo.readonly == true then
          return "-"
        end
        return ""
      end

      require("lualine").setup({
        options = {
          theme = {
            normal = {
              a = { fg = colors.fg, bg = colors.blue, gui = "bold" },
              b = { fg = colors.fg, bg = colors.bg },
              c = { fg = colors.fg_dark, bg = colors.bg_dark },
            },
            insert = { a = { fg = colors.fg, bg = colors.green, gui = "bold" } },
            visual = { a = { fg = colors.fg, bg = colors.orange, gui = "bold" } },
            replace = { a = { fg = colors.fg, bg = colors.red, gui = "bold" } },
            inactive = {
              a = { fg = colors.fg_dark, bg = colors.bg_dark },
              b = { fg = colors.fg_dark, bg = colors.bg_dark },
              c = { fg = colors.fg_dark, bg = colors.bg_dark },
            },
          },
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = {
            {
              "mode",
              padding = { left = 0, right = 1 },
            },
          },
          lualine_b = {
            { "branch" },
            { "diff" },
            {
              "diagnostics",
              source = { "nvim" },
              sections = { "error" },
              diagnostics_color = { error = { bg = colors.red, fg = colors.fg } },
            },
            {
              "diagnostics",
              source = { "nvim" },
              sections = { "warn" },
              diagnostics_color = { warn = { bg = colors.orange, fg = colors.fg } },
            },
            {
              modified,
              color = { bg = colors.red, fg = colors.fg },
            },
            {
              "%w",
              cond = function()
                return vim.wo.previewwindow
              end,
            },
            {
              "%r",
              cond = function()
                return vim.bo.readonly
              end,
            },
            {
              "%q",
              cond = function()
                return vim.bo.buftype == "quickfix"
              end,
            },
          },
          lualine_c = {
            function()
              if vim.go.columns > 210 then
                return vim.fn.expand("%:~")
              end
              return vim.fn.expand("%f:h")
            end,
          },
          lualine_x = {},
          lualine_y = { search_result, "filetype" },
          lualine_z = {
            { "%l:%c" },
            {
              "%p%%/%L",
              padding = { left = 1, right = 0 },
            },
          },
        },
        inactive_sections = {},
      })
    end,
  },
}
