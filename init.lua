vim.cmd [[set guifont=CaskaydiaCove\ Nerd\ Font:h10]]
vim.opt.shell = "nu"

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

-- Disable netrw because we have nvim-tree.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins.extras.lang" }
	}
})

vim.o.background = "dark"
vim.cmd [[colorscheme gruvbox]]

vim.cmd [[set tabstop=4]]
vim.cmd [[set shiftwidth=4]]

vim.cmd [[set scrolloff=4]]

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

vim.api.nvim_create_autocmd({ "TermOpen" }, {
	group = vim.api.nvim_create_augroup("HideNumberInTerm", { clear = true }),
	callback = function()
		vim.wo.number = false
		vim.wo.relativenumber = false
	end
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("AutoFmt", { clear = true }),
	callback = function()
		vim.lsp.buf.format()
	end
})
