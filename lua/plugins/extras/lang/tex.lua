return {
	{
		"lervag/vimtex",
		tag = "v2.15",
		ft = { "tex" },
		config = function()
			vim.cmd [[ filetype plugin indent on ]]
			vim.g.vimtex_compiler_latexmk = {
				executable = "latexmk.exe"
			}

			-- Enable spell checking and conceal automatically in tex files
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
				pattern = { "*.tex" },
				group = vim.api.nvim_create_augroup("TexSettings", { clear = true }),
				callback = function()
					vim.opt_local.spell = true
					vim.opt_local.spelllang = "en_us"
					vim.opt_local.conceallevel = 2
				end
			})
		end
	}
}
