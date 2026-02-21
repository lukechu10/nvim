vim.opt_local.shiftwidth = 2
vim.opt_local.smarttab = true

vim.opt_local.spell = true
vim.opt_local.spelllang = "en_gb"

-- <C-l> to quickly fix spelling
vim.cmd [[inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u]]

vim.opt_local.commentstring = "// %s"

vim.keymap.set("n", "<leader>cp", "<cmd>TypstPreviewToggle<cr>", { buffer = true, desc = "Toggle typst preview" })
