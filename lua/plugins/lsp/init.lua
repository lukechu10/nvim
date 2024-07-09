local function on_attach(client, bufnr)
	local tl = require("telescope.builtin")
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
	vim.keymap.set("n", "gd", tl.lsp_definitions, { desc = "Go to definition" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information", noremap = true })
	vim.keymap.set("n", "J", vim.diagnostic.open_float, { desc = "Show diagnostics" })
	vim.keymap.set("n", "gi", tl.lsp_implementations, { desc = "Go to implementation" })
	vim.keymap.set("n", "<leader>D", tl.lsp_type_definitions, { desc = "Go to type definition" })
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename variable" })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Show code actions" })
	vim.keymap.set("n", "<leader>F", function() vim.lsp.buf.format { async = true } end,
		{ desc = "Format current buffer" })

	vim.keymap.set("n", "gr", tl.lsp_references, { desc = "Show references" })
	vim.keymap.set("n", "<leader>fw", tl.lsp_workspace_symbols, { desc = "Find workspace symbol" })
	vim.keymap.set("n", "<leader>fd", tl.lsp_document_symbols, { desc = "Find document symbol" })

	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end


return {
	"folke/neoconf.nvim",
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
				"lazy.nvim",
			},
			enabled = true,
		}
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		"neovim/nvim-lspconfig",
		dependencies = { "folke/neoconf.nvim" },
		event = "VeryLazy",
		config = function()
			require("neoconf").setup {}
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local servers = {
				"clangd",
				"pyright",
				"tsserver", "tailwindcss", "cssls", "html",
				"texlab",
				"taplo", "jsonls",
				"lua_ls",
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
		event = "VeryLazy",
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup {
				ensure_installed = {
					"lua_ls",
					"clangd",
					"rust_analyzer",
					"pyright",
					"tsserver", "tailwindcss", "cssls", "html",
					"texlab",
					"taplo", "jsonls",
				}
			}
			require("mason-lspconfig").setup_handlers {
				["rust_analyzer"] = function() end, -- Avoid conflict with rustaceanvim
			}
		end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = "williamboman/mason.nvim"
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^4",
		ft = { "rust" },
		config = function()
			vim.g.rustaceanvim = {
				server = {
					on_attach = on_attach,
				},
			}
		end,
	},
}
