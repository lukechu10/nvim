return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("lspconfig").lua_ls.setup {
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
							version = 'LuaJIT'
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { 'vim', 'require' }
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = { enable = false }
					}
				}
			}

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require('lspconfig')
			local servers = {
				'clangd', 'lua_ls', 'rust_analyzer', 'pyright', 'tsserver'
			}
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup {
					-- on_attach = my_custom_on_attach,
					capabilities = capabilities
				}
			end
		end,
		keys = {
			{
				"<A-F>",
				function()
					vim.lsp.buf.format()
				end,
				desc = "Format buffer"
			}
		}
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup {
				ensure_installed = { "lua_ls", "rust_analyzer" }
			}
		end
	},
	"williamboman/mason-lspconfig.nvim",
	{
		"simrat39/rust-tools.nvim",
		config = function()
			local rt = require("rust-tools")
			rt.setup()
		end
	},
	-- completion framework
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					end
				},
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					    ['<C-b>'] = cmp.mapping.sc	(-4),
					    ['<C-f>'] = cmp.mapping.scroll_docs(4),
					    ['<C-Space>'] = cmp.mapping.complete(),
					    ['<C-e>'] = cmp.mapping.abort(),
					    ['<CR>'] = cmp.mapping.confirm({ select = true }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' }, { name = 'vsnip' } -- For vsnip users.
					-- { name = 'luasnip' }, -- For luasnip users.
					-- { name = 'ultisnips' }, -- For ultisnips users.
					-- { name = 'snippy' }, -- For snippy users.
				}, { { name = 'buffer' } })
			})

			-- Set configuration for specific filetype.
			cmp.setup.filetype('gitcommit', {
				sources = cmp.config.sources({
					{ name = 'cmp_git' } -- You can specify the `cmp_git` source if you were installed it.
				}, { { name = 'buffer' } })
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = 'buffer' } }
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			-- cmp.setup.cmdline(':', {
			--    mapping = cmp.mapping.preset.cmdline(),
			--    sources = cmp.config.sources({{name = 'path'}},
			--                                  {{name = 'cmdline'}})
			-- })
		end
	},
	-- LSP completion source
	"hrsh7th/cmp-nvim-lsp",
	-- useful completion sources
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"hrsh7th/cmp-vsnip",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-buffer",
	"hrsh7th/vim-vsnip",
}
