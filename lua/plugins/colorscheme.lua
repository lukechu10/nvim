-- Plugins for color schemes
return {
	"folke/tokyonight.nvim",
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			-- require("gruvbox").setup({
			-- 	contrast = "hard",
			-- })
			vim.g.gruvbox_material_foreground = "material"
			vim.g.gruvbox_material_background = "hard"
			vim.g.gruvbox_material_enable_bold = 1
			vim.g.gruvbox_material_enable_italic = 1
			vim.g.gruvbox_material_dim_inactive_windows = 1
			vim.g.gruvbox_material_inlay_hints_background = 'dimmed'
			vim.g.gruvbox_material_disable_terminal_colors = 1
		end
	},
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
