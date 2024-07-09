return {
	"folke/trouble.nvim",
	opts = {
		warn_no_results = false,
		open_no_results = true,
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>x",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Toggle diagnostics list"
		}
	}
}
