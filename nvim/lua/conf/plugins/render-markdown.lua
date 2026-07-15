return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown" },

  config = function()
       local function code_hl()
      for _, group in ipairs({
        "RenderMarkdownCode",
        "RenderMarkdownCodeInline",
      }) do
        vim.api.nvim_set_hl(0, group, { link = "NormalFloat" })
      end
    end
    code_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = code_hl })

    require("render-markdown").setup({
      -- modes that render at all; insert mode shows the raw buffer
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
