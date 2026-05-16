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
            "--query-driver=/**/*",
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

  -- ── C++ popup completion (filetype override via autocmd) ─
  -- Dùng autocmd BufEnter để tránh xung đột với config block của completion.lua
  -- (lazy.nvim chỉ chạy 1 config block cuối cùng cho cùng plugin)
  {
    "hrsh7th/nvim-cmp",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "objc", "objcpp" },
        desc = "C++ nvim-cmp popup config",
        callback = function()
          local ok, cmp = pcall(require, "cmp")
          if not ok then return end

          cmp.setup.buffer({
            completion = {
              -- popup hiện ra ngay, không tự chọn item đầu tiên
              completeopt = "menu,menuone,noselect",
            },
            performance = {
              debounce = 50,         -- clangd chạy local nên rất nhanh
              throttle = 30,
              fetching_timeout = 300,
              max_view_entries = 15,
            },
            -- Sources: clangd LSP là ưu tiên cao nhất
            sources = cmp.config.sources({
              { name = "nvim_lsp", priority = 1000 },
              { name = "luasnip",  priority = 750 },
              { name = "path",     priority = 500 },
            }, {
              { name = "buffer", priority = 250, keyword_length = 3 },
            }),
            experimental = { ghost_text = false },
          })
        end,
      })
    end,
  },
}



