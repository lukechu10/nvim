return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"c", "rust", "c_sharp", "fsharp",
					"javascript", "typescript", "tsx", "css", "html",
					"python", "lua", "bash", "fish",
					"toml", "json", "jsonc",
					"typst", "vim", "vimdoc", "query", "markdown", "markdown_inline",
				},
				highlight = {
					enable = true,
					disable = { "rust" },
				},
			})
		end
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",

							["ac"] = "@class.outer",
							["ic"] = "@class.inner",

							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",

							["il"] = "@loop.inner",
							["al"] = "@loop.outer",

							["a="] = "@assignment.outer",
							["i="] = "@assignment.inner",
							["r="] = "@assignment.rhs",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]m"] = "@function.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
						},
					},
					include_surrounding_whitespace = true,
				}
			})
		end
	},
	{
		"RRethy/nvim-treesitter-textsubjects",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	}
}
