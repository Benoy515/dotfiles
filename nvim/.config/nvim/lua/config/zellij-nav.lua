-- Seamless window/pane nav across nvim splits and zellij panes.
-- Companion: zellij-autolock in zellij/config.kdl locks zellij while nvim is
-- the focused command, so Ctrl+hjkl pass through to nvim instead of being
-- intercepted by zellij keybinds.
require("zellij-nav").setup()

local map = vim.keymap.set
map("n", "<C-h>", "<cmd>ZellijNavigateLeft<cr>",  { silent = true, desc = "Nav left  (nvim/zellij)" })
map("n", "<C-j>", "<cmd>ZellijNavigateDown<cr>",  { silent = true, desc = "Nav down  (nvim/zellij)" })
map("n", "<C-k>", "<cmd>ZellijNavigateUp<cr>",    { silent = true, desc = "Nav up    (nvim/zellij)" })
map("n", "<C-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "Nav right (nvim/zellij)" })
