require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("mini.pairs").setup()
require("mini.comment").setup()
require("mini.surround").setup()
require("mini.move").setup()
require("mini.statusline").setup({
  use_icons = true,
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local git = MiniStatusline.section_git({ trunc_width = 40 })
      local diff = MiniStatusline.section_diff({ trunc_width = 75 })
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })

      return MiniStatusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git, diff } },
        "%<",
        "%=",
        { hl = "MiniStatuslineFilename", strings = { filename } },
      })
    end,
  },
})
require("mini.animate").setup({
  cursor = { enable = false },
})

require("mini.files").setup({
  windows = { preview = true, width_preview = 50 },
  mappings = {
    go_in_plus = "<CR>",
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    vim.keymap.set("n", "<Esc>", function()
      require("mini.files").close()
    end, { buffer = args.data.buf_id, desc = "Close mini.files" })
  end,
})

vim.keymap.set("n", "<leader>e", function()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local path = buf_name ~= "" and buf_name or vim.fn.getcwd()
  require("mini.files").open(path)
end, { desc = "File explorer" })
