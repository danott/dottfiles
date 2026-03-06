local api = vim.api
local grp = api.nvim_create_augroup('DanAutocmds', {})

-- highlight on yank
api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
  group = grp,
})

-- show/hide diagnostics based on active window
api.nvim_create_autocmd({ 'FocusGained', 'WinEnter' }, {
  callback = function()
    if vim.bo.filetype == 'lazy' then
      return
    end
    local bufnr = vim.api.nvim_get_current_buf()
    vim.diagnostic.show(nil, bufnr)
  end,
  group = grp,
})

api.nvim_create_autocmd({ 'FocusLost', 'WinLeave' }, {
  callback = function()
    if vim.bo.filetype == 'lazy' then
      return
    end
    local bufnr = vim.api.nvim_get_current_buf()
    vim.diagnostic.hide(nil, bufnr)
  end,
  group = grp,
})

-- show cursor line only in active window
api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  callback = function()
    vim.wo.cursorline = true
  end,
  group = grp,
})

api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  callback = function()
    vim.wo.cursorline = false
  end,
  group = grp,
})

-- close certain windows with "q"
api.nvim_create_autocmd('FileType', {
  pattern = {
    'git',
    'help',
    'lspinfo',
    'qf',
    'vim',
    'query',
    'startuptime',
  },
  callback = function()
    vim.keymap.set('n', 'q', ':close<cr>', { buffer = true, silent = true })
  end,
  group = grp,
})

api.nvim_create_autocmd('FileType', {
  pattern = 'man',
  callback = function()
    vim.keymap.set('n', 'q', ':quit<cr>', { buffer = true, silent = true })
  end,
  group = grp,
})

-- new lines with 'o' or 'O' from commented lines don't continue commenting
api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.opt_local.formatoptions:remove('o')
  end,
  group = grp,
})

-- markdown and gitcommit: no conceallevel, spell on
api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'gitcommit' },
  callback = function()
    vim.opt_local.conceallevel = 0
    vim.opt_local.spell = true
  end,
  group = grp,
})

-- try linting via nvim-lint on save
api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave', 'TextChanged' }, {
  callback = function()
    local ok, lint = pcall(require, 'lint')
    if ok then
      lint.try_lint()
    end
  end,
  group = grp,
})
