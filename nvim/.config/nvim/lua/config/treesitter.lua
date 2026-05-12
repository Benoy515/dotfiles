local ts = require("nvim-treesitter")

ts.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

local ensure = {
  "lua", "vim", "vimdoc", "query",
  "bash", "json", "yaml", "toml", "markdown", "markdown_inline",
  "python", "javascript", "typescript", "tsx", "html", "css",
  "go", "rust", "regex", "diff", "gitcommit",
}

ts.install(ensure)

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local lang = vim.treesitter.language.get_lang(ft)
    if lang and pcall(vim.treesitter.start, args.buf, lang) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
