vim.api.nvim_create_user_command('Lg', function()
  require('snacks').lazygit.open()
end, { desc = 'lazygit' })

vim.api.nvim_create_user_command('LspFormat', function()
  require('conform').format({ lsp_format = 'fallback', timeout_ms = 10000 })
end, { desc = 'format with conform, lsp fallback' })
