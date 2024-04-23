return {
	{
		"lervag/vimtex",
		tag = "v2.15",
		config = function()
			vim.cmd [[
				filetype plugin indent on
				let g:vimtex_compiler_latexmk = {'executable' : 'latexmk.exe'}
			]]
		end
	}
}
