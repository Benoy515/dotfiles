require("kanagawa").setup({
  compile = false,
  undercurl = true,
  transparent = false,
  dimInactive = true,
  terminalColors = true,
  theme = "wave",
  background = { dark = "wave", light = "lotus" },
})

vim.cmd.colorscheme("kanagawa")
