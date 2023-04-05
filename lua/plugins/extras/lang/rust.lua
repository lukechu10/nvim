return {
	{
		"saecki/crates.nvim",
		version = "0.3.*",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufRead Cargo.toml",
		config = function()
			require("crates").setup {
				null_ls = {
					enabled = true,
					name = "crates.nvim",
				},
			}
		end
	}
}
