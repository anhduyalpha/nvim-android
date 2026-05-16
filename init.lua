-- init.lua — Neovim entry point for nvim-android
-- This is the first file Neovim loads. It bootstraps everything.

-- Set leader key before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core options (performance-tuned for Termux/Android)
require("config.options")

-- Bootstrap lazy.nvim and load all plugins
require("config.lazy")
