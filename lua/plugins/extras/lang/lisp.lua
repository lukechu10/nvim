vim.filetype.add({
	extension = {
		risp = "scheme",
		krsp = "scheme",
	}
})

return {
	{
		"eraserhd/parinfer-rust",
		build = "cargo build --release",
	}
}
