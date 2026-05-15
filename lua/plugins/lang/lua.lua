-- plugins/lang/lua.lua — Lua language support
-- Neovim Lua development with lazydev.nvim

return {
  -- ── Lazydev (Lua LS for Neovim config) ─────────────────
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },

  -- ── Lua LSP (via lspconfig) ────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
              diagnostics = {
                globals = { "vim" },
                disable = { "different-requires" },
              },
              completion = {
                callSnippet = "Replace",
              },
              hint = { enable = false },  -- Disable inlay hints for performance
            },
          },
        },
      },
    },
  },

  -- ── Formatter ──────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
}
