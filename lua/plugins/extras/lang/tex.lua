return {
	{
		"lervag/vimtex",
		tag = "v2.15",
		ft = { "tex" },
		init = function()
			vim.cmd [[ filetype plugin indent on ]]
			if vim.fn.has("win32") == 1 then
				vim.g.vimtex_compiler_latexmk = {
					executable = "latexmk.exe"
				}
			else
				vim.g.vimtex_compiler_latexmk = {
					executable = "latexmk"
				}
			end
			vim.g.vimtex_quickfix_mode = 0
		end
	}
}
