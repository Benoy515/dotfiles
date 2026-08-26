local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")

map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit" })

-- <C-^> toggles between the current and the previously-edited buffer. Great
-- motion, unreachable key (it's really Ctrl-Shift-6).
map("n", "<leader><leader>", "<C-^>", { desc = "Last buffer" })

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "J", "mzJ`z")

-- H/L jump to line start/end (shadows screen-top/bottom motions).
map({ "n", "x", "o" }, "H", "^", { desc = "First non-blank char" })
map({ "n", "x", "o" }, "L", "$", { desc = "End of line" })

map("v", "<", "<gv")
map("v", ">", ">gv")

map("v", "p", "P", { desc = "Paste without yanking replaced" })

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window/pane management — mirror zellij tmux-mode keys with <C-w> prefix.
map("n", "<C-w>|", "<cmd>vsplit<CR>", { desc = "Split right" })
map("n", "<C-w>-", "<cmd>split<CR>",  { desc = "Split down" })
map("n", "<C-w>x", "<cmd>close<CR>",  { desc = "Close pane" })
map("n", "<C-w>o", "<C-w>w",          { desc = "Cycle focus" })

map("n", "<C-w>z", function()
  if vim.t.zoomed then
    vim.cmd("wincmd =")
    vim.t.zoomed = false
  else
    vim.cmd("wincmd _ | wincmd |")
    vim.t.zoomed = true
  end
end, { desc = "Zoom toggle" })

local function swap_window(dir)
  local cur = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. dir)
  local other = vim.api.nvim_get_current_win()
  if cur == other then return end
  local cur_buf, other_buf = vim.api.nvim_win_get_buf(cur), vim.api.nvim_win_get_buf(other)
  vim.api.nvim_win_set_buf(cur, other_buf)
  vim.api.nvim_win_set_buf(other, cur_buf)
end
map("n", "<C-w>{", function() swap_window("h") end, { desc = "Swap pane left" })
map("n", "<C-w>}", function() swap_window("l") end, { desc = "Swap pane right" })
