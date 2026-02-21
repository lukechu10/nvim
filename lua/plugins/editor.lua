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
		"https://codeberg.org/andyg/leap.nvim",
		config = function()
			vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
			vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')

			-- Dim text when searching.
			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("LeapBackdropDim", { clear = true }),
				command = "highlight LeapBackdrop guifg=#777777"
			})

			-- Remote leap mappings
			vim.keymap.set({ 'n', 'o' }, 'gs', function()
				require('leap.remote').action {
					-- Automatically enter Visual mode when coming from Normal.
					input = vim.fn.mode(true):match('o') and '' or 'v'
				}
			end)
			-- Forced linewise version (`gS{leap}jjy`):
			vim.keymap.set({ 'n', 'o' }, 'gS', function()
				require('leap.remote').action { input = 'V' }
			end)

			-- Highly recommended: define a preview filter to reduce visual noise
			-- and the blinking effect after the first keypress
			-- (`:h leap.opts.preview`). You can still target any visible
			-- positions if needed, but you can define what is considered an
			-- exceptional case.
			-- Exclude whitespace and the middle of alphabetic words from preview:
			--   foobar[baaz] = quux
			--   ^----^^^--^^-^-^--^
			require('leap').opts.preview = function(ch0, ch1, ch2)
				return not (
					ch1:match('%s')
					or (ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
				)
			end

			-- Define equivalence classes for brackets and quotes, in addition to
			-- the default whitespace group:
			require('leap').opts.equivalence_classes = {
				' \t\r\n', '([{', ')]}', '\'"`'
			}

			-- Use the traversal keys to repeat the previous motion without
			-- explicitly invoking Leap:
			require('leap.user').set_repeat_keys('<enter>', '<backspace>')
		end
	},

	{
		"saghen/blink.cmp",
		dependencies = { "L3MON4D3/LuaSnip" },
		version = "*",
		opts = {
			snippets = { preset = "luasnip" },
			keymap = {
				preset = "super-tab",
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					}
				}
			},
			completion = {
				documentation = { auto_show = true },
				ghost_text = { enabled = false },
			},
			signature = { enabled = true }
		},
		opts_extend = { "sources.default" }
	},

	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		keys = {
			{
				"<leader>L",
				function()
					require("luasnip.loaders.from_lua").lazy_load({ paths = { "./lua/plugins/snippets" } })
				end,
				desc = "Reload snippets"
			}
		},
		config = function()
			local ls = require('luasnip')

			require("luasnip.loaders.from_lua").lazy_load({ paths = { "./lua/plugins/snippets" } })

			ls.setup({
				enable_autosnippets = true,
				store_selection_keys = "<tab>",
				load_ft_func = require("luasnip.extras.filetype_functions").from_filetype_load
			})

			-- Unlink snippet on mode change (e.g. from insert to normal).
			vim.api.nvim_create_autocmd('ModeChanged', {
				pattern = '*',
				callback = function()
					if ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
						and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
						and not require('luasnip').session.jump_active
					then
						require('luasnip').unlink_current()
					end
				end
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
	},

	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			vim.o.foldcolumn = '0'
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
			vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
			require("ufo").setup {
				provider_selector = function(bufnr, filetype, buftype)
					return { 'treesitter', 'indent' }
				end
			}
		end
	}
}
