-- plugins/navigation.lua — Telescope, file explorer, quick jump, which-key
-- Core navigation plugins optimized for small screens and touch

local features = vim.g.nvim_android_features or {}

return {
  -- ── Telescope (fuzzy finder) ───────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "Grep string" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>fo", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>fp", "<cmd>Telescope registers<cr>", desc = "Registers" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        -- Performance: limit results
        file_ignore_patterns = { "node_modules", ".git/", "target/", "__pycache__" },
        results_limit = 50,  -- Limit for Android
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-q>"] = "send_to_qflist",
            ["<C-l"] = "complete_tag",
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = { "rg", "--files", "--hidden", "--glob", "!.git/" },
        },
        live_grep = {
          additional_args = { "--hidden" },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      -- Load fzf extension for faster sorting
      pcall(telescope.load_extension, "fzf")
    end,
  },

  -- ── File Explorer: Neo-tree ────────────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File explorer" },
      { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal in explorer" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      sources = { "filesystem", "buffers", "git_status" },
      window = {
        position = "left",
        width = 30,
        mapping_options = { noremap = true, nowait = true },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_by_name = { "node_modules", ".git", "__pycache__", ".mypy_cache" },
        },
      },
      default_component_configs = {
        indent = { with_expanders = true },
        git_status = {
          symbols = {
            added = "✚",
            modified = "",
            deleted = "✖",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
      },
    },
  },

  -- ── Flash (quick jump anywhere on screen) ──────────────
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    enabled = features.flash ~= false,
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = {
        multi_window = false,
      },
      jump = {
        nohlsearch = true,
        autojump = false,
      },
      modes = {
        search = { enabled = false },
        char = { enabled = false },
      },
    },
    keys = {
      { "s", function() require("flash").jump() end, desc = "Flash jump" },
      { "S", function() require("flash").treesitter() end, desc = "Flash treesitter" },
    },
  },
}
