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

-- Comments: the ONE thing that gets color
local comment = "#97C9F6"
hi("Comment", { fg = comment })
hi("SpecialComment", { fg = comment })
hi("@comment", { fg = comment })
hi("@comment.documentation", { fg = comment })
