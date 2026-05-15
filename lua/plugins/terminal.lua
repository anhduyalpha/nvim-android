-- plugins/terminal.lua — Terminal & code runner integration
-- toggleterm.nvim with multi-language code runner

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal size=10<cr>", desc = "Horizontal terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=40<cr>", desc = "Vertical terminal" },
      { "<leader>rr", desc = "Run current file" },
      { "<leader>rl", desc = "Run last command" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 10
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = false,  -- Disable shading for performance
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,  -- No transparency for performance
      },
    },
    config = function(_, opts)
      local toggleterm = require("toggleterm")
      toggleterm.setup(opts)

      -- ── Code Runner ───────────────────────────────────
      local runners = {
        python = "python3 %",
        javascript = "node %",
        typescript = "npx tsx %",
        lua = "lua %",
        rust = "cargo run",
        go = "go run %",
        c = "gcc % -o %< && ./%<",
        cpp = "g++ % -o %< && ./%<",
        java = "javac % && java %<",
        sh = "bash %",
        bash = "bash %",
      }

      -- Run current file
      vim.keymap.set("n", "<leader>rr", function()
        local ft = vim.bo.filetype
        local cmd = runners[ft]
        if not cmd then
          vim.notify("No runner configured for: " .. ft, vim.log.levels.WARN)
          return
        end

        -- Save file first
        vim.cmd("w")

        -- Replace % with current file
        local file = vim.fn.expand("%")
        local file_noext = vim.fn.expand("%:r")
        cmd = cmd:gsub("%%<", file_noext):gsub("%%", file)

        local Terminal = require("toggleterm.terminal").Terminal
        local runner = Terminal:new({
          cmd = cmd,
          direction = "horizontal",
          size = 10,
          close_on_exit = false,
          on_open = function(term)
            vim.cmd("startinsert!")
            -- Close with q
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
          end,
        })
        runner:toggle()
      end, { desc = "Run current file" })

      -- Run with arguments
      vim.keymap.set("n", "<leader>rf", function()
        local ft = vim.bo.filetype
        local cmd = runners[ft]
        if not cmd then
          vim.notify("No runner configured for: " .. ft, vim.log.levels.WARN)
          return
        end

        local args = vim.fn.input("Arguments: ")
        vim.cmd("w")

        local file = vim.fn.expand("%")
        local file_noext = vim.fn.expand("%:r")
        cmd = cmd:gsub("%%<", file_noext):gsub("%%", file) .. " " .. args

        local Terminal = require("toggleterm.terminal").Terminal
        local runner = Terminal:new({
          cmd = cmd,
          direction = "horizontal",
          size = 10,
          close_on_exit = false,
          on_open = function()
            vim.cmd("startinsert!")
          end,
        })
        runner:toggle()
      end, { desc = "Run with arguments" })

      -- Run last command
      local last_cmd = nil
      vim.keymap.set("n", "<leader>rl", function()
        if not last_cmd then
          vim.notify("No previous command", vim.log.levels.INFO)
          return
        end
        local Terminal = require("toggleterm.terminal").Terminal
        local runner = Terminal:new({
          cmd = last_cmd,
          direction = "horizontal",
          size = 10,
          close_on_exit = false,
          on_open = function()
            vim.cmd("startinsert!")
          end,
        })
        runner:toggle()
      end, { desc = "Run last command" })
    end,
  },
}
