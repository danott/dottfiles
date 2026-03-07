-- search (center only when jumping outside viewport)
local function search_center(cmd)
  local top = vim.fn.line('w0')
  local bot = vim.fn.line('w$')
  vim.cmd('normal! ' .. cmd)
  if vim.fn.line('.') < top or vim.fn.line('.') > bot then
    vim.cmd('normal! zz')
  end
end
vim.keymap.set('n', 'n', function() search_center('n') end, { desc = 'next match' })
vim.keymap.set('n', 'N', function() search_center('N') end, { desc = 'previous match' })
vim.keymap.set('n', '<leader>n', '<cmd>nohlsearch<CR>', { desc = 'clear search highlight' })

-- splits (vim directions)
vim.keymap.set('n', '<leader>h', '<cmd>vsplit<CR><C-w>h', { desc = 'split left' })
vim.keymap.set('n', '<leader>j', '<cmd>split<CR><C-w>j', { desc = 'split down' })
vim.keymap.set('n', '<leader>k', '<cmd>split<CR><C-w>k', { desc = 'split up' })
vim.keymap.set('n', '<leader>l', '<cmd>vsplit<CR><C-w>l', { desc = 'split right' })

