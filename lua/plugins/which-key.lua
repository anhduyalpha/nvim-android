-- plugins/which-key.lua — Which-key: classic layout, auto-fit to content
-- Separated from editor.lua for clarity

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "classic",
    plugins = { spelling = { enabled = false } },
    -- Instant popup — no delay
    delay = function(ctx)
      return 0
    end,
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
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
