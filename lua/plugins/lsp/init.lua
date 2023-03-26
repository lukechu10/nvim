local function on_attach()
	local tl = require("telescope.builtin")
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to declaration" })
	vim.keymap.set('n', 'gd', tl.lsp_definitions, { desc = "Go to definition" })
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Show hover information", noremap = true })
	vim.keymap.set('n', 'gi', tl.lsp_implementations, { desc = "Go to implementation" })
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = "Show signature help" })
	vim.keymap.set('n', '<space>D', tl.lsp_type_definitions, { desc = "Go to type definition" })
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, { desc = "Rename variable" })
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, { desc = "Show code actions" })
	vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end,
		{ desc = "Format current buffer" })

	vim.keymap.set('n', 'gr', tl.lsp_references, { desc = "Show references" })
	vim.keymap.set('n', '<space>p', tl.lsp_workspace_symbols, { desc = "Find workspace symbol" })
end


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
					on_attach = on_attach,
					capabilities = capabilities
				}
			end
		end
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
			rt.setup({
				server = {
					on_attach = on_attach
				}
			})
		end
	},
}
