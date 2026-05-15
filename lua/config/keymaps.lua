-- keymaps.lua — Custom keymaps optimized for mobile/touch and small screens
-- Uses Space as leader key, with intuitive grouping

local map = vim.keymap.set
local android = require("util.android")

-- ── Snacks Explorer ──────────────────────────────────────
map("n", "t", function()
  Snacks.picker.explorer()
end, { desc = "Toggle Snacks Explorer" })
map("n", "<S-u>", function()
  -- Focus explorer if already open, otherwise open it
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.picker then
    -- Try to find and focus existing explorer window
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.bo[buf].filetype
      if ft:match("snacks") then
        vim.api.nvim_set_current_win(win)
        return
      end
    end
  end
  -- Not open, open it
  Snacks.picker.explorer()
end, { desc = "Focus Snacks Explorer" })

-- ── Explorer: q to close buffer in explorer only ─────────
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_picker",
  callback = function(args)
    vim.keymap.set("n", "q", function()
      -- Close the picker/explorer window
      local win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_close(win, true)
    end, { buffer = args.buf, desc = "Close explorer" })
  end,
})

-- ── q to close buffer (normal mode) ─────────────────────
map("n", "q", function()
  -- Don't close if in special buffers
  local ft = vim.bo.filetype
  local bt = vim.bo.buftype
  if ft == "snacks_picker" or ft == "neo-tree" or ft == "Trouble" or ft == "help" or ft == "qf" or bt == "terminal" then
    return "q"
  end
  -- Close buffer, keep window
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo.modified then
    local choice = vim.fn.confirm("Buffer modified. Save?", "&Yes\n&No\n&Cancel")
    if choice == 1 then
      vim.cmd("w")
    elseif choice == 3 then
      return
    end
  end
  -- Switch to alternate buffer or previous, then delete
  local alt = vim.fn.bufnr("#")
  if alt > 0 and vim.api.nvim_buf_is_valid(alt) and alt ~= buf then
    vim.cmd("buffer #")
  else
    vim.cmd("bprevious")
  end
  if vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, { force = false })
  end
end, { desc = "Close buffer" })

-- ── Better Escape (mobile-friendly) ──────────────────────
map("i", "jk", "<Esc>", { desc = "Escape insert mode" })
map("i", "jj", "<Esc>", { desc = "Escape insert mode (alt)" })
map("v", "jk", "<Esc>", { desc = "Escape visual mode" })

-- ── Save & Quit ──────────────────────────────────────────
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save all files" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Force quit all" })

-- ── Buffer Navigation ────────────────────────────────────
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bo", "<cmd>%bdelete|edit #|bdelete #<cr>", { desc = "Delete other buffers" })

-- ── Window Navigation (optimized for single screen) ──────
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window Resize
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Window Splits
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>we", "<C-w>=", { desc = "Equalize windows" })
map("n", "<leader>wm", "<cmd>MaximizerToggle<cr>", { desc = "Maximize toggle" })

-- ── Movement (better mobile experience) ──────────────────
-- Move lines up/down
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Better paste (don't yank replaced text)
map("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- ── Quick Actions ────────────────────────────────────────
map("n", "<leader>;", "A;<Esc>", { desc = "Append semicolon" })
map("n", "<leader>,", "A,<Esc>", { desc = "Append comma" })
map("n", "<leader>o", "o<Esc>", { desc = "New line below" })
map("n", "<leader>O", "O<Esc>", { desc = "New line above" })

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>noh<cr>", { desc = "Clear search highlight" })

-- ── Diagnostic Navigation ────────────────────────────────
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- ── Code Actions (LSP universal — gd, gr, gi, K stay global) ──
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })

-- ── <leader>c reserved for C++ ───────────────────────────
-- No global overrides needed. C++ keymaps are defined in lang/c_cpp.lua
-- with ft = { "c", "cpp" } — lazy.nvim handles filetype scoping natively.
-- LazyVim default <leader>c keymaps are buffer-local on LspAttach;
-- they won't conflict because c_cpp.lua keys take priority via lazy.nvim keys spec.

-- ── Terminal ─────────────────────────────────────────────
map("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Float terminal" })
map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
map("t", "jk", [[<C-\><C-n>]], { desc = "Escape terminal mode" })
map("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Terminal: go left" })
map("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Terminal: go down" })
map("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Terminal: go up" })
map("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Terminal: go right" })

-- ── Tab Navigation ───────────────────────────────────────
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })

-- ── Quickfix & Location List ─────────────────────────────
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix list" })
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location list" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix" })

-- ── Yank to system clipboard (Termux) ────────────────────
if android.is_termux() then
  map("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
  map("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
  map("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })
  map("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })
  map("n", "<leader>P", '"+P', { desc = "Paste before from clipboard" })
end

-- ── Misc ─────────────────────────────────────────────────
-- Toggle spell check
map("n", "<leader>us", "<cmd>set spell!<cr>", { desc = "Toggle spell check" })

-- Toggle word wrap
map("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Toggle word wrap" })

-- Toggle relative numbers
map("n", "<leader>un", "<cmd>set relativenumber!<cr>", { desc = "Toggle relative numbers" })

-- Copy file path
map("n", "<leader>fp", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path, vim.log.levels.INFO)
end, { desc = "Copy file path" })
