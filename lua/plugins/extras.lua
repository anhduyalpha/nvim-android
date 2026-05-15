-- plugins/extras.lua — Optional nice-to-have plugins (toggleable)
-- Each plugin can be enabled/disabled via vim.g.nvim_android_features

local features = vim.g.nvim_android_features or {}

return {
  -- ── Copilot (AI completion — heavy, default OFF) ───────
  {
    "zbirenbaum/copilot.lua",
    enabled = features.copilot == true,
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = true, auto_trigger = true },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  -- ── Harpoon (quick file navigation — light, default ON) ──
  {
    "ThePrimeagen/harpoon",
    enabled = features.harpoon ~= false,
    event = "VeryLazy",
    keys = {
      { "<leader>ha", function() require("harpoon.mark").add_file() end, desc = "Harpoon add file" },
      { "<leader>hh", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon menu" },
      { "<leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon file 1" },
      { "<leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon file 2" },
      { "<leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon file 3" },
      { "<leader>4", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon file 4" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- ── Zen Mode (distraction-free — light, default ON) ────
  {
    "folke/zen-mode.nvim",
    enabled = features.zen_mode ~= false,
    cmd = "ZenMode",
    keys = {
      { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Zen mode" },
    },
    opts = {
      window = {
        width = 80,
        options = {},
      },
      plugins = {
        gitsigns = { enabled = false },
        tmux = { enabled = false },
        kitty = { enabled = false },
      },
    },
  },

  -- ── Undotree (undo history visualizer — light, default ON) ──
  {
    "mbbill/undotree",
    enabled = features.undotree ~= false,
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree" },
    },
  },

  -- ── Vim-fugitive (git commands — light, default ON) ────
  {
    "tpope/vim-fugitive",
    enabled = true,
    cmd = { "Git", "G", "Gwrite", "Gread", "Gdiffsplit", "Glog", "Ggrep" },
    keys = {
      { "<leader>gG", "<cmd>Git<cr>", desc = "Fugitive" },
    },
  },

  -- ── Obsidian (note taking — heavy, default OFF) ────────
  {
    "epwalsh/obsidian.nvim",
    enabled = features.obsidian == true,
    version = "*",
    event = { "BufReadPre " .. vim.fn.expand("~") .. "/obsidian-vault/**/*.md" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      dir = vim.fn.expand("~") .. "/obsidian-vault",
    },
  },

  -- ── Leetbuddy (leetcode — default OFF) ─────────────────
  {
    "Dhanus3133/LeetBuddy.nvim",
    enabled = features.leetbuddy == true,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    keys = {
      { "<leader>lq", "<cmd>LBQuestions<cr>", desc = "Leetcode questions" },
      { "<leader>ll", "<cmd>LBQuestion<cr>", desc = "Leetcode current" },
      { "<leader>lr", "<cmd>LBReset<cr>", desc = "Leetcode reset" },
      { "<leader>lt", "<cmd>LBTest<cr>", desc = "Leetcode test" },
      { "<leader>ls", "<cmd>LBSubmit<cr>", desc = "Leetcode submit" },
    },
    config = true,
  },

  -- ── Noice (UI heavy — default OFF on Android) ──────────
  {
    "folke/noice.nvim",
    enabled = features.noice == true,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = { override = { ["vim.lsp.util.convert_input_to_markdown_lines"] = true } },
      presets = { bottom_search = true, command_palette = true, long_message_to_split = true },
    },
  },
}
