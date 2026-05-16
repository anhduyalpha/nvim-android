-- ╭────────────────────────────────────────────────────────────────╮
-- │  formatting.lua — Code formatting (conform.nvim)               │
-- ╰────────────────────────────────────────────────────────────────╯

return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      formatters = {
        stylua = { command = "stylua" },
        black = { command = "black" },
        ["clang-format"] = {
          command = "clang-format",
          prepend_args = {},
        },
      },
    },
  },
}
