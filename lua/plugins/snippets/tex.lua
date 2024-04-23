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

return {
	s("beg", fmta(
		[[
			\begin{<>}
				<>
			\end{<>}
		]],
		{ i(1), i(0), rep(1) }
	))
}, {
	s(
		{ trig = "mm", wordTrig = true },
		fmta([[$<>$]], { i(1) })
	),
	s(
		"nn",
		fmta([[
			\[
				<>
			.\]
		]], { i(1) })
	),

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

	s({
		trig = "((\\d+)|(\\d*)(\\\\)?([A-Za-z]+)((\\^|_)(\\{\\d+\\}|\\d))*)\\/",
		name = 'fraction',
		dscr =
		'auto fraction 1',
		trigEngine = "ecma"
	}, fmta(
		[[\frac{<>}{<>}<>]], { f(capture(1)), i(1), i(0) }
	), { condition = in_math }),
	s({ trig = '(^.*\\))/', name = 'fraction', dscr = 'auto fraction 2', trigEngine = "ecma" },
		{ d(1, generate_fraction) },
		{ condition = in_math }),

	-- Calculus
	s("int", t("\\int")),

	-- Postfix snippets
	s({ trig = "(%a),.", wordTrig = false, regTrig = true }, fmta(
		[[\vec{<>}]],
		{ f(capture(1)) }
	), { condition = in_math }),
	s({ trig = "(%a).,", wordTrig = false, regTrig = true }, fmta(
		[[\vec{<>}]],
		{ f(capture(1)) }
	), { condition = in_math }),

	-- Bra-ket notation

	-- Abbreviations
	s("ooo", t("\\infty")),
}
