return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			mode = "n",
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live Grep" },
			{ "<leader>bb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help tags" },
		}
	},
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
			vim.opt.termguicolors = true

			local function open_nvim_tree(data)
				-- buffer is a real file on the disk
				local real_file = vim.fn.filereadable(data.file) == 1

				-- buffer is a [No Name]
				local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

				if not real_file and not no_name then
					return
				end

				-- open the tree, find the file but don't focus it
				require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
			end
			vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

			-- autoclose neovim when nvim-tree is the last buffer
			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
				pattern = "NvimTree_*",
				callback = function()
					local layout = vim.api.nvim_call_function("winlayout", {})
					if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then
						vim.cmd("confirm quit")
					end
				end
			})
			require("nvim-tree").setup()
		end
	},
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPre",
		config = {
			-- char = "▏",
			char = "│",
			filetype_exclude = { "help", "alpha", "dashboard", "lazy" },
			show_trailing_blankline_indent = false,
			show_current_context = false,
		},
	},

	{
		"goolord/alpha-nvim",
		config = function()
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.buttons.val = {
				dashboard.button("f", "Find files", "\\ff"),
				dashboard.button("g", "Find word", "\\fg"),
				dashboard.button("s", "Load session", "\\qs"),
				dashboard.button("v e", "Edit config", "\\ve"),
				dashboard.button("z", "Plugin manager", ":Lazy<cr>"),
				dashboard.button("q", "Quit", ":qa<cr>")
			}

			require("alpha").setup(dashboard.opts)

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = "⚡ Neovim loaded " ..
					    stats.count .. " plugins in " .. ms .. "ms"
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end
	},

	"nvim-tree/nvim-web-devicons",

	"folke/tokyonight.nvim"
}
