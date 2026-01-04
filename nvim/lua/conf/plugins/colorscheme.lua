return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          treesitter = true,
          lsp_trouble = true,
          telescope = true,
          cmp = true,
          gitsigns = true,
        },
      })
    end,
  },
  {
    "datsfilipe/vesper.nvim",
    name = "vesper",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("vesper")
    end,
  },
}

