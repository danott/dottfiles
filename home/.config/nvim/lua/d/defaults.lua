vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'nosplit'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.shortmess = vim.opt.shortmess + 'a'
vim.opt.signcolumn = 'yes'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.winwidth = 100
vim.opt.winborder = 'rounded'

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

if vim.fn.executable('rg') == 1 then
  vim.opt.grepprg = 'rg -H --no-heading --vimgrep'
  vim.opt.grepformat = '%f:%l:%c:%m,%f'
end

vim.cmd.colorscheme('neckbeard')

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
