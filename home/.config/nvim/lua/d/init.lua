require('d.globals')
require('d.defaults')
require('d.keymaps')
require('d.treesitter')
require('d.autocmds')
require('d.usercmds')

require('d.lsp').setup()
require('d.diagnostic').setup()
