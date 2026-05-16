-- plugins/suggestion.lua — C++ code completion & suggestion
-- Dedicated file to ensure clangd completion works properly on Android/Termux

local android = require("util.android")

return {
  -- ── clangd LSP config ─────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "--query-driver=**",
            "--suggest-missing-includes",
            "--header-insertion-decorators",
            "--pch-storage=memory",
            "--log=error",
          },
          filetypes = { "c", "cpp", "objc", "objcpp" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "compile_commands.json",
              "compile_flags.txt",
              ".clangd",
              ".git"
            )(fname) or vim.fn.getcwd()
          end,
          single_file_support = true,
          capabilities = {
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = true,
                  commitCharactersSupport = true,
                  deprecatedSupport = true,
                  preselectSupport = true,
                  insertReplaceSupport = true,
                  resolveSupport = {
                    properties = { "documentation", "detail", "additionalTextEdits" },
                  },
                },
              },
            },
          },
          settings = {
            clangd = {
              inlayHints = {
                enabled = false,
              },
            },
          },
          on_attach = function(client, bufnr)
            -- Enable completion triggered manually
            if client.server_capabilities.completionProvider then
              vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
            end
          end,
        },
      },
    },
  },

  -- ── nvim-cmp optimized for C++ ────────────────────────
  {
    "hrsh7th/nvim-cmp",
    ft = { "c", "cpp" },
    opts = {
      performance = {
        debounce = 30,
        throttle = 30,
        fetching_timeout = 150,
      },
    },
  },

  -- ── Clangd extensions (extra completions) ─────────────
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp" },
    opts = {
      ast = {
        role_icons = {},
        kind_icons = {},
      },
      memory_usage = { border = "rounded" },
      symbol_info = { border = "rounded" },
    },
  },
}
