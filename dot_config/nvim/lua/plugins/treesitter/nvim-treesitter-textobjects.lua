return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local move = require("nvim-treesitter-textobjects.move")

      -- When in diff mode, fall back to default vim motions for ]c / [c / ]C / [C.
      local function goto_(motion, query, fallback)
        return function()
          if vim.wo.diff and fallback then
            vim.cmd("normal! " .. fallback)
          else
            move[motion](query, "textobjects")
          end
        end
      end

      local mode = { "n", "x", "o" }
      vim.keymap.set(mode, "]f", goto_("goto_next_start", "@function.outer"), { desc = "Next function start" })
      vim.keymap.set(mode, "]F", goto_("goto_next_end", "@function.outer"), { desc = "Next function end" })
      vim.keymap.set(mode, "[f", goto_("goto_previous_start", "@function.outer"), { desc = "Prev function start" })
      vim.keymap.set(mode, "[F", goto_("goto_previous_end", "@function.outer"), { desc = "Prev function end" })

      vim.keymap.set(mode, "]c", goto_("goto_next_start", "@class.outer", "]c"), { desc = "Next class start" })
      vim.keymap.set(mode, "]C", goto_("goto_next_end", "@class.outer", "]C"), { desc = "Next class end" })
      vim.keymap.set(mode, "[c", goto_("goto_previous_start", "@class.outer", "[c"), { desc = "Prev class start" })
      vim.keymap.set(mode, "[C", goto_("goto_previous_end", "@class.outer", "[C"), { desc = "Prev class end" })

      vim.keymap.set(mode, "]a", goto_("goto_next_start", "@parameter.inner"), { desc = "Next param start" })
      vim.keymap.set(mode, "]A", goto_("goto_next_end", "@parameter.inner"), { desc = "Next param end" })
      vim.keymap.set(mode, "[a", goto_("goto_previous_start", "@parameter.inner"), { desc = "Prev param start" })
      vim.keymap.set(mode, "[A", goto_("goto_previous_end", "@parameter.inner"), { desc = "Prev param end" })
    end,
  },
}
