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
		indent = {
			enabled = true,
			animate = {
				enabled = false,
			},
		},
		input = {
			prompt_pos = "left",
		},
		lazygit = {
			enabled = true,
			win = {
				bo = {
					filetype = "lazygit",
				}
			}
		},
		picker = {
			ui_select = true,
		},

		styles = {
			input = {
				relative = "cursor",
				row = -3,
				col = 0,
				height = 1,
			}
		}
	},
	keys = {
		{ "<leader>gg", function() Snacks.lazygit() end,       desc = "Open lazygit" },
		{ "<A-h>",      function() Snacks.explorer.open() end, desc = "Open file explorer" },
	}
}
