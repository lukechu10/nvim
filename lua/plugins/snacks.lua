return {
	"folke/snacks.nvim",
	priority = 100,
	lazy = false,
	opts = {
		dashboard = {
			enabled = true,
			example = "doom",
		},
		explorer = {
			enabled = true,
			replace_netrw = true,
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
		{ "<leader>g", function() Snacks.lazygit() end,       desc = "Open lazygit" },
		{ "<A-h>",     function() Snacks.explorer.open() end, desc = "Open file explorer" },
	}
}
