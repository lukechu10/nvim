local function on_attach()
	local tl = require("telescope.builtin")
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
	vim.keymap.set("n", "gd", tl.lsp_definitions, { desc = "Go to definition" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information", noremap = true })
	vim.keymap.set("n", "J", vim.diagnostic.open_float, { desc = "Show diagnostics" })
	vim.keymap.set("n", "gi", tl.lsp_implementations, { desc = "Go to implementation" })
	vim.keymap.set("n", "<space>D", tl.lsp_type_definitions, { desc = "Go to type definition" })
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { desc = "Rename variable" })
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { desc = "Show code actions" })
	vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format { async = true } end,
		{ desc = "Format current buffer" })

	vim.keymap.set("n", "gr", tl.lsp_references, { desc = "Show references" })
	vim.keymap.set("n", "<leader>fw", tl.lsp_workspace_symbols, { desc = "Find workspace symbol" })
	vim.keymap.set("n", "<leader>fd", tl.lsp_document_symbols, { desc = "Find document symbol" })
end


return {
	"folke/neoconf.nvim",
	"folke/neodev.nvim",
	{
		"neovim/nvim-lspconfig",
		dependencies = { "folke/neoconf.nvim", "folke/neodev.nvim" },
		event = "VeryLazy",
		config = function()
			require("neoconf").setup {}
			require("neodev").setup {}
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			lspconfig.lua_ls.setup {
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you"re using (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT"
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim", "require" }
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = { enable = false }
					}
				},
				on_attach = on_attach,
				capabilities = capabilities,
			}
			local servers = {
				"clangd", "pyright", "jsonls", "taplo",
				"tsserver", "tailwindcss", "cssls", "html"
			}
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup {
					on_attach = on_attach,
					capabilities = capabilities
				}
			end

			local border = {
				{ "╭", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╮", "FloatBorder" },
				{ "│", "FloatBorder" },
				{ "╯", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╰", "FloatBorder" },
				{ "│", "FloatBorder" },
			}
			-- Set border globally.
			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or border
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end
		end
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "folke/neoconf.nvim" },
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.eslint,
					null_ls.builtins.formatting.prettier,
				}
			})
		end
	},

	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup {
				ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "taplo", "jsonls",
					"tsserver", "tailwindcss", "cssls", "html" }
			}
		end
	},
	"williamboman/mason-lspconfig.nvim",
	{
		"simrat39/rust-tools.nvim",
		dependencies = { "folke/neoconf.nvim" },
		event = "VeryLazy",
		config = function()
			local rt = require("rust-tools")

			local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")

			local codelldb_path = mason_path .. "bin/codelldb"
			local liblldb_path = mason_path .. "packages/codelldb/extension/lldb/lib/liblldb"
			local this_os = vim.loop.os_uname().sysname

			-- The path in windows is different
			if this_os:find "Windows" then
				codelldb_path = mason_path .. "packages\\codelldb\\extension\\adapter\\codelldb.exe"
				liblldb_path = mason_path .. "packages\\codelldb\\extension\\lldb\\bin\\liblldb.dll"
			else
				-- The liblldb extension is .so for linux and .dylib for macOS
				liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
			end

			rt.setup({
				dap = {
					adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
				},
				server = {
					on_attach = function(_, buffnr)
						on_attach()
						vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = buffnr })
					end
				}
			})
		end
	},
}
