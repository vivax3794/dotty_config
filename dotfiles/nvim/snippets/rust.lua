local ls = require("luasnip")
local s  = ls.snippet
local t  = ls.text_node
local i  = ls.insert_node
local f  = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- function same(index)
--     function foo(args)
--         return args[1]
--     end
--     return f(foo, {index})
-- end
local same = function(index)
  return f(function(arg)
    return arg[1]
  end, {index})
end

ls.add_snippets("rust", {
  s("test_mod", {
      t({"#[cfg(test)]", "mod tests {", "\tuse super::*;", "\t"}),
        i(0),
        t({"", "}"})
  }),
    s("test", {
        t({"#[test]", "fn "}),
        i(1, "test_name"),
        t({"() {", "\t"}),
        i(0, "test_body"),
        t({"", "}"})
    }),

    s("struct", {
        t("#[derive("),
        i(2, "traits"),
        t({")]", "struct "}),
        i(1, "StructName"),
        t({" {", "\t"}),
        i(0, "fields"),
        t({"", "}"})
    }),
    -- s("generic", {
    --     t("struct "),
    --     i(1, "StructName"),
    --     t("<"),
    --     i(2, "T"),
    --     t({"> {", "\t"}),
    --     i(3, "fields"),
    --     t({"", "}", "", "impl<"})
    --     same(2)
    --     t("> "),
    --     same(1),
    --     t("<")
    --     same(2)
    --     t({"> {", "\t"}),
    --     i(0, "methods"),
    --     t({"", "}"})
    -- })
    s("test_same", fmt(
        [[{} = {}; {}]],
        {
            i(1, "test_name"),
            same(1),
            i(0, "test_body")
        }
    ))
})

