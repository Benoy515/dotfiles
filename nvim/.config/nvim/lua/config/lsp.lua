require("mason").setup({
  ui = { border = "rounded" },
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "pyright",
    "ts_ls",
    "rust_analyzer",
    "gopls",
    "jsonls",
    "yamlls",
    "bashls",
  },
  -- automatic_enable = { exclude = { "pyright" } },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
      diagnostics = { globals = { "vim", "MiniIcons" } },
      telemetry = { enable = false },
    },
  },

})
vim.lsp.config("chalk_lsp", {
  -- cmd = vim.lsp.rpc.connect('127.0.0.1', 9949),
  cmd = { '/Users/abhay/Development/chalk/chalk/chalk-rs/target/debug/chalk-lsp', 'lsp' },
  filetypes = { 'python' },
  root_markers = { 'chalk.yaml', 'chalk.yml' },
})
vim.lsp.enable("chalk_lsp")

vim.keymap.set("n", "<leader>ll", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if vim.tbl_isempty(clients) then
    vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
    return
  end
  local names = vim.tbl_map(function(c) return c.name end, clients)
  vim.notify("LSP: " .. table.concat(names, ", "))
end, { desc = "List active LSP clients" })

local chalk_enabled = true
vim.keymap.set("n", "<leader>lc", function()
  chalk_enabled = not chalk_enabled
  vim.lsp.enable("chalk_lsp", chalk_enabled)
  if not chalk_enabled then
    for _, c in ipairs(vim.lsp.get_clients({ name = "chalk_lsp" })) do
      vim.lsp.stop_client(c.id)
    end
    vim.notify("chalk_lsp disabled")
  else
    vim.cmd("edit")
    vim.notify("chalk_lsp enabled")
  end
end, { desc = "Toggle chalk_lsp" })
