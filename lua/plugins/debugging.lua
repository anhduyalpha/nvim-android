-- plugins/debugging.lua — DAP (Debug Adapter Protocol) configuration
-- Default: Python, JS/Node, C/C++. Optional: Rust, Go, Java

local features = vim.g.nvim_android_features or {}

return {
  {
    "mfussenegger/nvim-dap",
    enabled = features.debug ~= false,
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>ds", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    },
    config = function()
      local dap = require("dap")
      local android = require("util.android")

      -- ── Python ────────────────────────────────────────
      dap.adapters.python = {
        type = "executable",
        command = "python3",
        args = { "-m", "debugpy.adapter" },
      }
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv then
              return venv .. "/bin/python3"
            end
            return "python3"
          end,
        },
      }

      -- ── JavaScript/Node ───────────────────────────────
      if android.has_feature("node") then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = {
            command = "node",
            args = { vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/jsDebug/src/dapDebugServer.js", "${port}" },
          },
        }
        dap.configurations.javascript = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
        }
        dap.configurations.typescript = dap.configurations.javascript
      end

      -- ── C/C++ (codelldb via Mason) ────────────────────
      local codelldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
      if vim.fn.filereadable(codelldb_path) == 1 then
        dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = {
            command = codelldb_path,
            args = { "--port", "${port}" },
          },
        }
        dap.configurations.c = {
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
        }
        dap.configurations.cpp = dap.configurations.c
      else
        -- Fallback: use gdb if codelldb not installed
        vim.notify("⚠️ codelldb not found at: " .. codelldb_path .. "\nRun :MasonInstall codelldb or install gdb manually.", vim.log.levels.WARN)
      end
    end,
  },

  -- ── DAP UI ─────────────────────────────────────────────
  {
    "rcarriga/nvim-dap-ui",
    enabled = features.debug ~= false,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    },
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          position = "left",
          size = 30,
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 10,
        },
      },
    },
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup(opts)
      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },

  -- ── Virtual text (inline debug values) ─────────────────
  {
    "theHamsta/nvim-dap-virtual-text",
    enabled = features.debug ~= false,
    event = "VeryLazy",
    opts = {
      commented = true,
      enabled = true,
      enabled_commands = true,
    },
  },

  -- ── Mason DAP (auto-install debuggers) ─────────────────
  {
    "jay-babu/mason-nvim-dap.nvim",
    enabled = features.debug ~= false,
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = {
        "python",
        "codelldb",
      },
      automatic_installation = true,
    },
  },
}
