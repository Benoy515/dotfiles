require("yanky").setup({
  ring = {
    history_length = 100,
    storage = "shada", -- persist yank history across sessions
  },
  highlight = {
    -- on_yank stays off: autocmds.lua already highlights via vim.hl.on_yank.
    on_yank = false,
    on_put = true, -- flash the text you just pasted
    timer = 200,
  },
  system_clipboard = {
    -- `clipboard` is empty (see options.lua), so tell yanky which register is
    -- the OS clipboard. sync_with_ring pulls external copies into the ring on
    -- focus so they show up when cycling with <C-p>.
    sync_with_ring = true,
    clipboard_register = "+",
  },
})

-- Clipboard policy: ONLY explicit yanks touch the system clipboard.
-- With `clipboard=""`, deletes/changes/x land in Vim registers only (still
-- pasteable in-Vim with `p`), never the OS clipboard. We bridge both ways:
local clip_group = vim.api.nvim_create_augroup("user-clipboard-yank-only", { clear = true })

-- Yank -> system clipboard. Skip deletes (`d`), changes (`c`), and yanks that
-- explicitly targeted a named register (e.g. "ay), which shouldn't clobber it.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = clip_group,
  callback = function()
    local ev = vim.v.event
    if ev.operator == "y" and ev.regname == "" then
      vim.fn.setreg("+", vim.fn.getreg('"'), vim.fn.getregtype('"'))
    end
  end,
})

-- External copy -> unnamed register, so plain `p` still pastes what you copied
-- outside Neovim. Guarded so it only fires when the clipboard actually differs.
vim.api.nvim_create_autocmd("FocusGained", {
  group = clip_group,
  callback = function()
    if vim.fn.getreg("+") ~= vim.fn.getreg('"') then
      vim.fn.setreg('"', vim.fn.getreg("+"), vim.fn.getregtype("+"))
    end
  end,
})

-- Put via yanky so pastes feed the ring (and can be cycled afterwards).
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put after" })
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put before" })
-- gp/gP: put and leave the cursor after the pasted text.
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "Put after (cursor past)" })
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "Put before (cursor past)" })

-- Paste the last *yank* specifically. Register 0 only ever receives yanks, so
-- this survives an intervening delete/change (which clobber the unnamed
-- register that plain `p` reads). remap=true is required for the <Plug> rhs.
vim.keymap.set("n", "<leader>p", '"0<Plug>(YankyPutAfter)',
  { remap = true, desc = "Paste last yank" })
vim.keymap.set("n", "<leader>P", '"0<Plug>(YankyPutBefore)',
  { remap = true, desc = "Paste last yank (before)" })
-- Over a selection, PutBefore is the register-preserving variant (:h v_P);
-- both replace the selection identically.
vim.keymap.set("x", "<leader>p", '"0<Plug>(YankyPutBefore)',
  { remap = true, desc = "Paste last yank over selection" })

-- Yank through yanky so it records into the ring.
vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)", { desc = "Yank" })

-- Right after a put, cycle backward/forward through yank history.
vim.keymap.set("n", "<C-p>", "<Plug>(YankyPreviousEntry)", { desc = "Cycle to older yank" })
vim.keymap.set("n", "<C-n>", "<Plug>(YankyNextEntry)", { desc = "Cycle to newer yank" })

-- Put and re-indent to the current line (handy for pasting blocks).
vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put below (reindent)" })
vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put above (reindent)" })

-- Browse the full yank ring.
vim.keymap.set("n", "<leader>yh", "<cmd>YankyRingHistory<cr>", { desc = "Yank history" })
