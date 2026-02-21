-- Credit: https://github.com/nvim-telescope/telescope.nvim/issues/2014#issuecomment-1873229658
vim.api.nvim_create_autocmd("FileType", {
	pattern = "TelescopeResults",
	callback = function(ctx)
		vim.api.nvim_buf_call(ctx.buf, function()
			vim.fn.matchadd("TelescopeParent", "\t\t.*$")
			vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
		end)
	end,
})

local function filename_first(_, path)
	local tail = vim.fs.basename(path)
	local parent = vim.fs.dirname(path)
	if parent == "." then return tail end
	return string.format("%s\t\t%s", tail, parent)
end

return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-lua/plenary.nvim",
		},
		keys = {
			mode = "n",
			{ "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>",   desc = "Find string in cwd" },
			{ "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor in cwd" },
			{ "<leader>bb", "<cmd>Telescope buffers<cr>",     desc = "Find buffer" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "Find help tag" },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						},
						n = {
							q = "close"
						}
					},
					path_display = filename_first,
				},
				pickers = {
					colorscheme = {
						enable_preview = true,
					},
				},
			})

			-- Use the native fzf sorter.
			telescope.load_extension("fzf")
		end
	},

	-- Plugin to show LSP progress and messages from vim.notify
	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup {
				notification = {
					override_vim_notify = true,
				}
			}
			require("telescope").load_extension("fidget")

			vim.keymap.set("n", "<leader>fm", "<cmd>Telescope fidget<cr>", { desc = "Find message" })
		end
	},

	{ "stevearc/dressing.nvim", event = "VeryLazy" },
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPre",
		main = "ibl",
		opts = {
			indent = { char = "│" },
			exclude = {
				filetypes = { "help", "dashboard", "lazy" },
			},
			scope = {
				enabled = false,
			},
		},
	},

	{
		"RRethy/vim-illuminate",
		event = "VeryLazy"
	},

	"nvim-tree/nvim-web-devicons",
}
