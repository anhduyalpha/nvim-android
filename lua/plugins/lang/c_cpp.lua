-- plugins/lang/c_cpp.lua — C/C++ language support
-- Centralized configuration for C++ (LSP, completion, formatter, etc.)
-- Keymaps are in config/keymaps.lua (FileType autocmd)

return {
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

  -- ── clangd LSP ─────────────────────────────────────────
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
            "--query-driver=/data/data/com.termux/files/usr/bin/*",
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
          -- CRITICAL: Tell clangd to send completions when user types "#"
          -- Without this, #include suggestions won't appear on "#"
          capabilities = {
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = true,
                },
              },
            },
          },
          settings = {
            clangd = {
              inlayHints = { enabled = false },
            },
          },
          on_attach = function(client, bufnr)
            if client.server_capabilities.completionProvider then
              vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
              -- Force clangd trigger chars to include "#" and "<"
              local trigger_chars = client.server_capabilities.completionProvider.triggerCharacters or {}
              local has_hash = false
              local has_angle = false
              for _, ch in ipairs(trigger_chars) do
                if ch == "#" then has_hash = true end
                if ch == "<" then has_angle = true end
              end
              if not has_hash then table.insert(trigger_chars, "#") end
              if not has_angle then table.insert(trigger_chars, "<") end
              client.server_capabilities.completionProvider.triggerCharacters = trigger_chars
            end
          end,
        },
      },
    },
  },

  -- ── Clangd extensions ──────────────────────────────────
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp" },
    opts = {
      ast = { role_icons = {}, kind_icons = {} },
      memory_usage = { border = "rounded" },
      symbol_info = { border = "rounded" },
    },
  },

  -- ── LuaSnip: C/C++ #include snippets ──────────────────
  -- Provides "#inc" → #include <>, "#ins" → #include ""
  {
    "L3MON4D3/LuaSnip",
    opts = function(_, opts)
      local ls = require("luasnip")
      local s  = ls.snippet
      local t  = ls.text_node
      local i  = ls.insert_node

      ls.add_snippets("c", {
        -- #inc → #include <filename>
        s("inc", { t("#include <"), i(1, "stdio.h"), t(">") }),
        -- #ins → #include "filename"
        s("ins", { t('#include "'), i(1, "header.h"), t('"') }),
        -- main boilerplate
        s("main", {
          t({ "#include <stdio.h>", "", "int main(void) {", "\t" }),
          i(1, "// code here"),
          t({ "", "\treturn 0;", "}" }),
        }),
      })

      ls.add_snippets("cpp", {
        -- #inc → #include <filename>
        s("inc", { t("#include <"), i(1, "iostream"), t(">") }),
        -- #ins → #include "filename"
        s("ins", { t('#include "'), i(1, "header.hpp"), t('"') }),
        -- main boilerplate
        s("main", {
          t({ "#include <iostream>", "", "int main() {", "\t" }),
          i(1, "// code here"),
          t({ "", "\treturn 0;", "}" }),
        }),
        -- std::cout
        s("cout", { t("std::cout << "), i(1, "msg"), t(' << std::endl;') }),
        -- std::cin
        s("cin", { t("std::cin >> "), i(1, "var"), t(";") }),
      })
    end,
  },

  -- ── C/C++ nvim-cmp override ────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      vim.schedule(function()
        local ok, cmp = pcall(require, "cmp")
        if not ok then return end

        cmp.setup.filetype({ "c", "cpp", "objc", "objcpp" }, {
          completion = {
            completeopt = "menu,menuone,noselect",
            -- CRITICAL: "#" and "<" must be keyword chars so cmp triggers on them.
            keyword_pattern = [[\%(\k\|#\|<\)\+]],
          },
          performance = {
            debounce = 50,
            throttle = 30,
            fetching_timeout = 300,
            max_view_entries = 15,
          },
          sources = cmp.config.sources({
            { name = "nvim_lsp", priority = 1000 },
            { name = "luasnip",  priority = 900 },
            { name = "path",     priority = 500 },
          }, {
            { name = "buffer", priority = 250, keyword_length = 3 },
          }),
          experimental = { ghost_text = true },
        })
      end)
    end,
  },
}
