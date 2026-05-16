-- autocmds.lua — Autocommands optimized for Android/Termux
-- Handles auto-save, clipboard, performance, and quality-of-life features

local android = require("util.android")
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ── Auto-save on focus lost (critical on Android — background apps get killed) ──
augroup("AutoSave", { clear = true })
autocmd({ "FocusLost", "BufLeave" }, {
  group = "AutoSave",
  desc = "Auto-save when focus is lost or leaving buffer",
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      vim.cmd("silent! write")
    end
  end,
})

-- ── Highlight on yank ────────────────────────────────────
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  desc = "Highlight yanked text briefly",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- ── Remove trailing whitespace on save ───────────────────
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "TrimWhitespace",
  desc = "Remove trailing whitespace before saving",
  pattern = { "*" },
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- ── Restore cursor position ──────────────────────────────
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  desc = "Restore cursor to last known position",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ── Close certain filetypes with q ───────────────────────
augroup("CloseWithQ", { clear = true })
autocmd("FileType", {
  group = "CloseWithQ",
  desc = "Allow closing special windows with q",
  pattern = {
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "checkhealth",
    "dap-float",
    "null-ls-info",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- ── Auto-resize splits on window resize (screen orientation change) ──
augroup("AutoResize", { clear = true })
autocmd("VimResized", {
  group = "AutoResize",
  desc = "Equalize windows when terminal is resized",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- ── Termux clipboard integration ─────────────────────────
if android.is_termux() then
  augroup("TermuxClipboard", { clear = true })
  autocmd("FocusGained", {
    group = "TermuxClipboard",
    desc = "Sync clipboard when Termux regains focus",
    callback = function()
      -- Refresh clipboard content
      local handle = io.popen("termux-clipboard-get 2>/dev/null")
      if handle then
        local content = handle:read("*a")
        handle:close()
        if content and content ~= "" then
          vim.fn.setreg("+", content)
        end
      end
    end,
  })
end

-- ── File type specific settings ──────────────────────────
augroup("FileTypeSettings", { clear = true })
autocmd("FileType", {
  group = "FileTypeSettings",
  desc = "Set filetype-specific options",
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
})

autocmd("FileType", {
  group = "FileTypeSettings",
  desc = "Use 4 spaces for these languages",
  pattern = { "python", "rust", "go", "java", "c", "cpp" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- ── Auto-format on save is handled by conform.nvim via LazyVim ──
-- Do NOT add BufWritePre format autocmd here — it causes double-formatting

-- ── Check for low memory periodically on Android ─────────
if android.is_android() then
  augroup("MemoryCheck", { clear = true })
  autocmd("CursorHold", {
    group = "MemoryCheck",
    desc = "Check memory usage on idle",
    callback = function()
      require("util.performance").auto_optimize()
    end,
  })
end
