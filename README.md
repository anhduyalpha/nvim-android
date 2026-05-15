# 🚀 nvim-android — Neovim IDE cho Android

> Biến điện thoại Android của bạn thành IDE lập trình đa ngôn ngữ thực thụ, chạy Neovim trong Termux.

[![Neovim](https://img.shields.io/badge/Neovim-%3E%3D0.10.0-green?logo=neovim)](https://neovim.io)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20Termux-brightgreen)](https://termux.dev)

---

## ✨ Tính năng

- 🎨 **Giao diện đẹp** — TokyoNight theme, statusline, dashboard, indent guides
- 🧠 **IntelliSense** — LSP cho 8+ ngôn ngữ (Lua, Python, JS/TS, Rust, Go, C/C++, Java, Web)
- 🔍 **Fuzzy finding** — Telescope tìm file, grep, symbols cực nhanh
- 🐛 **Debug** — DAP cho Python, JavaScript, C/C++, Rust, Go
- 📝 **Auto-format** — Tự động format code khi save (Prettier, Black, Rustfmt, Clang-format...)
- 🌳 **Treesitter** — Syntax highlighting chính xác, text objects, incremental selection
- 🖥️ **Terminal tích hợp** — Code runner 1 chạm cho mọi ngôn ngữ
- 🔌 **Plugin manager** — lazy.nvim với lazy loading, startup < 200ms
- 📱 **Tối ưu cho Android** — Ít RAM, tắt animations, auto-save khi mất focus
- 🔀 **Git integration** — Gitsigns, Lazygit, Diffview

---

## 📋 Yêu cầu hệ thống

| Yêu cầu | Tối thiểu | Khuyến nghị |
|----------|-----------|-------------|
| Android | 7.0+ | 10.0+ |
| RAM | 2GB | 4GB+ |
| Storage | 500MB trống | 1GB+ |
| Termux | F-Droid version | Latest F-Droid |

> ⚠️ **KHÔNG** cài Termux từ Play Store (phiên bản cũ, không maintained)

---

## ⚡ Quick Start (3 bước)

### Bước 1: Cài Termux
Tải từ F-Droid: https://f-droid.org/packages/com.termux/

### Bước 2: Chạy setup script
```bash
# Trong Termux:
pkg install git
git clone https://github.com/anhduyalpha/nvim-android.git
cd nvim-android
bash scripts/setup-termux.sh
```

### Bước 3: Mở Neovim
```bash
nvim
```
Plugin sẽ tự động cài đặt lần đầu. Chờ hoàn thành là xong!

---

## 🎹 Keybinding Cheat Sheet

### Chung
| Key | Action |
|-----|--------|
| `Space` | Leader key |
| `jk` / `jj` | Thoát insert mode |
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<Esc>` | Clear search highlight |

### Navigation
| Key | Action |
|-----|--------|
| `<leader>ff` | Tìm file |
| `<leader>fg` | Grep (tìm trong code) |
| `<leader>fb` | Danh sách buffer |
| `<leader>fr` | File gần đây |
| `<leader>e` | Toggle file explorer |
| `<leader>E` | Mở file hiện tại trong explorer |
| `s` | Flash jump (nhảy anywhere trên màn hình) |
| `<S-h>` / `<S-l>` | Chuyển buffer trước/sau |

### Code
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format code |
| `]d` / `[d` | Next/prev diagnostic |

### Git
| Key | Action |
|-----|--------|
| `]h` / `[h` | Next/prev hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `<leader>gd` | Diff this |
| `<leader>gg` | Lazygit |

### Debug (DAP)
| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>ds` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>du` | Toggle DAP UI |

### Terminal & Run
| Key | Action |
|-----|--------|
| `<leader>tt` | Toggle terminal |
| `<leader>tf` | Float terminal |
| `<leader>rr` | Run file hiện tại |
| `<leader>rf` | Run với arguments |
| `jk` (trong terminal) | Thoát terminal mode |

### Window & Buffer
| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Chuyển window |
| `<leader>-` | Horizontal split |
| `<leader>\|` | Vertical split |
| `<leader>bd` | Đóng buffer |
| `<leader>bo` | Đóng buffer khác |

### Tìm kiếm
| Key | Action |
|-----|--------|
| `<leader>fs` | Grep string under cursor |
| `<leader>fd` | Diagnostics |
| `<leader>fc` | Commands |
| `<leader>fk` | Keymaps |
| `<leader>ft` | Find TODOs |

---

## 🗂️ Cấu hình ngôn ngữ

Mỗi ngôn ngữ được cấu hình riêng trong `lua/plugins/lang/`:

| Ngôn ngữ | LSP | Formatter | Linter | DAP | Test |
|----------|-----|-----------|--------|-----|------|
| Lua | lua_ls | stylua | — | — | — |
| Python | pyright | black | ruff | debugpy | neotest |
| JS/TS | ts_ls | prettier | eslint | js-debug | — |
| Rust | rust-analyzer | rustfmt | clippy | codelldb | neotest |
| Go | gopls | goimports | — | delve | neotest |
| C/C++ | clangd | clang-format | — | codelldb | — |
| Java | jdtls* | google-java-format | — | java-debug | — |
| Web | html/cssls/jsonls | prettier | — | — | — |
| Markdown | marksman | prettier | — | — | — |

> *Java LSP mặc định TẮT vì rất nặng. Bật trong `lua/config/options.lua`: `java_lsp = true`

---

## ⚙️ Feature Toggles

Chỉnh sửa trong `lua/config/options.lua` hoặc tạo `lua/config/user.lua` (gitignored):

```lua
-- lua/config/user.lua
vim.g.nvim_android_features = {
  copilot = false,           -- AI completion (heavy)
  noice = false,             -- UI enhancements (heavy)
  java_lsp = false,          -- Java LSP (very heavy)
  fancy_dashboard = true,    -- Welcome screen
  git_signs = true,          -- Git decorations
  debug = true,              -- Debug adapter
  indent_guides = true,      -- Indent lines
  bufferline = true,         -- Tab bar
  illuminate = true,         -- Word highlight
  flash = true,              -- Quick jump
  zen_mode = true,           -- Distraction-free
  undotree = true,           -- Undo visualizer
  harpoon = true,            -- Quick file nav
}
```

---

## 🔧 Troubleshooting

### Plugin không load
```bash
# Trong Neovim:
:Lazy        # Kiểm tra trạng thái plugin
:checkhealth # Kiểm tra health
```

### Treesitter build lỗi
```bash
# Cài compiler:
pkg install clang
```

### LSP không hoạt động
```bash
# Trong Neovim:
:Mason       # Kiểm tra LSP servers
:LspInfo     # Kiểm tra LSP status
```

### Clipboard không copy/paste
```bash
# Cài termux-api app trên Android, sau đó:
pkg install termux-api
```

### Startup chậm
```bash
# Benchmark:
nvim --startuptime startup.log
# Xem file startup.log để biết plugin nào chậm
```

### Thiếu bộ nhớ
- Đóng buffer thừa: `<leader>bo`
- Tắt features nặng trong `lua/config/user.lua`
- Chạy `:Lazy` và unload plugin không cần thiết

---

## ❓ FAQ

**Q: Tại sao không dùng Play Store Termux?**
A: Play Store version cũ, không maintained, có thể gây lỗi.

**Q: Cài được Nerd Font không?**
A: Termux không hỗ trợ Nerd Font native. Plugin đã cấu hình fallback icons.

**Q: Copilot hoạt động được không?**
A: Có, nhưng mặc định TẮT. Bật: `copilot = true` trong features.

**Q: RAM tối thiểu là bao nhiêu?**
A: 2GB RAM, nhưng 4GB+ sẽ mượt hơn nhiều.

**Q: Có thể dùng với Neovim distro khác (AstroNvim, NvChad)?**
A: Config này dựa trên LazyVim. Không tương thích trực tiếp với distro khác.

---

## 🤝 Contributing

1. Fork repo
2. Tạo feature branch: `git checkout -b feature/my-feature`
3. Commit: `git commit -m "feat: add my feature"`
4. Push: `git push origin feature/my-feature`
5. Tạo Pull Request

---

## 📄 License

MIT License

## 🙏 Credits

- [Neovim](https://neovim.io) — Editor
- [LazyVim](https://www.lazyvim.org) — Base framework
- [lazy.nvim](https://github.com/folke/lazy.nvim) — Plugin manager
- [Termux](https://termux.dev) — Android terminal emulator
