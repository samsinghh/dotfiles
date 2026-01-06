return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- recommended for ask()/select(); required if you choose the snacks provider
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    vim.g.opencode_opts = {
      -- Let opencode.nvim manage an instance if it can't find one in the CWD
      provider = {
        enabled = "terminal", -- or "snacks" if you prefer snacks.terminal
        terminal = {
          -- if you dislike being forced into insert mode in the opencode pane:
          auto_insert = false,
        },
      },

      -- optional: make buffer reloads work when opencode edits files
      events = {
        reload = true,
      },
    }

    -- Required for reload-on-edit behavior per README
    vim.o.autoread = true

    -- Keymaps: do NOT hijack Ctrl-x / Ctrl-a
    local op = require("opencode")
    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      op.ask("@this: ", { submit = true })
    end, { desc = "opencode: ask about selection/cursor" })

    vim.keymap.set({ "n", "x" }, "<leader>os", function()
      op.select()
    end, { desc = "opencode: select action/target" })

    vim.keymap.set({ "n", "t" }, "<leader>oo", function()
      op.toggle()
    end, { desc = "opencode: toggle UI" })

    -- Optional but very good: operator to send an arbitrary motion/range
    vim.keymap.set({ "n", "x" }, "go", function()
      return op.operator("@this ")
    end, { expr = true, desc = "opencode: add range (operator)" })
    vim.keymap.set("n", "goo", function()
      return op.operator("@this ") .. "_"
    end, { expr = true, desc = "opencode: add line" })
  end,
}

