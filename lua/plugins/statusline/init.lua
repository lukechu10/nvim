return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			theme = "auto",
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
		event = "VimEnter",
		opts = {
			options = {
				diagnostics = "nvim_lsp"
			}
		}
	},

	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		config = function()
			require("fidget").setup()
		end
	}
}
