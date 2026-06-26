return {
	"tpope/vim-repeat",

	{
		"numToStr/FTerm.nvim",
		config = function()
			local fterm = require("FTerm")

			function _G.open_in_normal_window(cmd)
				local cursor = vim.api.nvim_win_get_cursor(0)
				local bufnr = vim.api.nvim_get_current_buf()
				local f = vim.fn.findfile(vim.fn.expand("<cfile>"))
				if f ~= "" and vim.api.nvim_win_get_config(vim.fn.win_getid()).anchor ~= "" then
					fterm.close()
					vim.api.nvim_win_set_buf(0, bufnr)
					vim.api.nvim_win_set_cursor(0, cursor)
					vim.cmd("normal! " .. cmd)
				end
			end

			vim.cmd [[
				autocmd FileType FTerm nnoremap <silent><buffer> gf <cmd>lua open_in_normal_window("gf")<cr>
				autocmd FileType FTerm nnoremap <silent><buffer> gF <cmd>lua open_in_normal_window("gF")<cr>
			]]

			local shell_cmd = vim.opt.shell._value
			--- @type Term[]
			local terminals = {}
			for i = 0, 9 do
				terminals[i] = fterm:new({
					ft = "FTerm",
					cmd = shell_cmd,
				})
			end
			for i = 0, 9 do
				vim.keymap.set({ "n", "t" }, "<A-" .. i .. ">", function()
					-- Close all other FTerm terminals if they are open
					for j = 0, 9 do
						if j ~= i then
							terminals[j]:close()
						end
					end
					terminals[i]:toggle()
				end, { desc = "Toggle terminal #" .. i })
			end

			-- Close all FTerm terminals if A-i is pressed
			-- If no terminals are open, open terminal #1
			vim.keymap.set({ "n", "t" }, "<A-i>", function()
				-- Check if one of the terminals is open
				local bufnr = vim.api.nvim_get_current_buf()
				local close_all = false
				for i = 0, 9 do
					if terminals[i].buf == bufnr then
						close_all = true
					end
				end

				if close_all then
					for i = 0, 9 do
						terminals[i]:close()
					end
				else
					terminals[1]:toggle()
				end
			end, { desc = "Close all terminals" })
		end,
	},
}
