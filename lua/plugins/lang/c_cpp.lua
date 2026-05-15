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
  -- NOTE: NOT attached to neovim/nvim-lspconfig to avoid ft merge conflict
  -- that would override lsp.lua's event-based loading for ALL languages.
  -- Uses vim.keymap.set in FileType autocmd — same effect, no plugin merge issue.
  {
    "c-cpp-keymaps.nvim",
    ft = { "c", "cpp" },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp" },
        callback = function(args)
          local buf = args.buf
          local o = { buffer = buf, silent = true }
          -- Build & Run
          vim.keymap.set("n", "<leader>ct", function() compile_cpp("build_run") end, vim.tbl_extend("force", o, { desc = "Build & run file" }))
          vim.keymap.set("n", "<leader>cc", function() compile_cpp("compile") end, vim.tbl_extend("force", o, { desc = "Compile file" }))
          vim.keymap.set("n", "<leader>cr", function() compile_cpp("run") end, vim.tbl_extend("force", o, { desc = "Run binary" }))
          -- LSP actions
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", o, { desc = "Code action" }))
          vim.keymap.set("n", "<leader>cn", vim.lsp.buf.rename, vim.tbl_extend("force", o, { desc = "Rename symbol" }))
          vim.keymap.set("n", "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, vim.tbl_extend("force", o, { desc = "Format file" }))
          vim.keymap.set("v", "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, vim.tbl_extend("force", o, { desc = "Format selection" }))
          vim.keymap.set("n", "<leader>ck", vim.lsp.buf.signature_help, vim.tbl_extend("force", o, { desc = "Signature help" }))
          vim.keymap.set("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", vim.tbl_extend("force", o, { desc = "Switch header/source" }))
          vim.keymap.set("n", "<leader>ci", "<cmd>ClangdSymbolInfo<cr>", vim.tbl_extend("force", o, { desc = "Symbol info" }))
          vim.keymap.set("n", "<leader>cd", vim.lsp.buf.type_definition, vim.tbl_extend("force", o, { desc = "Type definition" }))
        end,
      })
    end,
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
