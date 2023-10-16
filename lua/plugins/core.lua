return {
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		config = function()
			require("fidget").setup()
		end,
	},
	"tpope/vim-repeat",

	{
		"numToStr/FTerm.nvim",
		keys = {
			{ "<A-i>", "<cmd>lua require('FTerm').toggle()<cr>",            desc = "Toggle FTerm" },
			{ "<A-i>", "<C-\\><C-n><cmd>lua require('FTerm').toggle()<cr>", mode = "t",           desc = "Toggle FTerm" },
		}
	}
}
