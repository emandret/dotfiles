return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local opts = {
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 40,
			},
			renderer = {
				group_empty = true,
			},
			filters = {
				dotfiles = true,
			},
		}

		require("nvim-tree").setup(opts)
	end,
}
