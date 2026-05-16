-- plugins/lang/c_cpp.lua — C/C++ language support
-- Uses LazyVim default completion (blink.cmp or nvim-cmp managed by LazyVim).
-- Only clangd LSP args are customized for Termux paths.

return {
  -- ── C/C++ formatter ────────────────────────────────────
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c   = { "clang_format" },
        cpp = { "clang_format" },
      },
    },
  },

  -- ── CMake support ──────────────────────────────────────
  {
    "Civitasv/cmake-tools.nvim",
    ft   = { "cmake" },
    opts = {
      cmake_build_directory      = "build",
      cmake_generate_options     = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" },
    },
  },

  -- ── clangd LSP (Termux-tuned) ──────────────────────────
  -- clangd is installed via:  pkg install clang
  -- No Mason involvement — paths point directly to Termux binaries.
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
            -- Point to ALL Termux compilers so clangd finds system headers.
            "--query-driver=/data/data/com.termux/files/usr/bin/*",
            "--suggest-missing-includes",
            "--pch-storage=disk",   -- saves RAM on Android
            "-j=2",                  -- limit threads on mobile CPU
            "--log=error",
          },
          filetypes          = { "c", "cpp", "objc", "objcpp" },
          single_file_support = true,
          root_dir           = function(fname)
            return require("lspconfig.util").root_pattern(
              "compile_commands.json",
              "compile_flags.txt",
              ".clangd",
              ".git"
            )(fname) or vim.fn.getcwd()
          end,
          settings = {
            clangd = { inlayHints = { enabled = false } },
          },
        },
      },
    },
  },

  -- ── Clangd extensions (lightweight UI extras) ──────────
  {
    "p00f/clangd_extensions.nvim",
    ft   = { "c", "cpp", "objc", "objcpp" },
    opts = {
      ast         = { role_icons = {}, kind_icons = {} },
      memory_usage = { border = "rounded" },
      symbol_info  = { border = "rounded" },
    },
  },
}
