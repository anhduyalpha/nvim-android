-- ╭────────────────────────────────────────────────────────────────╮
-- │  cpp.lua — C++ specific plugins (mirrored from nvim_conf)      │
-- │  Termux: clangd installed via `pkg install clang`              │
-- ╰────────────────────────────────────────────────────────────────╯

local clangd_cmd = {
  "clangd",
  "--background-index",
  "--clang-tidy",
  "--header-insertion=iwyu",
  "--completion-style=detailed",
  "--function-arg-placeholders",
  "--fallback-style=llvm",
  -- Termux-specific: find system headers from pkg-installed compilers
  "--query-driver=/data/data/com.termux/files/usr/bin/*",
  "--pch-storage=disk", -- save RAM on Android
  "-j=2",              -- limit threads on mobile
}

return {
  -- ── clangd LSP ─────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    event = "FileType",
    opts = {
      servers = {
        clangd = {
          mason = false, -- installed via: pkg install clang
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

  -- ── Clangd extensions (AST explorer, type info) ────────────────
  {
    "p00f/clangd_extensions.nvim",
    optional = true,
    opts = {
      extensions = {
        inlay_hints = {
          inline = false,
        },
        ast = {
          role_icons = {
            type = "",
            declaration = "",
            expression = "",
            specifier = "",
            statement = "",
            ["template argument"] = "",
          },
          kind_icons = {
            Compound = "",
            Recovery = "",
            TranslationUnit = "",
            PackExpansion = "",
            TemplateTypeParm = "",
            TemplateTemplateParm = "",
            TemplateParamObject = "",
          },
        },
      },
    },
  },

  -- ── C/C++ formatter ────────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c   = { "clang_format" },
        cpp = { "clang_format" },
      },
    },
  },
}
