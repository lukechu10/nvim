return {
	"folke/snacks.nvim",
	priority = 100,
	lazy = false,
	-- @type snacks.Config
	opts = {
		dashboard = {
			enabled = true,
			example = "doom",
		},
		lazygit = {
			enabled = true,
			win = {
				bo = {
					filetype = "lazygit",
				}
			}
		},
	},
	keys = {
		{ "<leader>g", function() Snacks.lazygit() end, desc = "Open lazygit" }
	}
}
