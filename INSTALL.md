# 📱 Hướng dẫn cài đặt nvim-android

> Step-by-step guide cho người mới, từ cài Termux đến chạy Neovim hoàn chỉnh.

---

## Step 1: Cài Termux

> ⚠️ **QUAN TRỌNG:** Cài từ F-Droid, KHÔNG phải Play Store!

1. Mở trình duyệt trên Android
2. Truy cập: https://f-droid.org/packages/com.termux/
3. Tải và cài đặt file APK mới nhất
4. Cấp quyền cài đặt từ nguồn không xác định (nếu được hỏi)

---

## Step 2: Setup Termux

Mở Termux và chạy lần lượt:

```bash
# Cập nhật packages
pkg update && pkg upgrade -y

# Cài git (cần để clone repo)
pkg install git -y

# Cấp quyền truy cập storage (để lưu file)
termux-setup-storage
```

---

## Step 3: Clone & Install

```bash
# Clone repo
git clone https://github.com/anhduyalpha/nvim-android.git
cd nvim-android

# Chạy setup script (tự động cài mọi thứ)
bash scripts/setup-termux.sh
```

Script sẽ tự động:
- ✅ Cập nhật packages
- ✅ Cài dependencies (git, node, python, ripgrep, fd, lazygit, clang...)
- ✅ Cài Neovim
- ✅ Cài termux-api (clipboard support)
- ✅ Clone config vào `~/.config/nvim`

---

## Step 4: Chọn ngôn ngữ (tùy chọn)

```bash
# Chạy interactive menu để cài ngôn ngữ bạn cần
bash scripts/install-deps.sh
```

Chọn ngôn ngữ:
- **[1] Python** — ~50MB
- **[2] JavaScript/TypeScript** — ~80MB
- **[3] Rust** — ~200MB
- **[4] Go** — ~150MB
- **[5] C/C++** — ~100MB
- **[6] Java** — ~500MB (⚠️ rất nặng)
- **[7] All** — ~700MB+

> 💡 Bạn có thể cài sau bằng cách chạy lại script này.

---

## Step 5: Verify installation

```bash
# Mở Neovim
nvim
```

Lần đầu mở:
1. **Lazy.nvim** sẽ tự động cài đặt tất cả plugins (~1-2 phút)
2. Đợi cho đến khi thấy dashboard
3. Kiểm tra: `:Lazy` → tất cả plugin should be green ✅
4. Kiểm tra LSP: `:Mason` → servers đã installed
5. Kiểm tra health: `:checkhealth`

---

## Step 6: Cấu hình Termux (tùy chọn)

Sao chép config Termux đề xuất:

```bash
# Tạo thư mục config
mkdir -p ~/.termux

# Copy config
cp config/termux/termux.properties ~/.termux/termux.properties

# Reload Termux settings
termux-reload-settings
```

Config này:
- Thêm hàng phím tắt (ESC, CTRL, ALT, mũi tên)
- Volume keys thành phím ảo
- Back key thành Escape (rất hữu ích cho Neovim)

---

## ❌ Troubleshooting khi cài

### Lỗi: `pkg: command not found`
```bash
apt update && apt install -y apt-utils
```

### Lỗi: Neovim version quá cũ
```bash
# Thử cài từ source:
pkg install -y neovim
nvim --version  # Phải >= 0.10.0
```

### Lỗi: Treesitter build fail
```bash
pkg install -y clang
```

### Lỗi: Plugin clone fail (network)
```bash
# Thử dùng mirror:
git config --global url."https://hub.fastgit.xyz/".insteadOf "https://github.com/"
```

### Lỗi: Không đủ bộ nhớ
- Đóng app khác trên Android
- Chỉ cài ngôn ngữ bạn thật sự cần
- Tắt features nặng trong `lua/config/user.lua`

### Lỗi: Clipboard không hoạt động
```bash
# Cài Termux:API app từ F-Droid
# Sau đó trong Termux:
pkg install termux-api
```

---

## 🔄 Cập nhật

```bash
cd ~/.config/nvim
git pull

# Cập nhật plugins (trong Neovim)
# :Lazy update

# Cập nhật LSP servers
# :MasonUpdate
```

---

## 🗑️ Gỡ cài đặt

```bash
# Xóa config
rm -rf ~/.config/nvim

# Xóa plugins & data
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim

# Xóa Termux hoàn toàn
# Settings → Apps → Termux → Uninstall
```

---

## 💡 Tips cho người mới

1. **Nhớ leader key là `Space`** — Nhấn Space rồi chờ, which-key sẽ hiện gợi ý
2. **Thoát insert mode bằng `jk`** — Dễ bấm hơn Esc trên mobile
3. **`<leader>ff`** — Phím tắt quan trọng nhất, tìm mọi file
4. **`<leader>fg`** — Tìm trong code (grep)
5. **`gd`** — Nhảy đến definition của function/class
6. **`K`** — Xem documentation
7. **`<leader>rr`** — Chạy file hiện tại (1 chạm!)

---

Chúc bạn code vui! 🎉
