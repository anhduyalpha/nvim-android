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
    keys = {
      -- Disable ALL crates.nvim keymaps under <leader>c
      { "<leader>ct", false },
      { "<leader>ci", false },
      { "<leader>cv", false },
      { "<leader>cr", false },
      { "<leader>cu", false },
      { "<leader>cf", false },
      { "<leader>co", false },
      { "<leader>cD", false },
      { "<leader>cU", false },
      { "<leader>cA", false },
      { "<leader>cR", false },
      { "<leader>cG", false },
      { "<leader>cH", false },
      { "<leader>cY", false },
      { "<leader>cP", false },
      { "<leader>cs", false },
      { "<leader>cx", false },
      { "<leader>cX", false },
    },
    opts = {
      src = {
        cmp = { enabled = true },
      },
      -- Disable all keymaps from crates.nvim
      null_ls = { enabled = false },
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
