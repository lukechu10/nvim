return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		dependencies = { "copilotlsp-nvim/copilot-lsp" },
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
				},
				nes = {
					enabled = true,
					keymap = {
						accept_and_goto = "<leader>cn",
						accept = false,
						dismiss = "<Esc>"
					}
				}
			})
		end
	},
	-- Plugin to integrate Copilot Next Edit Suggestion (NES)
	{
		"copilotlsp-nvim/copilot-lsp",
		init = function()
			vim.g.copilot_nes_debounce = 500
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
	},
}
