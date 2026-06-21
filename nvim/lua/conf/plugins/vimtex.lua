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

    -- If your resume needs XeLaTeX (custom fonts / fontspec), uncomment:
    -- vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }

    -- Auto-start continuous compilation when a TeX file opens, and open the
    -- viewer once the first build succeeds. After that, every :w refreshes the PDF.
    local group = vim.api.nvim_create_augroup("VimtexAutostart", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "VimtexEventInitPost",
      callback = function()
        vim.cmd("VimtexCompile")
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "VimtexEventCompileSuccess",
      callback = function()
        if not vim.b.vimtex_viewer_opened then
          vim.b.vimtex_viewer_opened = true
          vim.cmd("VimtexView")
        end
      end,
    })
  end,
}
