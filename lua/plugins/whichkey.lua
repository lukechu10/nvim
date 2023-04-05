return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
		local wk = require("which-key")

		wk.setup()
		wk.register({
			["<leader>"] = {
				f = {
					name = "+find",
				},
				z = { "<cmd>:Lazy<cr>", "Plugin manager" },
				v = {
					name = "+vimrc",
					s = { "<cmd>source $MYVIMRC<cr>", "Source $MYVIMRC" },
					e = { "<cmd>edit $MYVIMRC<cr>", "Edit $MYVIMRC" }
				},
				q = { name = "+session" },
				["<tab>"] = {
					name = "+tabs",
					n = { "<cmd>tabnew<cr>", "New tab" },
					[","] = { "<cmd>tabprevious<cr>", "Previous" },
					["."] = { "<cmd>tabnext<cr>", "Next" },
					d = { "<cmd>tabclose<cr>", "Close" },
					f = { "<cmd>tabfirst<cr>", "First" },
					l = { "<cmd>tablast<cr>", "Last" }
				},
				b = {
					name = "+buffers",
					n = { "<cmd>enew<cr>", "New buffer in fullscreen" },
					h = { "<cmd>new<cr>", "New buffer with horizontal split" },
					v = { "<cmd>vnew<cr>", "New buffer with vertical split" },
					[","] = { "<cmd>bprev<cr>", "Previous" },
					["."] = { "<cmd>bnext<cr>", "Next" },
					d = { "<cmd>bdelete<cr>", "Delete buffer" },
					f = { "<cmd>bfirst<cr>", "First" },
					l = { "<cmd>blast<cr>", "Last" }
				},
				t = {
					name = "+terminal",
					n = { "<cmd>terminal<cr>", "New terminal in fullscreen" },
					h = { "<cmd>split<cr><C-w>j<cmd>terminal<cr>",
						"New terminal with horizontal split" },
					v = { "<cmd>vsplit<cr><C-w>l<cmd>terminal<cr>",
						"New terminal with vertical split" }
				}
			},
			["g"] = { name = "+goto" },
			H = { "<cmd>bprev<cr>", "Go to previous buffer" },
			L = { "<cmd>bnext<cr>", "Go to next buffer" }
		})

		local go_to_buffer_keymap = {
			["<A-h>"] = { "<C-w>h", "Go to buffer on the left" },
			["<A-j>"] = { "<C-w>j", "Go to buffer on the left" },
			["<A-k>"] = { "<C-w>k", "Go to buffer on the left" },
			["<A-l>"] = { "<C-w>l", "Go to buffer on the left" }
		}
		wk.register(go_to_buffer_keymap, { mode = "n" })
		wk.register(go_to_buffer_keymap, { mode = "i" })
		wk.register(go_to_buffer_keymap, { mode = "v" })
		wk.register(go_to_buffer_keymap, { mode = "t" })
	end
}
