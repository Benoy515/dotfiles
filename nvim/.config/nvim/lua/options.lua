local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true
opt.pumheight = 10
opt.winborder = "rounded"

opt.splitright = true
opt.splitbelow = true

opt.undofile = true
opt.confirm = true
opt.updatetime = 250
opt.timeoutlen = 300

opt.wrap = false
opt.linebreak = true

opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.completeopt = "menu,menuone,noselect,fuzzy,popup"

vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  severity_sort = true,
  float = { border = "rounded", source = true },
  underline = true,
  update_in_insert = false,
})
