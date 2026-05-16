-- plugins/lsp.lua — LSP configuration for LazyVim
-- Lazy-loaded per filetype, memory-optimized for Android

local android = require("util.android")

return {
  -- ── Mason (LSP installer) ──────────────────────────────
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = android.is_termux() and {} or {
        -- Formatters
        "stylua",
        "shfmt",
        "clang-format",
        -- Linters
        "shellcheck",
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
        -- Only servers that Mason can install on Android/Termux
        -- clangd → pkg install clang (system)
        -- lua_ls → pkg install luarocks then luarocks install lua-lsp-server (system)
        -- rust_analyzer → rustup component add rust-analyzer (system)
        "pyright",
        "vtsls",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
        "gopls",
      },
      -- Disable automatic_installation to prevent picking up non-LSP tools (stylua, shfmt...)
      automatic_installation = false,
      -- NO default handler — all servers are setup by lspconfig's config function
      -- which has the merged opts from all lang/*.lua specs (clangd, pyright, etc.)
      handlers = {},
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
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
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end
      capabilities = vim.tbl_deep_extend("force", capabilities, opts.capabilities or {})

      local lspconfig = require("lspconfig")

      -- Setup mason-managed servers using its built-in handler
      local has_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
      if has_mason_lspconfig then
        mason_lspconfig.setup_handlers({
          function(server_name)
            local server_opts = vim.tbl_deep_extend("force", {
              capabilities = vim.deepcopy(capabilities),
            }, opts.servers[server_name] or {})
            
            lspconfig[server_name].setup(server_opts)
          end,
        })
      end

      -- Manually setup servers that are in opts.servers but NOT managed by mason
      -- (e.g. clangd installed via termux pkg, not via mason)
      for server, server_opts in pairs(opts.servers) do
        if server_opts then
          local is_mason_installed = false
          if has_mason_lspconfig then
            local installed = mason_lspconfig.get_installed_servers()
            for _, s in ipairs(installed) do
              if s == server then
                is_mason_installed = true
                break
              end
            end
          end
          
          if not is_mason_installed and type(lspconfig[server]) == "table" and lspconfig[server].setup then
            local final_opts = vim.tbl_deep_extend("force", {
              capabilities = vim.deepcopy(capabilities),
            }, server_opts)
            lspconfig[server].setup(final_opts)
          end
        end
      end
    end,
  },

  -- ── Conform (formatter) ────────────────────────────────
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    -- Do NOT set format_on_save here — LazyVim handles it automatically
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
