local opencode_cmd = "opencode --port"
local terminal_opts = {
  win = {
    position = "right",
    enter = false,
  },
}

return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- recommended for ask()/select(); required if you choose the snacks provider
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  init = function()
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open(opencode_cmd, terminal_opts)
        end,
      },
      events = {
        reload = true,
      },
    }

    -- Required for reload-on-edit behavior per README
    vim.o.autoread = true
  end,
  keys = {
    {
      "<leader>oa",
      function()
        require("opencode").ask("@this: ")
      end,
      mode = { "n", "x" },
      desc = "opencode: ask about selection/cursor",
    },
    {
      "<leader>os",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "opencode: select action/target",
    },
    {
      "<leader>oo",
      function()
        require("snacks.terminal").toggle(opencode_cmd, terminal_opts)
      end,
      mode = { "n", "t" },
      desc = "opencode: toggle UI",
    },
    {
      "<leader>or",
      function()
        return require("opencode").operator("@this ")
      end,
      mode = { "n", "x" },
      expr = true,
      desc = "opencode: add range",
    },
    {
      "<leader>ol",
      function()
        return require("opencode").operator("@this ") .. "_"
      end,
      expr = true,
      desc = "opencode: add line",
    },
  },
}
