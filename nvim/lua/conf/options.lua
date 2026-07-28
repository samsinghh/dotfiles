local options = {
  backup = false,
  clipboard = "unnamedplus",
  cmdheight = 2,
  completeopt = { "menuone", "noselect" },
  conceallevel = 0,
  fileencoding = "utf-8",
  hlsearch = true,
  incsearch = true,
  ignorecase = true,
  ro = false,
  mouse = "a",
  pumheight = 10,
  showmode = false,
  showtabline = 2,
  smartcase = true,
  smartindent = true,
  splitbelow = true,
  splitright = true,
  swapfile = true,
  termguicolors = true,
  timeoutlen = 1000,
  undofile = true,
  updatetime = 300,
  writebackup = true,
  expandtab = true,
  shiftwidth = 4,
  tabstop = 4,
  cursorline = false,
  number = true,
  relativenumber = true,
  numberwidth = 4,
  signcolumn = "yes",
  wrap = false,
  scrolloff = 4,
  sidescrolloff = 4,
  -- guifont = "Cascadia_Mono:h10",
  guifont = "JetBrainsMono_Nerd_Font:h11",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

local state_dir = vim.fn.stdpath("state")
for _, name in ipairs({ "backup", "swap", "undo" }) do
  local path = state_dir .. "/" .. name
  pcall(vim.fn.mkdir, path, "p")
  assert(vim.fn.isdirectory(path) == 1, "Failed to create Neovim state directory: " .. path)
end
vim.opt.backupdir = state_dir .. "/backup//"
vim.opt.directory = state_dir .. "/swap//"
vim.opt.undodir = state_dir .. "/undo//"

-- Create an autocommand group for file-specific settings
vim.api.nvim_create_augroup("FileTypeSpecific", { clear = true })

-- Set shiftwidth and tabstop to 2 for HTML, CSS, JavaScript, and Lua files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "css", "javascript", "lua" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
  group = "FileTypeSpecific",
})

-- Disable automatic comment insertion
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

vim.opt.shortmess:append("c")

-- Relative numbers in normal mode, absolute in insert / command mode.
local function skip_numbering()
  return vim.bo.filetype == "NvimTree"
end

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  callback = function()
    if skip_numbering() then
      return
    end
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" }, {
  callback = function()
    if skip_numbering() then
      return
    end
    vim.opt_local.relativenumber = true
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      higroup = "incsearch",
      timeout = 200,
      on_visual = true,
    })
  end,
})

vim.opt.fillchars:append({ eob = " " })
