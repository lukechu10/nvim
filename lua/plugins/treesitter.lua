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
					"c", "c_sharp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
					"rust", "toml", "json", "jsonc", "javascript", "typescript",
					"css", "html", "bash", "python", "typst"
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
		config = function()
			require("nvim-treesitter.configs").setup({
				textsubjects = {
					enable = true,
					prev_selection = ',',
					keymaps = {
						['<cr>'] = 'textsubjects-smart',
						['\''] = 'textsubjects-container-outer',
						['i\''] = { 'textsubjects-container-inner', desc = "Select inside containers (classes, functions, etc.)" },
					},
				},
			})
		end
	}
}
