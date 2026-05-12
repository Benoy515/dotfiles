local wk = require("which-key")

wk.setup({ preset = "modern" })

wk.add({
  { "<leader>f", group = "find" },
  { "<leader>h", group = "hunks" },
  { "<leader>l", group = "lsp" },
  { "<leader>t", group = "toggle" },
})
