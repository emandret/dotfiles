-- -----------------------------------------------------------------------------
-- FILETYPES
-- -----------------------------------------------------------------------------

vim.filetype.add({
  filename = {
    ["Makefile"]    = "make",
    ["Dockerfile"]  = "dockerfile",
    ["Jenkinsfile"] = "groovy",
  },
  pattern = {
    [".*%.makefile"] = "make",
    [".*%.mk"]       = "make",
    [".*%.h"]        = "cpp",
    [".*%.hpp"]      = "cpp",
    [".*%.c"]        = "cpp",
    [".*%.cc"]       = "cpp",
    [".*%.cpp"]      = "cpp",
    [".*%.tf"]       = "terraform",
    [".*%.tfvars"]   = "terraform",
    [".*%.ya?ml"]    = "yaml",
    [".*%.groovy"]   = "groovy",
  }
})
