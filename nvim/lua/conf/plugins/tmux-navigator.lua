return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", mode = { "n", "t" }, desc = "Navigate left" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", mode = { "n", "t" }, desc = "Navigate down" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", mode = { "n", "t" }, desc = "Navigate up" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", mode = { "n", "t" }, desc = "Navigate right" },
    { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", mode = { "n", "t" }, desc = "Navigate previous" },
  },
}
