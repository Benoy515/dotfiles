local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  group = augroup("user-yank-highlight", { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

autocmd("LspAttach", {
  group = augroup("user-lsp-attach", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    local fzf_ok, fzf = pcall(require, "fzf-lua")
    map("n", "gd", fzf_ok and fzf.lsp_definitions or vim.lsp.buf.definition, "Goto definition")
    map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
    map("n", "gy", fzf_ok and fzf.lsp_typedefs or vim.lsp.buf.type_definition, "Type definition")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "<leader>ls", vim.lsp.buf.signature_help, "Signature help")

    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      map("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, "Toggle inlay hints")
    end
  end,
})

autocmd("FileType", {
  group = augroup("user-quick-close", { clear = true }),
  pattern = { "help", "qf", "man", "lspinfo", "checkhealth" },
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, silent = true })
  end,
})
