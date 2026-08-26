local wk = require("which-key")

wk.setup({ preset = "modern" })

wk.add({
  { "<leader>f", group = "find" },
  { "<leader>h", group = "hunks" },
  { "<leader>l", group = "lsp" },
  { "<leader>m", group = "harpoon" },
  { "<leader>t", group = "toggle" },
  -- Harpoon slots are pure muscle memory; keep them out of the popup.
  { "<leader>1", hidden = true },
  { "<leader>2", hidden = true },
  { "<leader>3", hidden = true },
  { "<leader>4", hidden = true },
  { "<leader>5", hidden = true },
})
