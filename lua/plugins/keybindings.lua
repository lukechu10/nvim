return {
	"folke/which-key.nvim",
	config = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
		local wk = require("which-key")

		wk.setup()
		wk.register({
			    ["<leader>"] = {
				f = {
					name = "+file",
					f = { "<cmd>Telescope find_files<cr>", "Find File" },
					g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
					b = { "<cmd>Telescope buffers<cr>", "Buffers" },
					h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
					n = { "<cmd>enew<cr>", "New File" }
				},
				e = { "<cmd>NvimTreeToggle<cr>", "Toggle file tree" },
				v = {
					name = "+vimrc",
					s = { "<cmd>source $MYVIMRC<cr>", "Source $MYVIMRC" },
					e = { "<cmd>edit $MYVIMRC<cr>", "Edit $MYVIMRC" }
				}
			}
		}, {})
	end
}
