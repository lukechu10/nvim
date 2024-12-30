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
		branch = "0.1.x",
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
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
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

			local function on_attach(bufnr)
				local api = require('nvim-tree.api')

				local function opts(desc)
					return {
						desc = 'nvim-tree: ' .. desc,
						buffer = bufnr,
						noremap = true,
						silent = true,
						nowait = true
					}
				end

				local function edit_or_open()
					local node = api.tree.get_node_under_cursor()

					if node.nodes ~= nil then
						-- expand or collapse folder
						api.node.open.edit()
					else
						-- open file
						api.node.open.edit()
						-- Close the tree if file was opened
						api.tree.close()
					end
				end

				-- open as vsplit on current node
				local function vsplit_preview()
					local node = api.tree.get_node_under_cursor()

					if node.nodes ~= nil then
						-- expand or collapse folder
						api.node.open.edit()
					else
						-- open file as vsplit
						api.node.open.vertical()
					end

					-- Finally refocus on tree if it was lost
					api.tree.focus()
				end


				local git_add = function()
					local node = api.tree.get_node_under_cursor()
					local gs = node.git_status.file

					-- If the current node is a directory get children status
					if gs == nil then
						gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
							or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
					end

					-- If the file is untracked, unstaged or partially staged, we stage it
					if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
						vim.cmd("silent !git add " .. node.absolute_path)

						-- If the file is staged, we unstage
					elseif gs == "M " or gs == "A " then
						vim.cmd("silent !git restore --staged " .. node.absolute_path)
					end

					api.tree.reload()
				end

				api.config.mappings.default_on_attach(bufnr)

				vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
				vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
				vim.keymap.set("n", "h", api.tree.close, opts("Close"))
				vim.keymap.set('n', 'ga', git_add, opts('Git Add'))
			end

			require("nvim-tree").setup({
				on_attach = on_attach,
				update_focused_file = {
					enable = true
				}
			})
		end,
		keys = {
			{
				"<M-h>",
				function()
					require("nvim-tree.api").tree.open({ find_file = true })
				end,
				desc = "Open file tree and find current file"
			}
		}
	},
	{ "stevearc/dressing.nvim", event = "VeryLazy" },
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPre",
		main = "ibl",
		opts = {
			indent = { char = "│" },
			exclude = {
				filetypes = { "help", "alpha", "dashboard", "lazy" },
			},
			scope = {
				enabled = false,
			},
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

	{
		"RRethy/vim-illuminate",
		event = "VeryLazy"
	},

	"nvim-tree/nvim-web-devicons",

	-- Themes
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
					}
				}
			})
		end
	}
}
