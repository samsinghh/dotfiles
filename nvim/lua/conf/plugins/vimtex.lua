return {
  "lervag/vimtex",
  lazy = false, -- VimTeX recommends against lazy-loading; it manages its own ft hooks
  init = function()
    -- viewer: Skim, with forward search + auto-refresh
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_view_skim_sync = 1      -- forward search after compile
    vim.g.vimtex_view_skim_activate = 1  -- bring Skim to focus

    -- build with latexmk
    vim.g.vimtex_compiler_method = "latexmk"

    -- don't pop open the quickfix list for warnings (only for real errors)
    vim.g.vimtex_quickfix_open_on_warning = 0

    -- If your resume needs XeLaTeX (custom fonts / fontspec), uncomment:
    -- vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }
  end,
}
