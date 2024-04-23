vim.opt_local.spell = true
vim.opt_local.spelllang = "en_us"
-- vim.opt_local.conceallevel = 2

-- <C-l> to quickly fix spelling
vim.cmd [[inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u]]
