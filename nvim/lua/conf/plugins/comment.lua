return {
  "numtoStr/Comment.nvim",
  opts = {},
  keys = {
    { "gcc", mode = "n", desc = "Comment toggle current line" },
    { "gbc", mode = "n", desc = "Comment toggle current block" },
    { "gc", mode = { "n", "x" }, desc = "Comment toggle linewise" },
    { "gb", mode = { "n", "x" }, desc = "Comment toggle blockwise" },
  },
}
