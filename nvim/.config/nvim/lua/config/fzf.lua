local fzf = require("fzf-lua")

fzf.setup({
  "default-title",
  fzf_opts = { ["--wrap"] = true },
  buffers = {
    fzf_opts = {
      ["--delimiter"] = require("fzf-lua").utils.nbsp,
      ["--with-nth"] = "-2..",
    },
  },
})

local map = vim.keymap.set
map("n", "<leader>ff", fzf.files, { desc = "Find files" })
map("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
map("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
map("n", "<leader>fh", fzf.helptags, { desc = "Help tags" })
map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
map("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "Doc symbols" })
map("n", "<leader>fS", fzf.lsp_live_workspace_symbols, { desc = "Workspace symbols" })
map("n", "<leader>fd", fzf.diagnostics_workspace, { desc = "Diagnostics" })
map("n", "<leader>fk", fzf.keymaps, { desc = "Keymaps" })
map("n", "<leader>f/", fzf.lgrep_curbuf, { desc = "Grep current buffer" })
map("n", "<leader>fc", fzf.commands, { desc = "Commands" })
map("n", "<leader>fR", fzf.resume, { desc = "Resume picker" })
