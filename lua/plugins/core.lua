return {
	"tpope/vim-repeat",

	{
		"numToStr/FTerm.nvim",
		keys = {
			{ "<A-i>", "<cmd>lua require('FTerm').toggle()<cr>",            desc = "Toggle FTerm" },
			{ "<A-i>", "<C-\\><C-n><cmd>lua require('FTerm').toggle()<cr>", mode = "t",           desc = "Toggle FTerm" },
		},
		config = function()
			function _G.open_in_normal_window(cmd)
				local cursor = vim.api.nvim_win_get_cursor(0)
				local bufnr = vim.api.nvim_get_current_buf()
				local f = vim.fn.findfile(vim.fn.expand("<cfile>"))
				if f ~= "" and vim.api.nvim_win_get_config(vim.fn.win_getid()).anchor ~= "" then
					require("FTerm").close()
					vim.api.nvim_win_set_buf(0, bufnr)
					vim.api.nvim_win_set_cursor(0, cursor)
					vim.cmd("normal! " .. cmd)
				end
			end

			vim.cmd [[
				autocmd FileType FTerm nnoremap <silent><buffer> gf <cmd>lua open_in_normal_window("gf")<cr>
				autocmd FileType FTerm nnoremap <silent><buffer> gF <cmd>lua open_in_normal_window("gF")<cr>
			]]

			require("FTerm").setup({
				auto_close = false,
				cmd = vim.opt.shell._value,
			})
		end,
	}
}
