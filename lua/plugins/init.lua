-- plugins/init.lua — Plugin entry point
-- This file is loaded by lazy.nvim and imports all plugin specs

-- Plugins are organized into separate files for maintainability:
-- ui.lua          — Theme, statusline, bufferline, dashboard
-- editor.lua      — Editor enhancement plugins (autopairs, surround, etc.)
-- treesitter.lua  — Syntax highlighting and text objects
-- lsp.lua         — Language Server Protocol configuration
-- completion.lua  — Auto-completion (nvim-cmp)
-- debugging.lua   — Debug Adapter Protocol (DAP)
-- git.lua         — Git integration
-- terminal.lua    — Terminal and code runner
-- navigation.lua  — Telescope, file explorer, quick jump
-- extras.lua      — Optional nice-to-have plugins
-- lang/*.lua      — Language-specific configurations

-- All plugins are lazy-loaded by default via lazy.nvim defaults
-- Each plugin spec should have: event, cmd, ft, or keys for lazy loading
