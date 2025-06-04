return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local colors = require("catppuccin.palettes").get_palette()

      local empty = require("lualine.component"):extend()
      function empty:draw(default_highlight)
        self.status = ""
        self.applied_separator = ""
        self:apply_highlights(default_highlight)
        self:apply_section_separators()
        return self.status
      end

      local function process_sections(sections)
        for name, section in pairs(sections) do
          local left = name:sub(9, 10) < "x"
          for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
            table.insert(section, pos * 2, { empty, color = { bg = colors.text, fg = colors.text } })
          end
          for id, comp in ipairs(section) do
            if type(comp) ~= "table" then
              comp = { comp }
              section[id] = comp
            end
            comp.separator = left and { right = "\u{E0B8}" } or { left = "\u{E0BA}" }
          end
        end
        return sections
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

      local function hide_in_width()
        return vim.fn.winwidth(0) > 210
      end

      require("lualine").setup({
        options = {
          theme = "catppuccin",
          globalstatus = true,
          component_separators = "",
          section_separators = { left = "\u{E0B8}", right = "\u{E0BA}" },
        },
        sections = process_sections({
          lualine_a = { "mode" },
          lualine_b = {
            { "branch" },
            { "diff" },
            {
              "diagnostics",
              source = { "nvim" },
              sections = { "error" },
              diagnostics_color = { error = { bg = colors.red, fg = colors.base } },
            },
            {
              "diagnostics",
              source = { "nvim" },
              sections = { "warn" },
              diagnostics_color = { warn = { bg = colors.peach, fg = colors.base } },
            },
            {
              function()
                return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
              end,
              cond = hide_in_width,
            },
            {
              "filename",
              file_status = false,
              path = 1,
              cond = hide_in_width,
            },
            {
              modified,
              color = { bg = colors.red, fg = colors.base },
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
          lualine_c = {},
          lualine_x = {},
          lualine_y = { search_result, "filetype" },
          lualine_z = { "%l:%c", "%p%%/%L" },
        }),
        inactive_sections = {
          lualine_c = { "%f %y %m" },
          lualine_x = {},
        },
      })
    end,
  },
}
