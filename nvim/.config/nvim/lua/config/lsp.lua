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

-- chalk-nvim exposes no disable API. Attaching is driven entirely by autocmds
-- in its `chalk_nvim` augroup, and setup() self-guards with a module-local
-- `configured` flag so calling it twice is a no-op. So: off = clear the augroup
-- and stop live clients; on = drop the module from package.loaded so a fresh
-- require resets that flag, then setup() rebuilds the augroup and sweeps open
-- buffers. Derive the state from the augroup rather than tracking our own
-- boolean, so it stays correct if chalk is reloaded by other means.
local function chalk_active()
  local ok, autocmds = pcall(vim.api.nvim_get_autocmds, { group = "chalk_nvim" })
  return ok and #autocmds > 0
end

vim.keymap.set("n", "<leader>lct", function()
  if chalk_active() then
    vim.api.nvim_clear_autocmds({ group = "chalk_nvim" })
    for _, client in ipairs(vim.lsp.get_clients({ name = "chalk_lsp" })) do
      client:stop(true)
    end
    -- Competing Python servers were detached, not disabled; they re-attach the
    -- next time a buffer is opened (`:e` on the current one to get one now).
    vim.notify("chalk_lsp: OFF", vim.log.levels.WARN)
  else
    package.loaded["chalk"] = nil
    require("chalk").setup()
    vim.notify("chalk_lsp: ON")
  end
end, { desc = "Toggle chalk_lsp" })
