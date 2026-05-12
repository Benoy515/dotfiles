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
  automatic_enable = true,
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
