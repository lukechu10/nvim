return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install {
				"c", "rust", "c_sharp", "fsharp",
				"javascript", "typescript", "tsx", "css", "html",
				"python", "lua", "bash", "fish",
				"toml", "json", "yaml",
				"hyprlang", "nix",
				"typst", "vim", "vimdoc", "query", "markdown", "markdown_inline",
			}

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("TreeSitterEnable", { clear = true }),
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match)
					if not lang then return end

					if vim.treesitter.query.get(lang, "highlights") then
						vim.treesitter.start(args.buf, lang)
					end

					if vim.treesitter.query.get(lang, "indents") then
						vim.opt_local.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
					end

					-- Folding is handled by nvim-ufo so we don't need to set it up here.
				end
			})
		end
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		init = function()
			-- Disable default ftplugin mappings to avoid conflict
			vim.g.no_plugin_maps = true
		end,
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "v",
					},
					include_surrounding_whitespace = false,
				},
				move = {
					set_jumps = true,
				},
			})

			-- Textobjects: Select
			vim.keymap.set({ "x", "o" }, "am", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end, { desc = "method/function" })
			vim.keymap.set({ "x", "o" }, "im", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end, { desc = "method/function" })

			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end, { desc = "class" })
			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end, { desc = "class" })

			vim.keymap.set({ "x", "o" }, "ap", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
			end, { desc = "parameter" })
			vim.keymap.set({ "x", "o" }, "ip", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
			end, { desc = "parameter" })

			vim.keymap.set({ "x", "o" }, "al", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@loop.outer", "textobjects")
			end, { desc = "loop" })
			vim.keymap.set({ "x", "o" }, "il", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@loop.inner", "textobjects")
			end, { desc = "loop" })

			vim.keymap.set({ "x", "o" }, "a=", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@assignment.outer", "textobjects")
			end, { desc = "assignment" })
			vim.keymap.set({ "x", "o" }, "i=", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@assignment.inner", "textobjects")
			end, { desc = "assignment" })
			vim.keymap.set({ "x", "o" }, "r=", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@assignment.rhs", "textobjects")
			end, { desc = "assignment rhs" })

			-- Textobjects: Swap
			vim.keymap.set("n", "<leader>a", function()
				require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
			end, { desc = "Swap parameter with next" })
			vim.keymap.set("n", "<leader>A", function()
				require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
			end, { desc = "Swap parameter with previous" })

			-- Textobjects: Move
			vim.keymap.set("n", "]m", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
			end, { desc = "Next method start" })
			vim.keymap.set("n", "]M", function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
			end, { desc = "Next method end" })
			vim.keymap.set("n", "[m", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Previous method start" })
			vim.keymap.set("n", "[M", function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
			end, { desc = "Previous method end" })
		end
	}
}
