return {
	{
		"mrcjkb/rustaceanvim",
		version = "*",
		lazy = false,
		ft = { "rust" },
	},
	{
		"saecki/crates.nvim",
		version = "*",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufRead Cargo.toml",
		config = function()
			require("crates").setup()
		end
	}
}
