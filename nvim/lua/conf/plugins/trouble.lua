return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
 config = function()
    require("trouble").setup()

    vim.keymap.set("n", "<leader>xx", "<cmd>Trouble toggle<cr>")
    vim.keymap.set("n", "<leader>xw", "<cmd>Trouble diagnostics<cr>")
    vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>")
    vim.keymap.set("n", "<leader>xr", "<cmd>Trouble lsp_references<cr>")
  end,
}
