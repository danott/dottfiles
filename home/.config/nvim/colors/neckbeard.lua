vim.cmd("highlight clear")
vim.g.colors_name = "neckbeard"
vim.o.background = "dark"

local bg = "#2D2D2D"
local fg = "#D6D6CC"
local comment_color = "#97C9F6"
local subtle = "#666666"
local selection = "#444444"
local darker = "#1a1a1a"

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hi("Normal", { fg = fg, bg = bg })
hi("NormalFloat", { fg = fg, bg = bg })
hi("NormalNC", { fg = fg, bg = bg })
hi("Visual", { bg = selection })
hi("CursorLine", { bg = "#363636" })
hi("CursorLineNr", { fg = fg })
hi("LineNr", { fg = subtle })
hi("SignColumn", { bg = bg })
hi("StatusLine", { fg = fg, bg = darker })
hi("StatusLineNC", { fg = subtle, bg = darker })
hi("WinBar", { fg = fg, bg = bg })
hi("WinBarNC", { fg = subtle, bg = bg })
hi("Pmenu", { fg = fg, bg = darker })
hi("PmenuSel", { bg = selection })
hi("PmenuSbar", { bg = darker })
hi("PmenuThumb", { bg = subtle })
hi("Search", { fg = bg, bg = fg })
hi("IncSearch", { fg = bg, bg = fg })
hi("CurSearch", { fg = bg, bg = fg })
hi("MatchParen", { underline = true })
hi("NonText", { fg = subtle })
hi("SpecialKey", { fg = subtle })
hi("Whitespace", { fg = subtle })
hi("EndOfBuffer", { fg = bg })
hi("VertSplit", { fg = subtle })
hi("WinSeparator", { fg = subtle })
hi("Folded", { fg = subtle, bg = bg })
hi("FoldColumn", { fg = subtle, bg = bg })
hi("Directory", { fg = fg })
hi("Title", { fg = fg, bold = true })
hi("ErrorMsg", { fg = "#ff6b6b" })
hi("WarningMsg", { fg = "#f0c674" })
hi("MoreMsg", { fg = fg })
hi("Question", { fg = fg })
hi("WildMenu", { fg = bg, bg = fg })
hi("TabLine", { fg = subtle, bg = darker })
hi("TabLineFill", { bg = darker })
hi("TabLineSel", { fg = fg, bg = bg })
hi("FloatBorder", { fg = subtle })
hi("FloatTitle", { fg = fg })
hi("Cursor", { fg = bg, bg = fg })
hi("lCursor", { fg = bg, bg = fg })
hi("CursorIM", { fg = bg, bg = fg })

-- Diff
hi("DiffAdd", { bg = "#2d4a2d" })
hi("DiffChange", { bg = "#4a4a2d" })
hi("DiffDelete", { bg = "#4a2d2d" })
hi("DiffText", { bg = "#6a6a2d" })

-- Comments: the ONE thing that gets color
hi("Comment", { fg = comment_color })
hi("SpecialComment", { fg = comment_color })

-- All syntax groups: foreground only
local syntax_groups = {
  "Constant", "String", "Character", "Number", "Boolean", "Float",
  "Identifier", "Function",
  "Statement", "Conditional", "Repeat", "Label", "Operator", "Keyword", "Exception",
  "PreProc", "Include", "Define", "Macro", "PreCondit",
  "Type", "StorageClass", "Structure", "Typedef",
  "Special", "SpecialChar", "Tag", "Delimiter", "Debug",
  "Underlined", "Todo",
}

for _, group in ipairs(syntax_groups) do
  hi(group, { fg = fg })
end

-- Treesitter: comments
local ts_comment_groups = {
  "@comment", "@comment.documentation",
}

for _, group in ipairs(ts_comment_groups) do
  hi(group, { fg = comment_color })
end

-- Treesitter: everything else
local ts_fg_groups = {
  "@variable", "@variable.builtin", "@variable.parameter", "@variable.member",
  "@constant", "@constant.builtin", "@constant.macro",
  "@module", "@module.builtin", "@label",
  "@string", "@string.documentation", "@string.escape", "@string.regexp", "@string.special",
  "@character", "@character.special",
  "@boolean", "@number", "@number.float",
  "@type", "@type.builtin", "@type.definition", "@type.qualifier",
  "@attribute", "@attribute.builtin", "@property",
  "@function", "@function.builtin", "@function.call", "@function.macro",
  "@function.method", "@function.method.call",
  "@constructor",
  "@operator",
  "@keyword", "@keyword.coroutine", "@keyword.function", "@keyword.operator",
  "@keyword.import", "@keyword.type", "@keyword.modifier", "@keyword.repeat",
  "@keyword.return", "@keyword.debug", "@keyword.exception",
  "@keyword.conditional", "@keyword.conditional.ternary",
  "@keyword.directive", "@keyword.directive.define",
  "@punctuation.delimiter", "@punctuation.bracket", "@punctuation.special",
  "@tag", "@tag.attribute", "@tag.delimiter", "@tag.builtin",
  "@markup.strong", "@markup.italic", "@markup.strikethrough", "@markup.underline",
  "@markup.heading", "@markup.quote", "@markup.math", "@markup.environment",
  "@markup.link", "@markup.link.label", "@markup.link.url",
  "@markup.raw", "@markup.raw.block", "@markup.list",
}

for _, group in ipairs(ts_fg_groups) do
  hi(group, { fg = fg })
end

-- Diagnostics (keep these functional)
hi("DiagnosticError", { fg = "#ff6b6b" })
hi("DiagnosticWarn", { fg = "#f0c674" })
hi("DiagnosticInfo", { fg = comment_color })
hi("DiagnosticHint", { fg = subtle })
hi("DiagnosticUnderlineError", { undercurl = true, sp = "#ff6b6b" })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = "#f0c674" })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = comment_color })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = subtle })

-- Git signs
hi("GitSignsAdd", { fg = "#6a9955" })
hi("GitSignsChange", { fg = "#d7ba7d" })
hi("GitSignsDelete", { fg = "#ff6b6b" })

-- Telescope
hi("TelescopeNormal", { fg = fg, bg = bg })
hi("TelescopeBorder", { fg = subtle })
hi("TelescopePromptNormal", { fg = fg, bg = bg })
hi("TelescopePromptBorder", { fg = subtle })
hi("TelescopeResultsNormal", { fg = fg, bg = bg })
hi("TelescopeResultsBorder", { fg = subtle })
hi("TelescopePreviewNormal", { fg = fg, bg = bg })
hi("TelescopePreviewBorder", { fg = subtle })
hi("TelescopeSelection", { bg = selection })
hi("TelescopeMatching", { fg = comment_color })

-- Neo-tree
hi("NeoTreeNormal", { fg = fg, bg = bg })
hi("NeoTreeNormalNC", { fg = fg, bg = bg })
hi("NeoTreeDirectoryIcon", { fg = fg })
hi("NeoTreeDirectoryName", { fg = fg })
hi("NeoTreeFileName", { fg = fg })
hi("NeoTreeGitModified", { fg = "#d7ba7d" })
hi("NeoTreeGitAdded", { fg = "#6a9955" })
hi("NeoTreeGitDeleted", { fg = "#ff6b6b" })
hi("NeoTreeGitUntracked", { fg = subtle })
hi("NeoTreeIndentMarker", { fg = subtle })
hi("NeoTreeRootName", { fg = fg, bold = true })

-- Which-key
hi("WhichKey", { fg = fg })
hi("WhichKeyGroup", { fg = fg })
hi("WhichKeyDesc", { fg = fg })
hi("WhichKeySeparator", { fg = subtle })
hi("WhichKeyFloat", { bg = bg })

-- Indent guides
hi("IndentBlanklineChar", { fg = "#3a3a3a" })
hi("IblIndent", { fg = "#3a3a3a" })
hi("IblScope", { fg = subtle })

-- Notify
hi("NotifyERRORBorder", { fg = "#ff6b6b" })
hi("NotifyWARNBorder", { fg = "#f0c674" })
hi("NotifyINFOBorder", { fg = comment_color })
hi("NotifyDEBUGBorder", { fg = subtle })
hi("NotifyTRACEBorder", { fg = subtle })
hi("NotifyERRORTitle", { fg = "#ff6b6b" })
hi("NotifyWARNTitle", { fg = "#f0c674" })
hi("NotifyINFOTitle", { fg = comment_color })
hi("NotifyDEBUGTitle", { fg = subtle })
hi("NotifyTRACETitle", { fg = subtle })

-- Mini (LazyVim uses mini.indentscope, mini.bufremove, etc.)
hi("MiniIndentscopeSymbol", { fg = subtle })

-- Lazy.nvim UI
hi("LazyNormal", { fg = fg, bg = bg })
hi("LazyButton", { fg = fg, bg = darker })
hi("LazyButtonActive", { fg = bg, bg = fg })
