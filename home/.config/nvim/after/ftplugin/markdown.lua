vim.opt_local.conceallevel = 0
vim.opt_local.spell = true

vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.textwidth = 80
vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = 'list:-1'
vim.opt_local.formatoptions:append('n')
vim.opt_local.formatlistpat = [[^\s*\(\d\+[.\)]\|[-*+]\|>\)\s\+]]

local opts = { buffer = true, silent = true }

vim.keymap.set('n', 'j', 'gj', opts)
vim.keymap.set('n', 'k', 'gk', opts)
vim.keymap.set('n', '0', 'g0', opts)
vim.keymap.set('n', '$', 'g$', opts)

vim.keymap.set('v', 'j', 'gj', opts)
vim.keymap.set('v', 'k', 'gk', opts)
vim.keymap.set('v', '0', 'g0', opts)
vim.keymap.set('v', '$', 'g$', opts)
