return {
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
		build = function() require("typst-preview").update() end,
		opts = {
			dependencies_bin = {
				["tinymist"] = "tinymist",
				["websocat"] = nil,
			}
		}
	}
}
