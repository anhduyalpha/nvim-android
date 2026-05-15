-- plugins/lang/c_cpp.lua — C/C++ language support
-- Dedicated keymaps, clangd with bits/stdc++.h, code runner

local map = vim.keymap.set

-- ── Compile & Run helper ─────────────────────────────────
local function compile_cpp(opt)
  local file = vim.fn.expand("%")
  local out = vim.fn.expand("%:r")
  local ft = vim.bo.filetype

  local compiler = ft == "c" and "gcc" or "g++"
  local std = ft == "c" and "-std=c17" or "-std=c++20"
  local cmd = string.format("%s %s -O2 -Wall -o %s %s && ./%s", compiler, std, out, file, out)

  -- Save first
  vim.cmd("w")

  if opt == "compile" then
    -- Compile only
    local compile_only = string.format("%s %s -O2 -Wall -o %s %s 2>&1", compiler, std, out, file)
    local result = vim.fn.system(compile_only)
    if vim.v.shell_error ~= 0 then
      vim.notify("❌ Compile error:\n" .. result, vim.log.levels.ERROR)
    else
      vim.notify("✅ Compiled: " .. out, vim.log.levels.INFO)
    end
  elseif opt == "run" then
    -- Run existing binary
    if vim.fn.filereadable(out) ~= 1 then
      vim.notify("⚠️ Binary not found. Compile first (<leader>cc)", vim.log.levels.WARN)
      return
    end
    vim.cmd("ToggleTerm cmd='./" .. out .. "'")
  elseif opt == "build_run" then
    -- Compile + run
    vim.cmd("ToggleTerm cmd='" .. cmd .. "'")
  end
end

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

  -- ── C/C++ dedicated keymaps ────────────────────────────
  {
    "neovim/nvim-lspconfig",
    ft = { "c", "cpp" },
    keys = {
      -- Build & Run
      { "<leader>ct", function() compile_cpp("build_run") end, desc = "Build & run file", ft = { "c", "cpp" } },
      { "<leader>cc", function() compile_cpp("compile") end, desc = "Compile file", ft = { "c", "cpp" } },
      { "<leader>cr", function() compile_cpp("run") end, desc = "Run binary", ft = { "c", "cpp" } },
      -- LSP actions (C++ specific)
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", ft = { "c", "cpp" } },
      { "<leader>cn", vim.lsp.buf.rename, desc = "Rename symbol", ft = { "c", "cpp" } },
      { "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format file", ft = { "c", "cpp" } },
      { "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format selection", mode = "v", ft = { "c", "cpp" } },
      { "<leader>ck", vim.lsp.buf.signature_help, desc = "Signature help", ft = { "c", "cpp" } },
      { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch header/source", ft = { "c", "cpp" } },
      { "<leader>ci", "<cmd>ClangdSymbolInfo<cr>", desc = "Symbol info", ft = { "c", "cpp" } },
      { "<leader>cd", vim.lsp.buf.type_definition, desc = "Type definition", ft = { "c", "cpp" } },
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
