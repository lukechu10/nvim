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
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		build = "make tiktoken",
		config = function()
			require("CopilotChat").setup({
				mappings = {
					-- Use all defaults except for resetting the chat, which conflicts with <C-l>
					reset = {
						insert = "<C-d>",
						normal = "<C-d>",
						callback = function() end
					}
				}
			})
		end,
		keys = {
			{ "<leader>cc", "<cmd>CopilotChat<cr>", desc = "Open Copilot Chat" },
		}
	}
}
