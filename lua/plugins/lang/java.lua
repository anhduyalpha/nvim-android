-- plugins/lang/java.lua — Java language support (OPTIONAL — very heavy)
-- LSP: jdtls, Formatter: google-java-format, DAP: java-debug-adapter
-- Disabled by default on Android due to high resource usage

local features = vim.g.nvim_android_features or {}

return {
  -- ── Java LSP (jdtls — HEAVY, disabled by default) ─────
  {
    "mfussenegger/nvim-jdtls",
    enabled = features.java_lsp == true,
    ft = "java",
    config = function()
      local jdtls = require("jdtls")
      local home = vim.fn.expand("~")
      local mason_path = vim.fn.stdpath("data") .. "/mason"

      local config = {
        cmd = { mason_path .. "/bin/jdtls" },
        root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
        settings = {
          java = {
            eclipse = { downloadSources = true },
            configuration = { updateBuildConfiguration = "interactive" },
            maven = { downloadSources = true },
            references = { includeDecompiledSources = true },
            format = { enabled = true },
            signatureHelp = { enabled = true },
            completion = {
              favoriteStaticMembers = {
                "org.assertj.core.api.Assertions.*",
                "org.junit.jupiter.api.Assertions.*",
              },
            },
          },
        },
        init_options = {
          bundles = {},
        },
      }

      jdtls.start_or_attach(config)
    end,
  },
}
