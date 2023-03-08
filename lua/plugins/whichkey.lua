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
					name = "+file",
					n = { "<cmd>enew<cr>", "New File" }
				},
				e = { "<cmd>NvimTreeToggle<cr>", "Toggle file tree" },
				z = { "<cmd>:Lazy<cr>", "Plugin manager" },
				v = {
					name = "+vimrc",
					s = { "<cmd>source $MYVIMRC<cr>", "Source $MYVIMRC" },
					e = { "<cmd>edit $MYVIMRC<cr>", "Edit $MYVIMRC" }
				},
				q = { name = "+session" },
				    ["<tab>"] = {
					name = "+tabs",
					    ["<tab>"] = { "<cmd>tabnew<cr>", "New tab" },
					    ["["] = { "<cmd>tabprevious<cr>", "Previous" },
					    ["]"] = { "<cmd>tabnext<cr>", "Next" },
					d = { "<cmd>tabclose<cr>", "Close" },
					f = { "<cmd>tabfirst<cr>", "First" },
					l = { "<cmd>tablast<cr>", "Last" }
				},
				b = {
					name = "+buffers"
				}
			},
			    ["g"] = { name = "+goto" }
		})
	end
}
