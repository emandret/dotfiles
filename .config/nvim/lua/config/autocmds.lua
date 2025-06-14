-- -----------------------------------------------------------------------------
-- AUTOCMDS
-- -----------------------------------------------------------------------------

local autocmd = vim.api.nvim_create_autocmd

-- Redraw on focus
autocmd("FocusGained", {
  callback = function()
    vim.cmd("redraw!")
  end,
})

-- Restore cursor position
autocmd("BufReadPost", {
  callback = function()
    local line = vim.fn.line
    if line([['"]]) > 1 and line([['"]]) <= line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})

-- Trim trailing whitespaces on save
autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

-- Highlight yanked text
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- Use tabs for Makefiles
autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.bo.tabstop = 8
    vim.bo.shiftwidth = 8
    vim.bo.softtabstop = 0
    vim.bo.expandtab = false
  end,
})

-- -----------------------------------------------------------------------------
-- FORMATTERS
-- -----------------------------------------------------------------------------

autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.bo.equalprg = "prettier --parser markdown"
  end,
})

autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.bo.equalprg = "clang-format -style=Microsoft"
  end,
})

autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.bo.equalprg = "black --quiet -"
  end,
})

autocmd("FileType", {
  pattern = "terraform",
  callback = function()
    vim.bo.equalprg = "terraform fmt -"
  end,
})

autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    vim.bo.equalprg = "yamlfmt -"
  end,
})
