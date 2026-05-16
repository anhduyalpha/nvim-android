-- plugins/ui.lua — UI plugins (theme, statusline, bufferline, dashboard)
-- All plugins are lightweight and optimized for Android

local features = vim.g.nvim_android_features or {}

return {
  -- ── Theme: TokyoNight ──────────────────────────────────
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
        sidebars = "dark",
        floats = "dark",
      },
      on_highlights = function(hl, c)
        -- Custom highlights for better visibility on mobile
        hl.CursorLine = { bg = c.bg_highlight }
        hl.CursorLineNr = { fg = c.orange, bold = true }
        -- Ghost text for C++ inline completion suggestions
        hl.CmpGhostText = { fg = c.comment, italic = true }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- ── Statusline: lualine ────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "tokyonight",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- ── Bufferline (optional, toggleable) ──────────────────
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    enabled = features.bufferline ~= false,
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        offsets = {
          { filetype = "neo-tree", text = "File Explorer", highlight = "Directory" },
        },
      },
    },
  },

  -- ── Dashboard ──────────────────────────────────────────
  -- DISABLED: LazyVim uses Snacks dashboard by default
  -- alpha-nvim conflicts with LazyVim's snacks_picker.lua (button field nil)
  -- {
  --   "goolord/alpha-nvim",
  --   event = "VimEnter",
  --   enabled = features.fancy_dashboard ~= false,
  --   config = function()
  --     local alpha = require("alpha")
  --     local dashboard = require("alpha.themes.dashboard")
  --     ...
  --   end,
  -- },

  -- ── Indent guides ──────────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    enabled = features.indent_guides ~= false,
    main = "ibl",
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope = { enabled = false },
      exclude = {
        filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      },
    },
  },

  -- ── Illuminate (highlight word under cursor) ───────────
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    enabled = features.illuminate ~= false,
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "lsp" } },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  -- ── Better UI for select/input ─────────────────────────
  -- DISABLED: LazyVim uses Snacks.input/Snacks.picker for vim.ui
  -- Having dressing.nvim causes conflict (overrides vim.ui.input/select)
  -- {
  --   "stevearc/dressing.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     input = { enabled = true },
  --     select = {
  --       enabled = true,
  --       backend = { "telescope", "fzf", "builtin" },
  --     },
  --   },
  -- },

  -- ── Notifications (pretty, with noice integration) ──────
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
      render = "compact",
      stages = "fade_in_slide_out",
      background_colour = "#000000",
      top_down = false,
      icons = {
        ERROR = " ",
        WARN = " ",
        INFO = " ",
        DEBUG = " ",
        TRACE = "✎ ",
      },
    },
  },
}
