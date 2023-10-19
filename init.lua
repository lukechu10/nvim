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

vim.cmd [[
	augroup LineNumbers
		autocmd!
		autocmd TermEnter * setlocal nonu nornu
		autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set rnu   | endif
		autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set nornu | endif
	augroup END
]]

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("AutoFmt", { clear = true }),
	callback = function()
		vim.lsp.buf.format()
	end
})

vim.g.clipboard = {
	name = "WslClipboard",
	copy = {
		["+"] = 'clip.exe',
		["*"] = 'clip.exe',
	},
	paste = {
		["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
	},
	cache_enabled = 0,
}
