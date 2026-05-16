-- ╭────────────────────────────────────────────────────────────────╮
-- │  cpp.lua — C++ specific plugins (from nvim_conf)               │
-- ╰────────────────────────────────────────────────────────────────╯

return {
  {
    "p00f/clangd_extensions.nvim",
    optional = true,
    opts = {
      extensions = {
        inlay_hints = {
          inline = false,
        },
        ast = {
          role_icons = {
            type = "",
            declaration = "",
            expression = "",
            specifier = "",
            statement = "",
            ["template argument"] = "",
          },
          kind_icons = {
            Compound = "",
            Recovery = "",
            TranslationUnit = "",
            PackExpansion = "",
            TemplateTypeParm = "",
            TemplateTemplateParm = "",
            TemplateParamObject = "",
          },
        },
      },
    },
  },
}
