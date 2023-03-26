return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			theme = "tokyonight",
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'branch', 'diff', 'diagnostics' },
				lualine_c = { 'filename' },
				lualine_x = { 'encoding', 'fileformat', 'filetype' },
				lualine_y = { 'progress' },
				lualine_z = { 'location' }
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { 'filename' },
				lualine_x = { 'location' },
				lualine_y = {},
				lualine_z = {}
			},
			extensions = { "nvim-tree" }
		}
	},

	{
		"akinsho/bufferline.nvim",
		opts = {
			options = {
				diagnostics = "nvim_lsp"
			}
		}
	},

	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup()
		end
	}
}
