return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown" },

  config = function()
    require("render-markdown").setup({
      -- raw markdown on the cursor line, rendered everywhere else
      render_modes = { "n", "c", "t" },

      heading = {
        position = "inline",
      },

      code = {
        style = "full",
        width = "block",
        min_width = 45,
      },
    })
  end,
}
