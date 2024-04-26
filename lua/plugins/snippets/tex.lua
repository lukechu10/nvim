local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

-- Higher ordered function which creates a lambda that extracts the x-th regex capture.
local capture = function(x)
	return function(_, snip)
		return snip.captures[x]
	end
end

-- Credit: https://github.com/evesdropper/luasnip-latex-snippets.nvim
local generate_fraction = function(_, snip)
	local stripped = snip.captures[1]
	local depth = 0
	local j = #stripped
	while true do
		local c = stripped:sub(j, j)
		if c == "(" then
			depth = depth + 1
		elseif c == ")" then
			depth = depth - 1
		end
		if depth == 0 then
			break
		end
		j = j - 1
	end
	return sn(nil,
		fmta([[
        <>\frac{<>}{<>}
        ]],
			{ t(stripped:sub(1, j - 1)), t(stripped:sub(j)), i(1) }))
end

local in_math = function()
	return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

local in_comment = function()
	return vim.fn['vimtex#syntax#in_comment']() == 1
end

-- general env function
local function env(name)
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end

function in_preamble()
	return not env("document")
end

function in_text()
	return env("document") and not in_math()
end

local snippets = {
	s("beg", fmta(
		[[
			\begin{<>}
				<>
			\end{<>}
		]],
		{ i(1), i(0), rep(1) }
	), { condition = in_text }),
	s("ali", fmta(
		[[
			\begin{align}
				<>
			\end{align}
		]],
		{ i(1) }
	), { condition = in_text }),
	s("ali*", fmta(
		[[
			\begin{align*}
				<>
			\end{align*}
		]],
		{ i(1) }
	), { condition = in_text }),
}
local autosnippets = {
	----------------
	-- Text snippets
	----------------
	s("bf", fmta(
		[[\textbf{<>}]],
		{ i(1) }
	), { condition = in_text }),
	s({ trig = "mm", wordTrig = true }, fmta(
		[[$<>$]], { i(1) }
	), { condition = in_text }),
	s("nn", fmta(
		[[
			\[
				<>
			.\]
		]], { i(1) }
	), { condition = in_text }),

	----------------
	-- Math snippets
	----------------

	-- Superscripts
	s({ trig = "td", wordTrig = false }, fmta(
		[[^{<>}]],
		{ i(1) }
	), { conditions = in_math }),
	s({ trig = "sr", wordTrig = false }, t("^2"), { condition = in_math }),
	s({ trig = "cb", wordTrig = false }, t("^3"), { condition = in_math }),

	-- Exponential
	s({ trig = "ee", wordTrig = false }, fmta(
		[[e^{<>}]],
		{ i(1) }
	), { condition = in_math }),

	-- Subscript
	s({ trig = "(%a)(%d)", regTrig = true, name = "auto subscript" }, fmta(
		[[<>_<>]],
		{ f(capture(1)), f(capture(2)) }
	), { condition = in_math }),
	s({ trig = "(%a)_(%d%d)", regTrig = true, name = "auto subscript 2" }, fmta(
		[[<>_{<><>}<>]],
		{ f(capture(1)), f(capture(2)), i(1), i(0) }
	), { condition = in_math }),

	-- Fractions
	s({ trig = "//", name = "fraction" }, fmta(
		[[\frac{<>}{<>}]],
		{ i(1), i(2) }
	), { condition = in_math }),

	-- FIXME: problem with jsregexp on Windows
	s({
		trig = "((\\d+)|(\\d*)(\\\\)?([A-Za-z]+)((\\^|_)(\\{\\d+\\}|\\d))*)\\/",
		name = 'fraction',
		desc =
		'auto fraction 1',
		trigEngine = "ecma"
	}, fmta(
		[[\frac{<>}{<>}]], { f(capture(1)), i(1) }
	), { condition = in_math }),
	s({ trig = '(^.*\\))/', name = 'fraction', desc = 'auto fraction 2', trigEngine = "ecma" },
		{ d(1, generate_fraction) },
		{ condition = in_math }),
	-- s({ trig = "([%a%d\\_]+)/", wordTrig = true, regTrig = true }, fmta(
	-- 	[[\frac{<>}{<>}]],
	-- 	{ f(capture(1)), i(1) }
	-- ), { condition = in_math }),

	-- Calculus
	s("int", t("\\int"), { conditions = in_math }),

	-- Postfix snippets
	s({ trig = "(%a),,", name = "vector \\vb", wordTrig = false, regTrig = true }, fmta(
		[[\vb{<>}]],
		{ f(capture(1)) }
	), { condition = in_math }),
	s({ trig = "(%a)hat", name = "\\hat", regTrig = true }, fmta(
		[[\hat{<>}]],
		{ f(capture(1)) }
	), { condition = in_math }),
	s({ trig = "(%a),hat", name = "unit vector \\vb{\\hat }", regTrig = true }, fmta(
		[[\vb{\hat{<>}}]],
		{ f(capture(1)) }
	), { condition = in_math }),

	-- Bra-ket notation
	-- Special handling: q inside a braket is autoamtically converted to \psi
	s({ trig = "<([%a_]+)|", name = "bra", wordTrig = false, regTrig = true }, fmta(
		[[\bra{<>}]],
		{ f(function(_, snips)
			if snips.captures[1] == "q" then return "\\psi" else return snips.captures[1] end
		end) }
	), { condition = in_math }),
	s({ trig = "|([%a_]+)>", name = "ket", wordTrig = false, regTrig = true }, fmta(
		[[\ket{<>}]],
		{ f(function(_, snips)
			if snips.captures[1] == "q" then return "\\psi" else return snips.captures[1] end
		end) }
	), { condition = in_math }),
	s({ trig = "\\bra{(.*)}([%a_]+)>", name = "braket", wordTrig = false, regTrig = true }, fmta(
		[[\braket{<>}{<>}]],
		{ f(capture(1)), f(function(_, snips)
			if snips.captures[2] == "q" then return "\\psi" else return snips.captures[2] end
		end) }
	), { condition = in_math }),

	-- Abbreviations
	s("ooo", t("\\infty"), { condition = in_math }),
}

-- Commands with auto_backslash.
local auto_backslash_specs = {
	-- Trig functions
	"arcsin",
	"sin",
	"arccos",
	"cos",
	"arctan",
	"tan",
	"cot",
	"csc",
	"sec",
	-- Other functions
	"log",
	"ln",
	"exp",
	-- Misc
	"sup",
	"inf",
	"det",
	"max",
	"min",
	"argmax",
	"argmin",
	"deg",
	"angle",
}
local auto_backslash_snippets = {}
for _, v in ipairs(auto_backslash_specs) do
	table.insert(auto_backslash_snippets, s({ trig = v }, t("\\" .. v), { condition = in_math }))
end
vim.list_extend(autosnippets, auto_backslash_snippets)

local greek_spec = {
	-- Greek letters
	"alpha",
	"beta",
	"gamma",
	"Gamma",
	"delta",
	"Delta",
	"epsilon",
	"varepsilon",
	"zeta",
	"eta",
	"theta",
	"Theta",
	"iota",
	"kappa",
	"lambda",
	"Lambda",
	"mu",
	"nu",
	"xi",
	"pi",
	"rho",
	"sigma",
	"Sigma",
	"tau",
	"upsilon",
	"phi",
	"Phi",
	"varphi",
	"chi",
	"psi",
	"Psi",
	"omega",
	"Omega",
}
local greek_snippets = {}
for _, v in ipairs(greek_spec) do
	table.insert(greek_snippets,
		s({ trig = "(%d*)" .. v, wordTrig = true, regTrig = true }, { f(capture(1)), t("\\" .. v) },
			{ condition = in_math }))
end
vim.list_extend(autosnippets, greek_snippets)

local symbol_specs = {
	{ trig = "!=",           command = "\\neq" },
	{ trig = "<=",           command = "\\leq" },
	{ trig = ">=",           command = "\\geq" },
	{ trig = "<<",           command = "\\ll" },
	{ trig = ">>",           command = "\\gg" },
	{ trig = "=>",           command = "\\implies" },
	{ trig = "~~",           command = "\\sim" },
	{ trig = "~=",           command = "\\approx" },
	{ trig = "==",           command = "\\equiv" },
	{ trig = ":=",           command = "\\definedas" },
	{ trig = "**",           command = "\\cdot" },
	{ trig = "xx",           command = "\\times" },

	{ trig = "NN",           command = "\\mathbb{N}" },
	{ trig = "ZZ",           command = "\\mathbb{Z}" },
	{ trig = "QQ",           command = "\\mathbb{Q}" },
	{ trig = "RR",           command = "\\mathbb{R}" },
	{ trig = "CC",           command = "\\mathbb{C}" },

	{ trig = "inn",          command = "\\in" },
	{ trig = "not in",       command = "\\notin" },
	{ trig = "subset",       command = "\\subset" },
	{ trig = "subseteq",     command = "\\subseteq" },
	{ trig = "supset",       command = "\\supset" },
	{ trig = "supseteq",     command = "\\supseteq" },
	{ trig = "cup",          command = "\\cup" },
	{ trig = "cap",          command = "\\cap" },
	{ trig = "union",        command = "\\bigcup" },
	{ trig = "intersection", command = "\\bigcap" },
	{ trig = "empty",        command = "\\emptyset" },
	{ trig = "forall",       command = "\\forall" },
	{ trig = "exists",       command = "\\exists" },
	{ trig = "nabla",        command = "\\nabla" },
	{ trig = "grad",         command = "\\nabla" },
	{ trig = "div",          command = "\\nabla \\cdot" },
	{ trig = "curl",         command = "\\nabla \\times" },
	{ trig = "partial",      command = "\\partial" },
	{ trig = "inf",          command = "\\inf" },
	{ trig = "sup",          command = "\\sup" },
	{ trig = "lim",          command = "\\lim" },
	{ trig = "liminf",       command = "\\liminf" },
	{ trig = "limsup",       command = "\\limsup" },
	{ trig = "to",           command = "\\to" },
	{ trig = "->",           command = "\\to" },
	{ trig = "mapsto",       command = "\\mapsto" },
	{ trig = "infty",        command = "\\infty" },
	{ trig = "pm",           command = "\\pm" },
	{ trig = "mp",           command = "\\mp" },
	{ trig = "times",        command = "\\times" },
	{ trig = "cdot",         command = "\\cdot" },
	{ trig = "cp",           command = "\\cross" },
	{ trig = "div",          command = "\\div" },

	{ trig = "dag",          command = "\\dagger" },
}
local symbol_snippets = {}
for _, v in ipairs(symbol_specs) do
	-- Add space after the command.
	table.insert(symbol_snippets, s({ trig = v.trig }, t(v.command .. " "), { condition = in_math }))
end
vim.list_extend(autosnippets, symbol_snippets)

return snippets, autosnippets
