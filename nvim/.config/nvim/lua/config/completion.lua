vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-completion", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return vim.fn.complete_info({ "selected" }).selected ~= -1 and "<C-y>" or "<C-e><CR>"
  end
  -- If the cursor sits directly between a matching bracket pair ({|}, [|], (|)),
  -- expand into an indented empty line:
  --   {|}  ->  {
  --              |
  --            }
  local col = vim.fn.col(".")
  local line = vim.api.nvim_get_current_line()
  local before = line:sub(col - 1, col - 1)
  local after = line:sub(col, col)
  local closers = { ["{"] = "}", ["["] = "]", ["("] = ")" }
  if closers[before] == after then
    return "<CR><Esc>O"
  end
  return "<CR>"
end, { expr = true })
