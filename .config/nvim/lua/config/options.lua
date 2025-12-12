-- -----------------------------------------------------------------------------
-- GENERAL SETTINGS
-- -----------------------------------------------------------------------------

local set = vim.opt

-- Enable ttyfast
set.ttyfast = true

-- Enable truecolors and dark background
set.termguicolors = true
set.background = "dark"

-- Set encoding to UTF-8
set.encoding = "utf-8"
set.fileencoding = "utf-8"

-- Disable mouse in all modes
set.mouse = ""

-- Allow backspace to remove indentation, line breaks, start of insert
set.backspace = "indent,eol,start"

-- Yank and paste from the system clipboard
set.clipboard = "unnamed,unnamedplus"

-- Hide unsaved buffers
set.hidden = true

-- Reload modified files
set.autoread = true

-- Enable swapfiles
set.swapfile = true
set.directory = vim.fn.expand("~/.swapfiles")

-- Timeout in ms for which a key can be considered for a mapped sequence
set.timeoutlen = 200

-- Show the status line
set.laststatus = 2

-- Do not show the mode
set.showmode = false

-- Show incomplete commands in the bottom right corner
set.showcmd = true

-- Show the current absolute line number and relative line numbers
set.number = true
set.relativenumber = true

-- Show the cursor position in the status line
set.ruler = true

-- Enable folds
set.foldmethod = "indent"
set.foldlevelstart = 20

-- Ignore case in search patterns except if it contains uppercase letters
set.ignorecase = true
set.smartcase = true

-- Highlight search matches incrementally as the pattern is being typed
set.hlsearch = true
set.incsearch = true

-- Highlight matching pairs of brackets, curly braces, parentheses
set.showmatch = true

-- Enable wildmenu
set.wildmenu = true
set.wildmode = "longest:full,full"
set.wildoptions = "pum"

-- -----------------------------------------------------------------------------
-- INDENTATION SETTINGS
-- -----------------------------------------------------------------------------

-- Set the width of tab characters in columns
set.tabstop = 2

-- How many whitespaces shall be inserted for each indent level
set.shiftwidth = 2

-- Indent new lines and enable syntax-based indentation
set.autoindent = true
set.smartindent = true

-- Convert tabs into spaces and use the shiftwidth value for soft tabs
set.expandtab = true
set.softtabstop = -1

-- -----------------------------------------------------------------------------
-- FILETYPES
-- -----------------------------------------------------------------------------

local uv = vim.uv or vim.loop

local function is_helm_chart(path)
  if not path then
    return nil
  end
  path = uv.fs_realpath(path) or path
  local hit = vim.fs.find("Chart.yaml", { upward = true, path = vim.fs.dirname(path) })[1]
  return hit and vim.fs.dirname(hit) or nil
end

local function helm_ft_from_path(path, bufnr)
  path = path or vim.api.nvim_buf_get_name(bufnr)
  if not path then
    return nil
  end
  path = uv.fs_realpath(path) or path
  if is_helm_chart(path) then
    return "helm"
  end
  return "yaml"
end

-- Define filetypes here
vim.filetype.add({
  filename = {
    ["Makefile"] = "make",
    ["Dockerfile"] = "dockerfile",
    ["Jenkinsfile"] = "groovy",
  },
  pattern = {
    -- Helm-aware detection
    [".*%.ya?ml"] = function(path, bufnr)
      return helm_ft_from_path(path, bufnr)
    end,

    -- Filename pattern matching
    [".*%.c"] = "cpp",
    [".*%.cc"] = "cpp",
    [".*%.h"] = "cpp",
    [".*%.hpp"] = "cpp",
    [".*%.cpp"] = "cpp",
    [".*%.env"] = "dotenv",
    [".*%.groovy"] = "groovy",
    [".*%.makefile"] = "make",
    [".*%.mk"] = "make",
    [".*%.tf"] = "terraform",
    [".*%.tfvars"] = "terraform",
  },
})

-- -----------------------------------------------------------------------------
-- OSC52 CLIPBOARD SUPPORT
-- -----------------------------------------------------------------------------

-- Enable OSC52 clipboard when running inside an SSH session
if vim.env.SSH_TTY ~= nil then
  local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
  if ok then
    vim.g.clipboard = {
      name = "osc52",
      copy = {
        ["+"] = osc52.copy("+"),
        ["*"] = osc52.copy("*"),
      },
      -- Do not try to read from OSC52, fallback to default paste behavior
      paste = {
        ["+"] = function()
          return vim.fn.getreg("+")
        end,
        ["*"] = function()
          return vim.fn.getreg("*")
        end,
      },
    }
  end
end
