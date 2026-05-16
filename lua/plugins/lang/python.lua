-- plugins/lang/python.lua — Python language support
-- LSP: pyright, Formatter: black/ruff, Linter: ruff, DAP: debugpy, Test: neotest

return {
  -- ── Python LSP ─────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                -- Memory optimization
                indexing = true,
                completeFunctionParens = true,
              },
            },
          },
        },
      },
    },
  },

  -- ── Python formatter (black) ───────────────────────────
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black" },
      },
    },
  },

  -- ── Python linter (ruff) ───────────────────────────────
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "ruff" },
      },
    },
  },

  -- ── Python DAP ─────────────────────────────────────────
  {
    "mfussenegger/nvim-dap",
    opts = {
      -- Python debugpy adapter configured in debugging.lua
    },
  },

  -- ── Python venv selector ───────────────────────────────
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    ft = "python",
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select venv" },
    },
    opts = {
      name = { "venv", ".venv", "env" },
    },
  },

  -- ── Python test runner ─────────────────────────────────
  {
    "nvim-neotest/neotest",
    ft = "python",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
    },
    keys = {
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>tF", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
      { "<leader>to", function() require("neotest").output_panel.toggle() end, desc = "Test output" },
    },
    opts = function()
      return {
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
          }),
        },
      }
    end,
  },
}
