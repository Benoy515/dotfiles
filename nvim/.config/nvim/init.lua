vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")
require("plugins")

require("config.theme")
require("config.mini")
require("config.treesitter")
require("config.lsp")
require("config.completion")
require("config.fzf")
require("config.gitsigns")
require("config.whichkey")
require("config.conform")
require("config.zellij-nav")

require("autocmds")
