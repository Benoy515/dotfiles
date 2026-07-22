local opt = vim.opt

-- Disable unused language providers. These only exist for plugins written IN
-- these languages (remote plugins); LSP/treesitter/completion don't use them.
-- The python3 provider in particular shelled out to detect a pynvim host on
-- every .py open, adding ~65ms to startup.
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

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
-- Left empty on purpose: `unnamedplus` would route every register write
-- (yanks AND deletes/changes) to the system clipboard. Instead we mirror only
-- explicit yanks to `+` in config/yank.lua, so deletes/changes stay Vim-local.
opt.clipboard = ""

opt.completeopt = "menu,menuone,noselect,fuzzy,popup"

vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  severity_sort = true,
  float = { border = "rounded", source = true },
  underline = true,
  update_in_insert = false,
})
