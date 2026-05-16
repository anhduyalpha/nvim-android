-- plugins/suggestion.lua — Unified completion & C++ suggestion config
-- Replaces old completion.lua + c_cpp.lua clangd config
-- Ensures clangd completion works on Android/Termux

return {
  -- ── clangd LSP (C/C++ completion engine) ─────────────
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
            "--query-driver=/data/data/com.termux/files/usr/bin/clang*,/data/data/com.termux/files/usr/bin/g*",
            "--suggest-missing-includes",
            "--header-insertion-decorators",
            "--pch-storage=disk",
            "-j=2",
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
          settings = {
            clangd = {
              inlayHints = { enabled = false },
            },
          },
          on_attach = function(client, bufnr)
            if client.server_capabilities.completionProvider then
              vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
            end
          end,
        },
      },
    },
  },

  -- ── Clangd extensions (AST, memory, symbol info) ──────
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp" },
    opts = {
      ast = { role_icons = {}, kind_icons = {} },
      memory_usage = { border = "rounded" },
      symbol_info = { border = "rounded" },
    },
  },


}



