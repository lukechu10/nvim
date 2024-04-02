return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
		local wk = require("which-key")

		wk.setup({
			operators = { gc = "Comments" },
		})
		wk.register({
			["<leader>"] = {
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
				c = {
					name = "+code",
				},
				f = {
					name = "+find",
				},
				q = { name = "+session" },
				t = {
					name = "+terminal",
					n = { "<cmd>terminal<cr>", "New terminal in fullscreen" },
					h = { "<cmd>split<cr><C-w>j<cmd>terminal<cr>",
						"New terminal with horizontal split" },
					v = { "<cmd>vsplit<cr><C-w>l<cmd>terminal<cr>",
						"New terminal with vertical split" }
				},
				v = {
					name = "+vimrc",
					s = { "<cmd>source $MYVIMRC<cr>", "Source $MYVIMRC" },
					e = { "<cmd>edit $MYVIMRC<cr>", "Edit $MYVIMRC" }
				},
				z = { "<cmd>:Lazy<cr>", "Plugin manager" },
				["<tab>"] = {
					name = "+tabs",
					n = { "<cmd>tabnew<cr>", "New tab" },
					[","] = { "<cmd>tabprevious<cr>", "Previous" },
					["."] = { "<cmd>tabnext<cr>", "Next" },
					d = { "<cmd>tabclose<cr>", "Close" },
					f = { "<cmd>tabfirst<cr>", "First" },
					l = { "<cmd>tablast<cr>", "Last" }
				}
			},
			["g"] = { name = "+goto" },
			H = { "<cmd>bprev<cr>", "Go to previous buffer" },
			L = { "<cmd>bnext<cr>", "Go to next buffer" }
		})

		local go_to_buffer_keymap = {
			["<C-h>"] = { "<C-w>h", "Go to buffer on the left" },
			["<C-j>"] = { "<C-w>j", "Go to buffer below" },
			["<C-k>"] = { "<C-w>k", "Go to buffer above" },
			["<C-l>"] = { "<C-w>l", "Go to buffer on the right" }
		}
		wk.register(go_to_buffer_keymap, { mode = "n", noremap = false })
		wk.register(go_to_buffer_keymap, { mode = "v", noremap = false })

		-- Remap <cr> to clear search highlights
		vim.keymap.set("n", "<cr>", ":noh<cr><cr>",
			{ noremap = true, silent = true, desc = "Clear search highlights" })

		-- Remap jj, jk, kj, kk to <Esc> in insert and terminal mode
		vim.keymap.set("i", "jj", "<Esc>")
		vim.keymap.set("i", "jk", "<Esc>")
		vim.keymap.set("i", "kj", "<Esc>")
		vim.keymap.set("i", "kk", "<Esc>")
		vim.api.nvim_create_autocmd("TermOpen", {
			callback = function()
				print(vim.bo.filetype)
				if vim.bo.filetype ~= "lazygit" then
					vim.keymap.set("t", "jj", "<C-\\><C-n>", { buffer = true })
					vim.keymap.set("t", "jk", "<C-\\><C-n>", { buffer = true })
					vim.keymap.set("t", "kj", "<C-\\><C-n>", { buffer = true })
					vim.keymap.set("t", "kk", "<C-\\><C-n>", { buffer = true })
				end
			end
		})
	end
}
