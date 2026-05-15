-- plugins/lang/c_cpp.lua — C/C++ language support
-- clangd LSP config + clang_format formatter
-- Keymaps are in config/keymaps.lua (FileType autocmd) to avoid lazy.nvim merge issues

return {
  -- ── C/C++ LSP (clangd with bits/stdc++.h support) ─────
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
            "--query-driver=/**",
          },
          settings = {
            clangd = {
              inlayHints = {
                enabled = false,
              },
            },
          },
        },
      },
    },
  },

  -- ── C/C++ formatter ────────────────────────────────────
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
    },
  },

  -- ── CMake support (optional) ───────────────────────────
  {
    "Civitasv/cmake-tools.nvim",
    ft = { "cmake" },
    opts = {
      cmake_build_directory = "build",
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
    },
  },
}
