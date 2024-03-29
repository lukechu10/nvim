vim.api.nvim_set_keymap('n', 'j', 'gj', {})
vim.api.nvim_set_keymap('n', 'k', 'gk', {})

return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
		end
	},
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		config = function()
			require("mini.comment").setup()
		end
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

	-- completion framework
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			-- LSP completion source
			"hrsh7th/cmp-nvim-lsp",
			-- useful completion sources
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/vim-vsnip",
			-- Completion Menu UI
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			local lspkind = require("lspkind")

			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						-- require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
						-- require("snippy").expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					end
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							local entry = cmp.get_selected_entry()
							if not entry then
								cmp.select_next_item({
									behavior = cmp.SelectBehavior.Select })
							end
							cmp.confirm()
						else
							fallback()
						end
					end, { "i", "s", "c" }),
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() and cmp.get_active_entry() then
							cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
						else
							fallback()
						end
					end, { "i" }),
				}),
				sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "nvim_lsp_signature_help" },
						{ name = "vsnip" },
					},
					{
						{ name = "buffer" }
					}),
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
					})
				}
			})

			-- Set configuration for specific filetype.
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "cmp_git" } -- You can specify the `cmp_git` source if you were installed it.
				}, { { name = "buffer" } })
			})

			vim.api.nvim_create_autocmd("BufRead", {
				group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
				pattern = "Cargo.toml",
				callback = function()
					cmp.setup.buffer({ sources = { { name = "crates" } } })
				end,
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won"t work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = "buffer" } }
			})

			-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({ { name = "path" } },
					{ {
						name = "cmdline",
						option = {
							ignore_cmds = { 'Man', '!' }
						}
					} })
			})
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end
	},
	{
		"hrsh7th/vim-vsnip",
		config = function()
			vim.cmd [[
				" Jump forward or backward
				imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
				smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
				imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
				smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
			]]
		end
	},

	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" }
	},

	{
		"zbirenbaum/copilot.lua",
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
				}
			})
		end
	}
}
