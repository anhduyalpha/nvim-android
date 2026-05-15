-- plugins/lang/web.lua — Web development support
-- HTML, CSS, JSON, YAML LSPs + Emmet + Colorizer

return {
  -- ── Web LSPs ───────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {
          settings = {
            html = {
              format = { wrapLineLength = 120 },
            },
          },
        },
        cssls = {
          settings = {
            css = { validate = true },
            scss = { validate = true },
            less = { validate = true },
          },
        },
        jsonls = {
          settings = {
            json = {
              validate = { enable = true },
              format = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://json.schemastore.org/docker-compose.yml"] = "docker-compose*.{yml,yaml}",
              },
            },
          },
        },
        -- Tailwind CSS (optional)
        -- tailwindcss = {},
      },
    },
  },

  -- ── Emmet (HTML/CSS shorthand expansion) ───────────────
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "scss", "javascriptreact", "typescriptreact", "vue", "svelte" },
    init = function()
      vim.g.user_emmet_leader_key = "<C-z>"
    end,
  },

  -- ── Colorizer (show colors inline) ─────────────────────
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,  -- Disable named colors for performance
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        mode = "background",
        tailwind = true,
        sass = { enable = false },
        virtualtext = "■",
      },
    },
  },

  -- ── CSS LSP for class names (optional) ─────────────────
  -- {
  --   "luckasRanaworktree/tailwind-sorter.nvim",
  --   ft = { "html", "css", "javascriptreact", "typescriptreact" },
  --   dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
  --   build = "cd formatter && npm i && npm run build",
  --   config = true,
  -- },

  -- ── Formatter (prettier) ───────────────────────────────
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
      },
    },
  },
}
