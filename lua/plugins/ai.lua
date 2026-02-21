return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
				}
			})
		end
	},
	{
		"olimorris/codecompanion.nvim",
		version = "*",
		opts = {},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			vim.keymap.set("n", "<leader>ccp", "<cmd>CodeCompanion<cr>", { desc = "Code Companion Prompt" })
			vim.keymap.set({ "n", "v" }, "<leader>cca", "<cmd>CodeCompanionActions<cr>",
				{ desc = "Code Companion Actions" })
			vim.keymap.set({ "n", "v" }, "<leader>ccc", "<cmd>CodeCompanionChat<cr>",
				{ desc = "Code Companion Chat" })

			require("codecompanion").setup()
		end,
	}

}
