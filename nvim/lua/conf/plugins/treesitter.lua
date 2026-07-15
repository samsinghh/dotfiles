return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- the rewrite; requires Neovim 0.12+
  lazy = false,    -- upstream: "This plugin does not support lazy-loading."
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag", -- auto-close/auto-rename HTML/JSX/TSX tags
  },

  config = function()
    local ts = require("nvim-treesitter")

    -- setup() takes only install_dir; parsers and highlighting are separate.
    ts.setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    ts.install({
      "c",
      "cpp",
      "python",
      "html",
      "css",
      "matlab",
      "javascript",
      "typescript",
      "tsx",
      "lua",
      "vim",
      "vimdoc",
      "query",
      "markdown",
      "markdown_inline",
    })

    -- Filetypes, not parser names. 'tex' omitted: VimTeX has its own syntax.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "c",
        "cpp",
        "python",
        "html",
        "css",
        "matlab",
        "javascript",
        "typescript",
        "typescriptreact",
        "lua",
        "vim",
        "help",
        "query",
        "markdown",
      },
      callback = function()
        -- pcall: parser may still be installing
        if pcall(vim.treesitter.start) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    require("nvim-ts-autotag").setup()
  end,
}
