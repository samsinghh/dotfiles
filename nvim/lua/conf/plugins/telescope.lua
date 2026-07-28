return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  opts = {},
  keys = {
    { "<leader>fg", function() require("telescope.builtin").git_files() end, desc = "Find Git files" },
    { "<leader>fr", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
    { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Find buffers" },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").find_files({ hidden = true })
      end,
      desc = "Find hidden files",
    },
    {
      "<leader>fF",
      function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.input("Search dir: ", vim.fn.getcwd() .. "/", "dir"),
        })
      end,
      desc = "Find files in chosen directory",
    },
  },
}
