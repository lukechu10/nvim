return {
	{
		"lervag/vimtex",
		tag = "v2.15",
		ft = { "tex" },
		init = function()
			vim.cmd [[ filetype plugin indent on ]]
			local latexmk = vim.fn.has("win32") == 1 and "latexmk.exe" or "latexmk"
			vim.g.vimtex_compiler_latexmk = {
				executable = latexmk,
				options = {
					"-verbose",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
					"-shell-escape"
				}
			}
			vim.g.vimtex_quickfix_mode = 0
		end
	},
	{
		"lukechu10/illustrate.nvim",
		dependencies = {
			"rcarriga/nvim-notify",
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
		},
		keys = function()
			local illustrate = require('illustrate')
			local illustrate_finder = require('illustrate.finder')

			return {
				{
					"<leader>is",
					function() illustrate.create_and_open_svg() end,
					desc = "Create and open a new SVG file with provided name."
				},
				{
					"<leader>ia",
					function() illustrate.create_and_open_ai() end,
					desc = "Create and open a new Adobe Illustrator file with provided name."
				},
				{
					"<leader>io",
					function() illustrate.open_under_cursor() end,
					desc = "Open file under cursor (or file within environment under cursor)."
				},
				{
					"<leader>if",
					function() illustrate_finder.search_and_open() end,
					desc = "Use telescope to search and open illustrations in default app."
				},
				{
					"<leader>ic",
					function() illustrate_finder.search_create_copy_and_open() end,
					desc = "Use telescope to search existing file, copy it with new name, and open it in default app."
				},
			}
		end,
		opts = {
			illustration_dir = "figures",
			default_app = {
				svg = "inkscape",
				ai = "inkscape",
			}
		},
	}
}
