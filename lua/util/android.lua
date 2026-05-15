-- android.lua — Android/Termux detection & helper functions
-- Provides platform-specific utilities for running Neovim on Android via Termux

local M = {}

--- Detect if running on Android (any environment)
---@return boolean
function M.is_android()
  return vim.fn.has("android") == 1 or os.getenv("ANDROID_ROOT") ~= nil
end

--- Detect if running specifically inside Termux
---@return boolean
function M.is_termux()
  return vim.fn.isdirectory("/data/data/com.termux") == 1
    or os.getenv("TERMUX_VERSION") ~= nil
    or (M.is_android() and vim.fn.executable("termux-info") == 1)
end

--- Get the appropriate clipboard provider for the current environment
---@return string clipboard_provider
function M.get_clipboard_provider()
  if M.is_termux() then
    -- Use termux-clipboard if available
    if vim.fn.executable("termux-clipboard-set") == 1 then
      return "termux"
    end
    -- Fallback to OSC 52 (works in some Termux terminals)
    return "osc52"
  end
  -- Default: let Neovim auto-detect
  return ""
end

--- Get optimal cache directory for Android (limited storage)
---@return string cache_dir
function M.get_cache_dir()
  if M.is_termux() then
    local termux_cache = os.getenv("TMPDIR") or "/data/data/com.termux/files/usr/tmp"
    return termux_cache .. "/nvim-cache"
  end
  return vim.fn.stdpath("cache")
end

--- Check available system memory and notify if low
function M.notify_low_memory()
  if not M.is_android() then
    return
  end

  -- Read /proc/meminfo for available memory
  local meminfo = io.open("/proc/meminfo", "r")
  if not meminfo then
    return
  end

  local content = meminfo:read("*a")
  meminfo:close()

  local available = content:match("MemAvailable:%s*(%d+)")
  if available then
    local available_mb = tonumber(available) / 1024
    if available_mb < 500 then
      vim.notify(
        string.format("⚠️ Low memory: %.0fMB available. Consider closing buffers.", available_mb),
        vim.log.levels.WARN
      )
    end
  end
end

--- Check if a binary/feature is available on the system
---@param feature string binary name or feature identifier
---@return boolean
function M.has_feature(feature)
  -- Check common binary names
  local binary_map = {
    ripgrep = { "rg" },
    fd = { "fd", "fdfind" },
    lazygit = { "lazygit" },
    node = { "node" },
    python = { "python3", "python" },
    cargo = { "cargo" },
    go = { "go" },
    gcc = { "gcc", "clang" },
    gpp = { "g++", "clang++" },
    git = { "git" },
    curl = { "curl" },
    wget = { "wget" },
    unzip = { "unzip" },
    make = { "make" },
  }

  local binaries = binary_map[feature] or { feature }

  for _, bin in ipairs(binaries) do
    if vim.fn.executable(bin) == 1 then
      return true
    end
  end

  return false
end

--- Get system architecture
---@return string arch
function M.get_arch()
  local arch = vim.fn.system("uname -m"):gsub("%s+", "")
  return arch
end

--- Check if running in a limited resource environment
---@return boolean
function M.is_low_resource()
  if M.is_android() then
    return true
  end

  -- Check RAM
  local meminfo = io.open("/proc/meminfo", "r")
  if meminfo then
    local content = meminfo:read("*a")
    meminfo:close()
    local total = content:match("MemTotal:%s*(%d+)")
    if total and tonumber(total) / 1024 < 4096 then
      return true
    end
  end

  return false
end

--- Get recommended settings based on platform
---@return table settings
function M.get_platform_settings()
  local settings = {
    max_memory_mb = 150,
    undo_levels = 500,
    update_time = 500,
    max_file_length = 10000,
    completion_items = 10,
    debounce_ms = 150,
  }

  if M.is_android() then
    settings.max_memory_mb = 100
    settings.undo_levels = 300
    settings.update_time = 800
    settings.max_file_length = 5000
    settings.completion_items = 8
    settings.debounce_ms = 200
  end

  return settings
end

return M
