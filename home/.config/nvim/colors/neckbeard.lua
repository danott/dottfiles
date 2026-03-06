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
  "SpecialChar", "Tag", "Delimiter", "Debug", "Underlined", "Todo", "Error" }

for _, group in ipairs(plain) do
  hi(group, { link = "Normal" })
end

-- Flatten ALL treesitter highlights so nothing escapes
-- Setting @... with no language suffix applies to all languages
for _, group in ipairs(vim.fn.getcompletion("@", "highlight")) do
  if not group:match("^@comment") then
    hi(group, { link = "Normal" })
  end
end

-- Comments: the ONE thing that gets color
local comment = "#97C9F6"
hi("Comment", { fg = comment })
hi("SpecialComment", { fg = comment })
hi("@comment", { fg = comment })
hi("@comment.documentation", { fg = comment })

-- UI elements — use reverse/bold to adapt to any terminal background
hi("CursorLine", {})
hi("Visual", { reverse = true })
hi("Search", { fg = comment, reverse = true })
hi("IncSearch", { fg = comment, reverse = true, bold = true })
hi("MatchParen", { fg = comment, bold = true, underline = true })
hi("Pmenu", { link = "Normal" })
hi("PmenuSel", { reverse = true })
hi("PmenuMatch", { fg = comment, bold = true })
hi("PmenuMatchSel", { fg = comment, reverse = true, bold = true })
hi("NormalFloat", { link = "Normal" })
hi("FloatBorder", { link = "Normal" })
hi("FloatTitle", { link = "Normal" })

-- Snacks picker — inherit from Normal/Pmenu so terminal theme is respected
hi("SnacksPickerInput", { link = "Normal" })
hi("SnacksPickerInputBorder", { link = "Normal" })
hi("SnacksPickerList", { link = "Normal" })
hi("SnacksPickerListCursorLine", { link = "PmenuSel" })
hi("SnacksPickerMatch", { fg = comment, bold = true })
hi("SnacksPickerPreview", { link = "Normal" })
hi("SnacksPickerPreviewBorder", { link = "Normal" })
