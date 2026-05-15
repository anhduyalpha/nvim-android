-- plugins/editor.lua — Editor enhancement plugins
-- mini.nvim collection + other lightweight editor improvements

local features = vim.g.nvim_android_features or {}

return {
  -- ── mini.nvim collection (lightweight Swiss army knife) ──
  {
    "echasnovski/mini.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- Auto brackets/pairs
      require("mini.pairs").setup()

      -- Surround text objects (sa/sd/sr to add/delete/replace)
      require("mini.surround").setup({
        mappings = {
          add = "sa",
          delete = "sd",
          find = "sf",
          find_left = "sF",
          highlight = "sh",
          replace = "sr",
        },
      })

      -- Comment (gc to comment/uncomment)
      require("mini.comment").setup()

      -- Better text objects (iq/aq for quotes, ia/aa for arguments, etc.)
      require("mini.ai").setup({ n_lines = 500 })

      -- Move lines/blocks (M-h/j/k/l in visual mode)
      require("mini.move").setup({
        mappings = {
          left = "<M-h>",
          right = "<M-l>",
          down = "<M-j>",
          up = "<M-k>",
          line_left = "<M-h>",
          line_right = "<M-l>",
          line_down = "<M-j>",
          line_up = "<M-k>",
        },
      })
    end,
  },

  -- ── Multi-cursor ───────────────────────────────────────
  {
    "mg979/vim-visual-multi",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Select All"] = "<C-S-n>",
      }
    end,
  },

  -- ── Better substitution ────────────────────────────────
  {
    "gbprod/substitute.nvim",
    keys = {
      { "sx", function() require("substitute").operator() end, desc = "Substitute" },
      { "sxx", function() require("substitute").line() end, desc = "Substitute line" },
      { "X", function() require("substitute").visual() end, mode = "x", desc = "Substitute visual" },
    },
    opts = {},
  },

  -- ── TODO/FIXME/NOTE highlights ─────────────────────────
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = false,  -- No signs to save column space
      highlight = {
        pattern = { [[.*<(KEYWORDS)\s*:]] },
        before = "",
        keyword = "wide",
        after = "fg",
      },
      search = {
        pattern = [[\b(KEYWORDS):]],
      },
    },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
    },
  },

  -- ── Maximize splits toggle ─────────────────────────────
  {
    "szw/vim-maximizer",
    keys = {
      { "<leader>wm", "<cmd>MaximizerToggle<cr>", desc = "Maximize toggle" },
    },
  },

  -- ── Which-key (shows keybinding hints — critical for mobile) ──
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = { enabled = false } },
      window = { border = "rounded" },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>d"] = { name = "+debug/diagnostic" },
        ["<leader>f"] = { name = "+find/file" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>r"] = { name = "+run" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>t"] = { name = "+terminal" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+window" },
        ["<leader>x"] = { name = "+quickfix" },
        ["<leader><tab>"] = { name = "+tab" },
      })
    end,
  },

  -- ── Trouble (diagnostics list) ─────────────────────────
  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location list" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix list" },
    },
    opts = {
      use_diagnostic_signs = true,
      action_keys = { close = "q" },
    },
  },
}
