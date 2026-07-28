return {
  "lervag/vimtex",
  lazy = false, -- VimTeX recommends against lazy-loading; it manages its own ft hooks
  init = function()
    if vim.fn.has("macunix") == 1 then
      -- Skim provides forward search and auto-refresh on macOS.
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1
    end

    -- build with latexmk
    vim.g.vimtex_compiler_method = "latexmk"

    -- don't pop open the quickfix list for warnings (only for real errors)
    vim.g.vimtex_quickfix_open_on_warning = 0

    -- If your resume needs XeLaTeX (custom fonts / fontspec), uncomment:
    -- vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }
  end,
}
