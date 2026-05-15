-- plugins/lsp.lua — LSP configuration for LazyVim
-- Lazy-loaded per filetype, memory-optimized for Android

local android = require("util.android")

return {
  -- ── Mason (LSP installer) ──────────────────────────────
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        -- Formatters
        "stylua",
        "shfmt",
        "clang-format",
        -- Linters
        "shellcheck",
        -- LSP
        "clangd",
      },
      -- Mason settings optimized for Termux
      pip = { upgrade_pip = not android.is_termux() },
      max_concurrent_installers = android.is_android() and 2 or 4,
    },
    config = function(_, opts)
      require("mason").setup(opts)
      -- Auto-install ensure_installed packages (deferred to avoid race with other plugins)
      vim.schedule(function()
        local mr = require("mason-registry")
        for _, tool in ipairs(opts.ensure_installed) do
          local ok, p = pcall(mr.get_package, tool)
          if ok and not p:is_installed() and not p:is_installing() then
            p:install()
          end
        end
      end)
    end,
  },

  -- ── Mason-LSPConfig bridge ─────────────────────────────
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      -- Auto-install these LSP servers
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ts_ls",
        "clangd",
      },
      -- Disable automatic_installation to prevent picking up non-LSP tools (stylua, shfmt...)
      automatic_installation = false,
      -- Handler: only setup servers that lspconfig knows about (suppress warnings for non-LSP)
      handlers = {
        [1] = function(server_name)
          local ok, lspconfig = pcall(require, "lspconfig")
          if ok and lspconfig[server_name] and lspconfig[server_name].setup then
            lspconfig[server_name].setup({})
          end
          -- Silently skip non-LSP tools (no warning)
        end,
      },
    },
  },

  -- ── Native LSP ─────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    opts = {
      -- Global LSP settings
      diagnostics = {
        underline = true,
        update_in_insert = false,  -- Save performance
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      -- Inlay hints off by default (heavy)
      inlay_hints = { enabled = false },
      -- Capabilities (reduced for performance)
      capabilities = {},
      -- Servers configured per-filetype in lang/*.lua
      servers = {},
    },
    config = function(_, opts)
      -- Setup diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- Global capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, opts.capabilities or {})

      -- Reduce capabilities for performance on Android
      if android.is_android() then
        capabilities.textDocument.completion.completionItem.snippetSupport = false
        capabilities.textDocument.completion.completionItem.resolveSupport = {
          properties = { "documentation", "detail", "additionalTextEdits" },
        }
      end

      -- Suppress lspconfig warnings for non-LSP tools during setup
      local orig_notify = vim.notify
      vim.notify = function(msg, level, opts)
        if level == vim.log.levels.WARN and type(msg) == "string" and msg:find("config.*not found") then
          return -- Skip "config X not found" warnings
        end
        return orig_notify(msg, level, opts)
      end

      -- Known valid LSP server names (filter out non-LSP tools like stylua, shfmt, *)
      local lspconfig = require("lspconfig")
      local valid_servers = {}
      for server, _ in pairs(lspconfig) do
        if type(lspconfig[server]) == "table" and lspconfig[server].setup then
          valid_servers[server] = true
        end
      end

      -- Setup servers from opts (only valid ones)
      for server, server_opts in pairs(opts.servers) do
        if valid_servers[server] then
          local final_opts = vim.tbl_deep_extend("force", {
            capabilities = vim.deepcopy(capabilities),
          }, server_opts or {})
          lspconfig[server].setup(final_opts)
        end
      end

      -- Restore original notify
      vim.notify = orig_notify
    end,
  },

  -- ── Conform (formatter) ────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        rust = { "rustfmt" },
        go = { "gofmt", "goimports" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    },
  },

  -- ── Lint ───────────────────────────────────────────────
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      linters_by_ft = {
        python = { "ruff" },
        javascript = { "eslint" },
        typescript = { "eslint" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      },
    },
    config = function(_, opts)
      require("lint").linters_by_ft = opts.linters_by_ft
      -- Auto-lint on save
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
