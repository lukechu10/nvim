return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	config = function()
		vim.o.sessionoptions = "buffers,curdir,tabpages,terminal,winsize,help,globals"
		require("persistence").setup()
	end,
	keys = {
		{
			"<leader>qs",
			function()
				require("persistence").load()
			end,
			desc = "Restore session"
		},
		{
			"<leader>ql",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Restore last session"
		},
		{
			"<leader>qd",
			function()
				require("persistence").stop()
			end,
			desc = "Don't save current session"
		},
	}
}
