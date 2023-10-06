local ls = require "luasnip"

local inline_math = ls.s({ trig = "\\(", wordTrig = true }, {
    ls.t("\\("),
    ls.i(1, ""),
    ls.t("\\)")
})
inline_math.autosnippets = { ["\\("] = true }
local display_math = ls.s({ trig = "\\[", wordTrig = true }, {
    ls.t("\\["),
    ls.i(1, ""),
    ls.t("\\]")
})
display_math.autosnippets = { ["\\["] = true }

return {
    inline_math,
    display_math
}
