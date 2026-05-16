-- plugins/lang/rust.lua — Rust language support
-- LSP: rust-analyzer, Formatter: rustfmt, DAP: codelldb, Test: neotest

return {
  -- ── Rust LSP (rust-analyzer) ───────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
              cargo = {
                allFeatures = true,
              },
              procMacro = {
                enable = true,
              },
              inlayHints = {
                chainingHints = { enable = false },
                typeHints = { enable = false },
                parameterHints = { enable = false },
              },
            },
          },
        },
      },
    },
  },

  -- ── Crates.nvim (Cargo.toml dependency management) ─────
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      src = {
        cmp = { enabled = true },
      },
    },
  },

  -- ── Rust formatter ─────────────────────────────────────
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },

  -- ── Rust test runner ───────────────────────────────────
  {
    "nvim-neotest/neotest",
    ft = "rust",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rouge8/neotest-rust",
    },
    keys = {
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>tF", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
    },
    opts = function()
      return {
        adapters = {
          require("neotest-rust")({}),
        },
      }
    end,
  },
}
