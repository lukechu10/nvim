return {
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
		build = function() require("typst-preview").update() end,
		opts = {
			partial_rendering = true,
			dependencies_bin = {
				["tinymist"] = "tinymist",
				["websocat"] = nil,
			}
		}
	}
}
