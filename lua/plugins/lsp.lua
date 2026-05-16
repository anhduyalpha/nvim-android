-- ╭────────────────────────────────────────────────────────────────╮
-- │  lsp.lua — LSP: deferred load, minimal startup impact          │
-- │  clangd: installed via pkg install clang (NOT Mason)           │
-- ╰────────────────────────────────────────────────────────────────╯

local clangd_cmd = {
  "clangd",
  "--background-index",
  "--clang-tidy",
  "--header-insertion=iwyu",
  "--completion-style=detailed",
  "--function-arg-placeholders",
  "--fallback-style=llvm",
  -- Termux: scan all compiler binaries to resolve system headers
  "--query-driver=/data/data/com.termux/files/usr/bin/*",
  "--pch-storage=disk", -- save RAM on Android
  "-j=2",              -- limit threads on mobile CPU
}

return {
  {
    "neovim/nvim-lspconfig",
    event = "FileType",
    opts = {
      servers = {
        clangd = {
          mason = false, -- pkg install clang
          cmd = clangd_cmd,
          filetypes = { "c", "cpp", "objc", "objcpp" },
          single_file_support = true,
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "compile_commands.json",
              "compile_flags.txt",
              ".clangd",
              ".git"
            )(fname) or vim.fn.getcwd()
          end,
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
          settings = {
            clangd = { inlayHints = { enabled = false } },
          },
        },
      },
    },
  },
}
