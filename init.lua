local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
		lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ','

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins.extras.lang" }
	}
})

vim.cmd [[colorscheme tokyonight]]

vim.cmd [[set tabstop=4]]

vim.wo.number = true
vim.wo.relativenumber = true
local id = vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
	group = id,
	callback = function()
		if vim.wo.number == true and vim.api.nvim_get_mode() ~= "i" then
			vim.wo.relativenumber = true
		end
	end
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
	group = id,
	callback = function()
		if vim.wo.number == true then
			vim.wo.relativenumber = false
		end
	end
})
