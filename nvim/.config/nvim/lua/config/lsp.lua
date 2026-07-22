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
-- chalk-nvim manages the chalk-lsp binary, activation, root detection, and
-- detaching competing Python LSPs. Client name is still "chalk_lsp".
require("chalk").setup()

vim.keymap.set("n", "<leader>ll", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if vim.tbl_isempty(clients) then
    vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
    return
  end
  local names = vim.tbl_map(function(c) return c.name end, clients)
  vim.notify("LSP: " .. table.concat(names, ", "))
end, { desc = "List active LSP clients" })

vim.keymap.set("n", "<leader>lcr", "<cmd>ChalkLspRestart<cr>", { desc = "Restart chalk_lsp" })
vim.keymap.set("n", "<leader>lcu", "<cmd>ChalkLspUpdate<cr>", { desc = "Update chalk_lsp" })
vim.keymap.set("n", "<leader>lci", "<cmd>ChalkLspInfo<cr>", { desc = "chalk_lsp info" })
