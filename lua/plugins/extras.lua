-- plugins/extras.lua — Optional nice-to-have plugins (toggleable)
-- Each plugin can be enabled/disabled via vim.g.nvim_android_features

local features = vim.g.nvim_android_features or {}

return {
  -- ── Snacks.nvim — Disable heavy features on Android ────
  {
    "folke/snacks.nvim",
    opts = {
      -- Disable image rendering (needs kitty graphics protocol, ImageMagick, Ghostscript)
      image = { enabled = false },
      -- Disable notifier on Android (use nvim-notify instead, lighter)
      notifier = { enabled = false },
      -- Keep picker functional
      picker = { enabled = true },
      -- Keep input functional
      input = { enabled = true },
      -- Disable indent (we use indent-blankline)
      indent = { enabled = false },
      -- Disable scope (not needed)
      scope = { enabled = false },
    },
  },

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

  -- ── Noice — Beautiful cmdline/messages/search UI ───────
  {
    "folke/noice.nvim",
    enabled = features.noice ~= false,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      -- LSP: hover/rename/signature as floating markdown
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
        hover = { enabled = true, silent = true },
        signature = { enabled = true },
      },
      -- Presets: enable beautiful UI components
      presets = {
        bottom_search = false,         -- Use popup search instead of bottom bar
        command_palette = true,        -- Centered command palette (like VSCode)
        long_message_to_split = true,  -- Long messages go to split
        lsp_doc_border = true,         -- Border on LSP hover docs
      },
      -- Cmdline: popup style for : commands
      cmdline = {
        view = "cmdline_popup",        -- Show : command in centered popup
        format = {
          cmdline = { pattern = "^:", icon = " ", lang = "vim", title = " Command " },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex", title = " Search " },
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex", title = " Search " },
          filter = { pattern = "^:%s*!", icon = " ", title = " Shell " },
          lua = { pattern = "^:%s*lua%s+", icon = " ", lang = "lua", title = " Lua " },
          help = { pattern = "^:%s*he?l?p?%s+", icon = " " },
          input = { view = "cmdline_input", icon = " " },
        },
      },
      -- Messages: route through noice for pretty display
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
      },
      -- Popupmenu: beautiful completion menu for : commands
      popupmenu = {
        enabled = true,
        backend = "nui",              -- Use nui for pretty popupmenu
      },
      -- Routes: customize how different message types are displayed
      routes = {
        {
          view = "mini",
          filter = { event = "msg_show", kind = "", find = "written" },
        },
        {
          view = "mini",
          filter = { event = "msg_show", kind = "search_count" },
        },
        {
          view = "mini",
          filter = { event = "msg_show", find = "Pattern not found" },
        },
        {
          view = "notify",
          filter = { event = "msg_show", kind = "emsg" },
        },
        {
          view = "notify",
          filter = { event = "msg_show", kind = "wmsg" },
        },
      },
      -- Views: customize popup appearance
      views = {
        cmdline_popup = {
          position = { row = "40%", col = "50%" },
          size = { width = 60, height = "auto" },
          border = { style = "rounded", padding = { 0, 1 } },
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
        popupmenu = {
          relative = "editor",
          position = { row = "47%", col = "50%" },
          size = { width = 60, height = 10 },
          border = { style = "rounded", padding = { 0, 1 } },
          win_options = {
            winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },
        mini = {
          timeout = 2000,
          reverse = true,
          align = "message",
          position = { row = -2, col = -2 },
        },
      },
    },
  },
}
