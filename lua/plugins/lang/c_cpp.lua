-- plugins/lang/c_cpp.lua — C/C++ language support
-- LSP: clangd, Formatter: clang-format, DAP: codelldb

return {
  -- ── C/C++ LSP ──────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
          settings = {
            clangd = {
              inlayHints = {
                enabled = false,  -- Disable for performance
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
