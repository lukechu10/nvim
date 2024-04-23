local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = ls.extend_decorator.apply(require("luasnip.extras.fmt").fmt, { delimiters = "<>" })

return {
	s(
		"beg",
		fmt([[
			\begin{<>}
				<>
			\end{<>}
		]], { i(1), i(0), rep(1) })
	),
	s(
		"mk",
		fmt([[$<>$]], { i(1) })
	),
	s(
		"dm",
		fmt([[
			\[
				<>
			.\]
		]], { i(1) })
	),
}
