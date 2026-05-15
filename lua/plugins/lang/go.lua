-- plugins/lang/go.lua — Go language support
-- LSP: gopls, Formatter: goimports/gofmt, DAP: delve, Test: neotest

return {
  -- ── Go LSP ─────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              gofumpt = true,
              usePlaceholders = true,
              completeUnimported = true,
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false,
              },
            },
          },
        },
      },
    },
  },

  -- ── Go.nvim (extra Go tooling) ─────────────────────────
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod" },
    dependencies = { "ray-x/guihua.lua" },
    build = ':lua require("go.install").update_all_sync()',
    keys = {
      { "<leader>ce", "<cmd>GoIfErr<cr>", desc = "Go if err" },
      { "<leader>ct", "<cmd>GoAddTag<cr>", desc = "Go add tags" },
      { "<leader>cT", "<cmd>GoRmTag<cr>", desc = "Go remove tags" },
      { "<leader>cg", "<cmd>GoGenerate<cr>", desc = "Go generate" },
    },
    opts = {
      lsp_cfg = false,  -- We configure via lspconfig
      lsp_gofumpt = true,
      dap_debug = true,
      dap_debug_gui = false,  -- Disable GUI for Android
      test_runner = "go",
      run_in_floaterm = true,
    },
    config = function(_, opts)
      require("go").setup(opts)
    end,
  },

  -- ── Go formatter ───────────────────────────────────────
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "gofmt", "goimports" },
      },
    },
  },

  -- ── Go test runner ─────────────────────────────────────
  {
    "nvim-neotest/neotest",
    ft = "go",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-go",
    },
    opts = function()
      return {
        adapters = {
          require("neotest-go")({
            experimental = { test_table = true },
            args = { "-count=1", "-timeout=60s" },
          }),
        },
      }
    end,
  },
}
