-- Harpoon (harpoon2 branch): a tiny, hand-curated list of files you jump
-- between with <leader>N. The list is scoped per project (keyed on cwd) and
-- persisted to disk, so it survives restarts. This replaces "cycle through 40
-- open buffers" with a handful of fixed, muscle-memory slots.
local harpoon = require("harpoon")

harpoon:setup({
  settings = {
    -- Write the list to disk when the quick menu is toggled, and pull edits
    -- made inside that menu back into the list when it closes.
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
})

local M = {}

--- The items array is *sparse* on purpose: removing slot 2 leaves a hole so
--- slots 3+ keep their numbers (that's what makes the keybinds stable muscle
--- memory). So never use `#items` or `ipairs` here — walk 1..length() and skip
--- the nils.
---@return integer, string[] -- list length, and slot index -> item value
local function slots()
  local list = harpoon:list()
  local values = {}
  for i = 1, list:length() do
    local item = list:get(i)
    if item and item.value and item.value ~= "" then
      values[i] = item.value
    end
  end
  return list:length(), values
end

--- Tabline renderer, wired up as an `%!` expression below so it re-runs on
--- every tabline redraw. Returns statusline syntax: `%#Group#` switches
--- highlight, `%<` marks the truncation point.
function M.tabline()
  local length, values = slots()
  if length == 0 then
    return "%#HarpoonHint# harpoon: empty — <leader>ma to pin this file %#TabLineFill#"
  end

  local cur = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
  local parts = {}

  for i = 1, length do
    local value = values[i]
    if value then
      local name = vim.fn.fnamemodify(value, ":t")
      local icon = require("mini.icons").get("file", name)
      -- Items store cwd-relative paths; expand before comparing to the buffer.
      local active = vim.fs.normalize(vim.fn.fnamemodify(value, ":p")) == cur
      local hl = active and "%#HarpoonActive#" or "%#HarpoonInactive#"
      -- A literal % in a filename would be parsed as a statusline item.
      parts[#parts + 1] = string.format("%s %d %s %s ", hl, i, icon, (name:gsub("%%", "%%%%")))
    end
  end

  return table.concat(parts) .. "%<%#TabLineFill#"
end

vim.o.showtabline = 2 -- 2 = always visible, even with a single tab page
vim.o.tabline = "%!v:lua.require'config.harpoon'.tabline()"

-- Colorschemes wipe every highlight when they load, so (re)define ours on the
-- ColorScheme event as well as right now.
local function set_highlights()
  vim.api.nvim_set_hl(0, "HarpoonActive", { link = "TabLineSel" })
  vim.api.nvim_set_hl(0, "HarpoonInactive", { link = "TabLine" })
  vim.api.nvim_set_hl(0, "HarpoonHint", { link = "Comment" })
end
set_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })

-- The tabline only re-evaluates when nvim decides to redraw it, which doesn't
-- necessarily happen the moment the list mutates. harpoon:extend registers
-- callbacks on its own events, so we force a redraw on anything that changes
-- the list or which file is current.
local events = require("harpoon.extensions").event_names
local redraw = {}
for _, e in ipairs({
  events.ADD,
  events.REMOVE,
  events.REPLACE,
  events.REORDER,
  events.LIST_CHANGE,
  events.LIST_READ,
  events.SELECT,
  events.NAVIGATE,
}) do
  redraw[e] = function() vim.cmd.redrawtabline() end
end
harpoon:extend(redraw)

-- Switching buffers by any other means (fzf, :b, <leader><leader>) also moves
-- which slot should be highlighted.
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function() vim.cmd.redrawtabline() end,
})

local map = vim.keymap.set

map("n", "<leader>mm", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Menu (edit/reorder)" })

map("n", "<leader>ma", function()
  harpoon:list():add()
end, { desc = "Add (pin) file" })

map("n", "<leader>md", function()
  harpoon:list():remove()
end, { desc = "Delete (unpin) file" })

for i = 1, 5 do
  map("n", "<leader>" .. i, function()
    harpoon:list():select(i)
  end, { desc = "Harpoon: slot " .. i })
end

-- ui_nav_wrap makes ]h from the last pin land back on the first.
map("n", "]h", function()
  harpoon:list():next({ ui_nav_wrap = true })
end, { desc = "Harpoon: next pin" })

map("n", "[h", function()
  harpoon:list():prev({ ui_nav_wrap = true })
end, { desc = "Harpoon: prev pin" })

-- Inside the quick menu, bare 1-9 jump straight to that slot.
harpoon:extend(require("harpoon.extensions").builtins.navigate_with_number())
harpoon:extend(require("harpoon.extensions").builtins.highlight_current_file())

return M
