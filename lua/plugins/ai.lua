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
}
