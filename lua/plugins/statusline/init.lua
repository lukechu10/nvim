-- Count number of words in current buffer for display in lualine.
local function getWords()
	local words = vim.fn.wordcount().words
	if words == 1 then
		return words .. " word"
	else
		return words .. " words"
	end
end

-- Check if current buffer is one of text,md,markdown,tex.
local function isTextBuffer()
	local ft = vim.bo.filetype
	return ft == "text" or ft == "md" or ft == "markdown" or ft == "tex"
end

return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			theme = "auto",
			sections = {
				lualine_a = { 'mode' },
				lualine_b = { 'branch', 'diff', 'diagnostics' },
				lualine_c = { 'filename' },
				lualine_x = { { getWords, cond = isTextBuffer }, 'encoding', 'fileformat', 'filetype' },
				lualine_y = { 'progress' },
				lualine_z = { 'location' }
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { 'filename' },
				lualine_x = { 'location' },
				lualine_y = {},
				lualine_z = {}
			},
			extensions = { "nvim-tree" }
		}
	},

	{
		"akinsho/bufferline.nvim",
		event = "VimEnter",
		opts = {
			options = {
				diagnostics = "nvim_lsp"
			}
		}
	},
}
