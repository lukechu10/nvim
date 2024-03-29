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

vim.cmd [[
set wrap
set linebreak
]]

vim.cmd [[set spelllang=en]]
vim.cmd [[set spelloptions=camel]]

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

if vim.fn.has("wsl") == 1 then
	if vim.fn.executable("wl-copy") == 0 then
		print("wl-clipboard is not installed, clipboard integration will not work")
	else
		vim.g.clipboard = {
			name = "wl-clipboard (WSL)",
			copy = {
				["+"] = "wl-copy --type text/plain",
				["*"] = "wl-copy --type text/plain --primary"
			},
			paste = {
				["+"] = function()
					return vim.fn.systemlist('wl-paste --no-newline|sed -e "s/\r$//"', { '' }, 1) -- '1' keeps empty lines
				end,
				["*"] = function()
					return vim.fn.systemlist('wl-paste --primary --no-newline|sed -e "s/\r$//"', { '' }, 1)
				end,
			}
		}
	end
end

vim.cmd [[
	aunmenu PopUp.How-to\ disable\ mouse
	aunmenu PopUp.-1-
]]
