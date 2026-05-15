# PROJECT CONTEXT — nvim-android

> ⚠️ File này được duy trì tự động bởi AI Agent.
> Luôn đọc file này ĐẦU TIÊN khi bắt đầu session mới.

---

## Project Overview
- **Tên project**: nvim-android
- **Repo**: https://github.com/anhduyalpha/nvim-android.git
- **Tech stack**: Lua, Neovim, LazyVim, Termux
- **Owner**: anhduyalpha
- **Last updated**: 2026-05-15

---

## Current State
**Phase**: Release
**Overall progress**: 100%

---

## Architecture Decisions
| Decision | Choice | Reason | Date |
|----------|--------|--------|------|
| Plugin framework | LazyVim | Pre-configured, well-maintained, extensible | 2026-05-15 |
| Plugin manager | lazy.nvim | Built-in from LazyVim, lazy loading by default | 2026-05-15 |
| Theme | TokyoNight | Modern, good terminal support, readable | 2026-05-15 |
| LSP installer | mason.nvim + mason-lspconfig | Auto-install, bridge to lspconfig | 2026-05-15 |
| Formatter | conform.nvim | Lightweight, supports many formatters | 2026-05-15 |
| Linter | nvim-lint | Lightweight, async linting | 2026-05-15 |
| DAP | nvim-dap + mason-nvim-dap | Auto-install debuggers via Mason | 2026-05-15 |
| File explorer | neo-tree | Feature-rich, good git integration | 2026-05-15 |
| Fuzzy finder | telescope.nvim | Standard, extensible, fast with fzf | 2026-05-15 |
| Terminal | toggleterm.nvim | Flexible, supports multiple terminal modes | 2026-05-15 |
| Statusline | lualine.nvim | Lightweight, configurable, fast | 2026-05-15 |
| Completion | nvim-cmp | Standard, well-supported, extensible | 2026-05-15 |
| Feature toggle | vim.g.nvim_android_features | Global table, user overridable via user.lua | 2026-05-15 |
| Performance strategy | Lazy load everything, limit items, debounce | Critical for Android RAM/CPU constraints | 2026-05-15 |

---

## File Map
```
nvim-android/
├── README.md ✅ Complete
├── INSTALL.md ✅ Complete
├── context.md ✅ Complete
├── .gitignore ✅ Complete
├── scripts/
│   ├── setup-termux.sh ✅ Complete
│   ├── install-deps.sh ✅ Complete
│   └── fix-common-issues.sh ✅ Complete
├── config/
│   └── termux/
│       └── termux.properties ✅ Complete
├── lua/
│   ├── config/
│   │   ├── lazy.lua ✅ Complete
│   │   ├── options.lua ✅ Complete
│   │   ├── keymaps.lua ✅ Complete
│   │   └── autocmds.lua ✅ Complete
│   ├── plugins/
│   │   ├── init.lua ✅ Complete
│   │   ├── ui.lua ✅ Complete
│   │   ├── editor.lua ✅ Complete
│   │   ├── treesitter.lua ✅ Complete
│   │   ├── lsp.lua ✅ Complete
│   │   ├── completion.lua ✅ Complete
│   │   ├── debugging.lua ✅ Complete
│   │   ├── git.lua ✅ Complete
│   │   ├── terminal.lua ✅ Complete
│   │   ├── navigation.lua ✅ Complete
│   │   ├── lang/
│   │   │   ├── lua.lua ✅ Complete
│   │   │   ├── python.lua ✅ Complete
│   │   │   ├── javascript.lua ✅ Complete
│   │   │   ├── rust.lua ✅ Complete
│   │   │   ├── go.lua ✅ Complete
│   │   │   ├── c_cpp.lua ✅ Complete
│   │   │   ├── java.lua ✅ Complete
│   │   │   ├── markdown.lua ✅ Complete
│   │   │   └── web.lua ✅ Complete
│   │   └── extras.lua ✅ Complete
│   └── util/
│       ├── android.lua ✅ Complete
│       └── performance.lua ✅ Complete
└── .github/
    └── ISSUE_TEMPLATE.md ✅ Complete
```

---

## What's Been Done ✅
1. [2026-05-15] Created full project structure
2. [2026-05-15] Implemented android.lua utility (platform detection, clipboard, memory check)
3. [2026-05-15] Implemented performance.lua utility (memory monitoring, auto-cleanup)
4. [2026-05-15] Created lazy.lua with LazyVim bootstrap and optimization
5. [2026-05-15] Created options.lua with Android-tuned settings
6. [2026-05-15] Created keymaps.lua with mobile-friendly keybindings
7. [2026-05-15] Created autocmds.lua (auto-save, clipboard, format on save)
8. [2026-05-15] Implemented UI plugins (tokyonight, lualine, bufferline, alpha-nvim)
9. [2026-05-15] Implemented editor plugins (mini.nvim, which-key, trouble, todo-comments)
10. [2026-05-15] Implemented treesitter with performance limits
11. [2026-05-15] Implemented LSP (mason, lspconfig, conform, lint)
12. [2026-05-15] Implemented completion (nvim-cmp, LuaSnip)
13. [2026-05-15] Implemented debugging (DAP, dapui, mason-dap)
14. [2026-05-15] Implemented git (gitsigns, lazygit, diffview)
15. [2026-05-15] Implemented terminal (toggleterm, code runner)
16. [2026-05-15] Implemented navigation (telescope, neo-tree, flash)
17. [2026-05-15] Implemented 9 language configs (lua, python, js/ts, rust, go, c/c++, java, markdown, web)
18. [2026-05-15] Implemented extras (copilot, harpoon, zen-mode, undotree, fugitive, noice)
19. [2026-05-15] Created setup-termux.sh
20. [2026-05-15] Created install-deps.sh
21. [2026-05-15] Created fix-common-issues.sh
22. [2026-05-15] Created README.md (Vietnamese)
23. [2026-05-15] Created INSTALL.md (Vietnamese)
24. [2026-05-15] Created context.md

---

## What's In Progress 🔧
_(None — project complete)_

---

## What's Next 📋
1. [ ] User testing on actual Android device
2. [ ] Gather feedback and fix issues
3. [ ] Add more language support based on demand
4. [ ] Performance benchmarking on low-end devices

---

## Known Issues 🐛
| Issue | Severity | Status | Notes |
|-------|----------|--------|-------|
| Plugins not auto-installing on startup | **Critical** | ✅ Fixed | Missing `init.lua` entry point + `vim.loop` deprecated |
| Java LSP very heavy | Low | By design | Disabled by default, user must opt-in |
| No Nerd Font in Termux | Low | By design | Using text fallback icons |
| Copilot needs auth | Low | By design | Disabled by default |

---

## Session History
### Session #2 — 2026-05-15
- **Duration**: ~5 min
- **Worked on**: Fix plugins not auto-installing on startup
- **Root cause**: Missing `init.lua` entry point at project root + deprecated `vim.loop` usage
- **Completed**: 
  - Created `init.lua` (Neovim entry point)
  - Fixed `vim.loop` → `vim.uv` in `lazy.lua` and `performance.lua`
  - Removed duplicate leader key from `options.lua`
- **Commit**: `fix: add init.lua entry point and fix vim.loop deprecation`

### Session #1 — 2026-05-15
- **Duration**: ~30 min
- **Worked on**: Full project implementation
- **Completed**: All 34 files created, fully functional code
- **Left off**: Ready for push to GitHub
- **Commit**: `feat: initial release — full nvim-android IDE config`
