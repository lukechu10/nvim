return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
		local wk = require("which-key")

		wk.add({
			{ "<leader><tab>",  group = "tabs" },
			{ "<leader><tab>,", "<cmd>tabprevious<cr>", desc = "Previous" },
			{ "<leader><tab>.", "<cmd>tabnext<cr>",     desc = "Next" },
			{ "<leader><tab>d", "<cmd>tabclose<cr>",    desc = "Close" },
			{ "<leader><tab>f", "<cmd>tabfirst<cr>",    desc = "First" },
			{ "<leader><tab>l", "<cmd>tablast<cr>",     desc = "Last" },
			{ "<leader><tab>n", "<cmd>tabnew<cr>",      desc = "New tab" },
			{ "<leader>C",      group = "colorscheme" },
			{
				"<leader>CL",
				"<cmd>colorscheme catppuccin-latte<cr><cmd>hi Normal guibg=NONE ctermbg=NONE<cr>",
				desc = "Catppuccin Latte (Transparent)"
			},
			{
				"<leader>CS",
				"<cmd>set background=light<cr><cmd>colorscheme solarized<cr><cmd>hi Normal guibg=NONE ctermbg=NONE<cr>",
				desc = "Solarized (Light, Transparent)"
			},
			{
				"<leader>Cg",
				"<cmd>set background=dark<cr><cmd>colorscheme gruvbox<cr>",
				desc = "Gruvbox"
			},
			{
				"<leader>Cl",
				"<cmd>colorscheme catppuccin-latte<cr>",
				desc = "Catppuccino Latte"
			},
			{
				"<leader>Cs",
				"<cmd>set background=light<cr><cmd>colorscheme solarized<cr>",
				desc = "Solarized (Light)"
			},
			{
				"<leader>Ct",
				"<cmd>set background=dark<cr><cmd>colorscheme tokyonight<cr>",
				desc = "Tokyo Night"
			},
			{ "<leader>b",  group = "buffers" },
			{ "<leader>b,", "<cmd>bprev<cr>",   desc = "Previous" },
			{ "<leader>b.", "<cmd>bnext<cr>",   desc = "Next" },
			{ "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete buffer" },
			{ "<leader>bf", "<cmd>bfirst<cr>",  desc = "First" },
			{ "<leader>bh", "<cmd>new<cr>",     desc = "New buffer with horizontal split" },
			{ "<leader>bl", "<cmd>blast<cr>",   desc = "Last" },
			{ "<leader>bn", "<cmd>enew<cr>",    desc = "New buffer in fullscreen" },
			{ "<leader>bv", "<cmd>vnew<cr>",    desc = "New buffer with vertical split" },
			{ "<leader>c",  group = "code" },
			{ "<leader>f",  group = "find" },
			{ "<leader>q",  group = "session" },
			{ "<leader>t",  group = "terminal" },
			{
				"<leader>th",
				"<cmd>split<cr><C-w>j<cmd>terminal<cr>",
				desc = "New terminal with horizontal split"
			},
			{
				"<leader>tn",
				"<cmd>terminal<cr>",
				desc = "New terminal in fullscreen"
			},
			{
				"<leader>tv",
				"<cmd>vsplit<cr><C-w>l<cmd>terminal<cr>",
				desc = "New terminal with vertical split"
			},
			{ "<leader>v",  group = "vimrc" },
			{ "<leader>ve", "<cmd>edit $MYVIMRC<cr>",   desc = "Edit $MYVIMRC" },
			{ "<leader>vs", "<cmd>source $MYVIMRC<cr>", desc = "Source $MYVIMRC" },
			{ "<leader>z",  "<cmd>:Lazy<cr>",           desc = "Plugin manager" },
			{ "H",          "<cmd>bprev<cr>",           desc = "Go to previous buffer" },
			{ "L",          "<cmd>bnext<cr>",           desc = "Go to next buffer" },
			{ "g",          group = "goto" },
		})

		local go_to_buffer_keymap = {
			{ "<C-h>", "<C-w>h", desc = "Go to buffer on the left" },
			{ "<C-j>", "<C-w>j", desc = "Go to buffer below" },
			{ "<C-k>", "<C-w>k", desc = "Go to buffer above" },
			{ "<C-l>", "<C-w>l", desc = "Go to buffer on the right" }
		}
		wk.add(go_to_buffer_keymap, { mode = "n", noremap = false })
		wk.add(go_to_buffer_keymap, { mode = "v", noremap = false })

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
