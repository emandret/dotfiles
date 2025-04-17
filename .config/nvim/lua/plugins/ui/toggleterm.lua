return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			open_mapping = [[<Leader>t]],
			direction = "float",
			float_opts = {
				border = "curved",
			},
		})
	end,
}
