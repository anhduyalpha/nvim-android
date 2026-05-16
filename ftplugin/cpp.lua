-- ~/.config/nvim/ftplugin/cpp.lua
-- C++ specific keybindings (buffer-local) — from nvim_conf

local map = vim.keymap.set

-----------------------------------------------------------------------------
-- UTILITY & TERMINAL RUNNER
-----------------------------------------------------------------------------
local function get_mtime(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.mtime and stat.mtime.sec or 0
end

local function run_in_terminal(cmd)
  local hold_cmd = "bash -c \"" .. cmd .. "; echo ''; echo '===================================='; echo '[Process Finished] Press Enter to close...'; read\""
  local has_snacks, snacks = pcall(require, "snacks")
  if has_snacks and snacks.terminal then
    snacks.terminal(hold_cmd, { interactive = true, win = { position = "bottom", height = 15 } })
  else
    vim.cmd("botright 15split | term " .. hold_cmd)
    vim.cmd("startinsert")
  end
end

-----------------------------------------------------------------------------
-- 1. SINGLE FILE BUILD & RUN
-----------------------------------------------------------------------------
local function get_single_build_info()
  local filepath = vim.fn.expand("%:p")
  local filedir  = vim.fn.expand("%:p:h")
  local name     = vim.fn.expand("%:t:r")
  local build_dir = filedir .. "/build"
  if vim.fn.isdirectory(build_dir) == 0 then vim.fn.mkdir(build_dir, "p") end
  return filepath, build_dir .. "/" .. name, build_dir
end

local function build_and_run_single(force_rebuild)
  vim.cmd("write")
  local filepath, out_file, _ = get_single_build_info()
  local src_mtime = get_mtime(filepath)
  local out_mtime = get_mtime(out_file)

  if not force_rebuild and out_mtime > 0 and out_mtime > src_mtime then
    vim.notify("🚀 Fast run: skipping build.", vim.log.levels.INFO, { title = "C++ Single" })
    run_in_terminal(string.format("'%s'", out_file))
    return
  end

  vim.notify("⚙️ Compiling...", vim.log.levels.INFO, { title = "C++ Single" })
  local compiler = vim.fn.executable("clang++") == 1 and "clang++" or "g++"
  local cmd = string.format("%s -std=c++20 -O2 -Wall '%s' -o '%s'", compiler, filepath, out_file)
  vim.system({ "bash", "-c", cmd }, { text = true }, function(result)
    vim.schedule(function()
      if result.code == 0 then
        vim.notify("✅ Build OK!", vim.log.levels.INFO, { title = "C++ Single" })
        run_in_terminal(string.format("'%s'", out_file))
      else
        vim.notify("❌ Build Error:\n" .. result.stderr, vim.log.levels.ERROR, { title = "C++ Build Failed" })
      end
    end)
  end)
end

map("n", "<leader>ct", function() build_and_run_single(false) end, { buffer = true, desc = "Build & Run (Single)" })
map("n", "<leader>cT", function() build_and_run_single(true)  end, { buffer = true, desc = "Force Rebuild (Single)" })

-----------------------------------------------------------------------------
-- 2. CMAKE
-----------------------------------------------------------------------------
map("n", "<leader>cmc", function()
  vim.cmd("write")
  local root = vim.fn.getcwd()
  local build_dir = root .. "/build"
  if vim.fn.isdirectory(build_dir) == 0 then vim.fn.mkdir(build_dir, "p") end
  run_in_terminal(string.format(
    "cmake -S '%s' -B '%s' -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
    root, build_dir
  ))
end, { buffer = true, desc = "CMake: Configure" })

map("n", "<leader>cmb", function()
  local build_dir = vim.fn.getcwd() .. "/build"
  run_in_terminal(string.format("cmake --build '%s' -j2", build_dir))
end, { buffer = true, desc = "CMake: Build" })

-----------------------------------------------------------------------------
-- 3. AUTO SEMICOLON & LSP FEATURES
-----------------------------------------------------------------------------
map("n", "<leader>;", function()
  local pos  = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  if not line:match(";%s*$") and line:match("%S") then
    vim.api.nvim_set_current_line(line .. ";")
  end
  vim.api.nvim_win_set_cursor(0, pos)
end, { buffer = true, desc = "Add Semicolon" })

map("i", "<C-l>", function()
  local line = vim.api.nvim_get_current_line()
  if not line:match(";%s*$") and line:match("%S") then
    local new_line = line .. ";"
    vim.api.nvim_set_current_line(new_line)
    vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), #new_line })
  else
    vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), #line })
  end
end, { buffer = true, desc = "Add Semicolon & Jump" })

map("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", { buffer = true, desc = "Switch Header/Source" })
map("n", "<leader>ci", "<cmd>ClangdSymbolInfo<cr>",         { buffer = true, desc = "Symbol Info" })
map("n", "<leader>cH", function()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
end, { buffer = true, desc = "Toggle Inlay Hints" })

map("n", "<leader>cI", function()
  local pos   = vim.api.nvim_win_get_cursor(0)
  local diags = vim.diagnostic.get(0, { lnum = pos[1] - 1 })
  vim.lsp.buf.code_action({ apply = true, context = { only = { "quickfix" }, diagnostics = diags } })
end, { buffer = true, desc = "Auto Fix / Add Include" })
