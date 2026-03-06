vim.cmd("highlight clear")
vim.g.colors_name = "neckbeard"

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Inherit everything from the terminal
hi("Normal", {})

-- Flatten all base syntax groups so everything is plain
local plain = { "Constant", "String", "Character", "Number", "Boolean", "Float",
  "Identifier", "Function", "Statement", "Conditional", "Repeat", "Label",
  "Operator", "Keyword", "Exception", "PreProc", "Include", "Define", "Macro",
  "PreCondit", "Type", "StorageClass", "Structure", "Typedef", "Special",
  "SpecialChar", "Tag", "Delimiter", "Debug", "Underlined", "Todo" }

for _, group in ipairs(plain) do
  hi(group, { link = "Normal" })
end

-- UI elements that need to be visible
hi("CursorLine", { bg = "#2e2e2e" })
hi("Visual", { bg = "#3e3e3e" })
hi("Search", { fg = "#000000", bg = "#97C9F6" })
hi("IncSearch", { fg = "#000000", bg = "#97C9F6", bold = true })
hi("MatchParen", { fg = "#000000", bg = "#97C9F6" })
hi("Pmenu", { bg = "#1e1e1e" })
hi("PmenuSel", { fg = "#ffffff", bg = "#444444" })
hi("PmenuMatch", { fg = "#97C9F6", bold = true })
hi("PmenuMatchSel", { fg = "#97C9F6", bg = "#444444", bold = true })
hi("SnacksPickerListCursorLine", { fg = "#ffffff", bg = "#444444" })
hi("SnacksPickerMatch", { fg = "#97C9F6", bold = true })

-- Comments: the ONE thing that gets color
local comment = "#97C9F6"
hi("Comment", { fg = comment })
hi("SpecialComment", { fg = comment })
hi("@comment", { fg = comment })
hi("@comment.documentation", { fg = comment })
