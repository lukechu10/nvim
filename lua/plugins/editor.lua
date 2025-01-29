return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {
			ignored_next_char = [=[[%w%%%'%[%"%`]]=],
		}
	},
	{
		"ggandor/leap.nvim",
		event = "VeryLazy",
		config = function()
			require("leap").add_default_mappings(true)

			-- Dim text when searching.
			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("LeapBackdropDim", { clear = true }),
				command = "highlight LeapBackdrop guifg=#777777"
			})
		end
	},

	{
		"saghen/blink.cmp",
		version = "*",
		opts = {
			keymap = {
				preset = "super-tab",
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" }
			},
			completion = {
				documentation = { auto_show = true },
				ghost_text = { enabled = true },
			},
			signature = { enabled = true },
		},
		opts_extend = { "sources.default" }
	},

	{
		"L3MON4D3/LuaSnip",
		event = "VeryLazy",
		build = "make install_jsregexp",
		keys = {
			{
				"<leader>L",
				function() require("luasnip.loaders.from_lua").load({ paths = "./lua/plugins/snippets" }) end,
				desc = "Reload snippets"
			}
		},
		config = function()
			local ls = require('luasnip')

			require("luasnip.loaders.from_lua").load({ paths = "./lua/plugins/snippets" })

			ls.setup({
				enable_autosnippets = true,
				store_selection_keys = "<tab>",
				load_ft_func = require("luasnip.extras.filetype_functions").from_filetype_load
			})
		end
	},
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{
		"zbirenbaum/copilot.lua",
		event = "VeryLazy",
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
				}
			})
		end
	},

	{
		"folke/zen-mode.nvim",
		opts = {
			width = 100,
			height = 1,
		},
		keys = {
			{
				"<leader>Z",
				"<cmd>ZenMode<CR>",
				desc = "Toggle Zen Mode",
			}
		}
	}
}
