return {
	{
		"lervag/vimtex",
		version = "*",
		ft = { "tex" },
		init = function()
			vim.cmd [[ filetype plugin indent on ]]
			local latexmk = vim.fn.has("win32") == 1 and "latexmk.exe" or "latexmk"
			vim.g.vimtex_compiler_latexmk = {
				executable = latexmk,
				options = {
					"-verbose",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
					"-shell-escape"
				}
			}
			vim.g.vimtex_quickfix_mode = 0
		end
	},
}
