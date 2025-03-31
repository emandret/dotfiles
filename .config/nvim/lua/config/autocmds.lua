autocmd BufWritePre * %s/\s\+$//e

autocmd BufNewFile,BufReadPost Makefile,*.makefile,*.mk vim.opt.filetype=make
autocmd BufNewFile,BufReadPost *.h,*.hpp,*.c,*.cc,*.cpp vim.opt.filetype=cpp
autocmd BufNewFile,BufReadPost Dockerfile,Dockerfile.* vim.opt.filetype=dockerfile
autocmd BufNewFile,BufReadPost *.tf,*.tfvars vim.opt.filetype=terraform
autocmd BufNewFile,BufReadPost *.yaml,*.yml vim.opt.filetype=yaml
autocmd BufNewFile,BufReadPost Jenkinsfile,*.groovy vim.opt.filetype=groovy

autocmd FileType make vim.opt.tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab

autocmd FileType markdown vim.opt.equalprg=prettier\ --parser\ markdown
autocmd FileType cpp vim.opt.equalprg=clang-format\ -style=Microsoft
autocmd FileType python vim.opt.equalprg=black\ --quiet\ -
autocmd FileType terraform vim.opt.equalprg=terraform\ fmt\ -
autocmd FileType yaml vim.opt.equalprg=yamlfmt
autocmd FileType sh vim.opt.equalprg=shfmt\ -i\ 2\ -ci\ -sr
