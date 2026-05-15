-- lazy.lua — Bootstrap lazy.nvim plugin manager
-- This file ensures lazy.nvim is installed and configured properly

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Lazy.nvim configuration optimized for Android
require("lazy").setup({
  spec = {
    -- Import LazyVim as base
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Import our custom plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = true,     -- Lazy load all plugins by default
    version = false,  -- Use latest git commit
  },
  install = {
    colorscheme = { "tokyonight", "habamax" },
  },
  checker = {
    enabled = false,  -- Disable auto-check for updates (saves resources)
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      -- Disable unused built-in plugins for faster startup
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  change_detection = {
    enabled = false,  -- Disable auto-reload on config change
    notify = false,
  },
})
