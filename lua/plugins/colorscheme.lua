-- Plugins for color schemes
return {
	"folke/tokyonight.nvim",
	"ellisonleao/gruvbox.nvim",
	"maxmx03/solarized.nvim",
	{
		"catppuccin/nvim",
		config = function()
			require("catppuccin").setup({
				integrations = {
					blink_cmp = true,
					mason = true,
					telescope = {
						enabled = true,
						style = "nvchad",
					},
					lsp_trouble = true,
					which_key = true,
				}
			})
		end
	}
}
