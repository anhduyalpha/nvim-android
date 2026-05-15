-- plugins/which-key.lua — Which-key: classic layout, auto-fit to content
-- Separated from editor.lua for clarity

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    local wk = require("which-key")
    -- Apply classic preset first, then override for auto-fit
    wk.setup({
      preset = "classic",
      plugins = { spelling = { enabled = false } },
      delay = function(ctx)
        return 0
      end,
      -- Override layout: auto-fit to content
      layout = {
        width = { min = 0, max = 100 },
        height = { min = 0, max = 50 },
        spacing = 0,
        align = "left",
      },
      win = {
        border = "rounded",
        padding = { 0, 1 },
        title = true,
        title_pos = "center",
      },
      sort = { "order", "group", "alphanum", "mod" },
      show_help = true,
      show_keys = true,
      expand = 0,
    })
    wk.add({
      { "<leader>b", group = " Buffer" },
      { "<leader>c", group = " Code" },
      { "<leader>d", group = " Debug" },
      { "<leader>f", group = " Find" },
      { "<leader>g", group = " Git" },
      { "<leader>r", group = " 󰐎 Run" },
      { "<leader>s", group = " Search" },
      { "<leader>t", group = " Terminal" },
      { "<leader>u", group = " UI" },
      { "<leader>w", group = " 󰖲 Window" },
      { "<leader>x", group = " Quickfix" },
      { "<leader><tab>", group = " Tab" },
    })
  end,
}
