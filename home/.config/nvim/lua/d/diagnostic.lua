local M = {}

function M.setup()
  local signs = {
    [vim.diagnostic.severity.E] = '',
    [vim.diagnostic.severity.W] = '',
    [vim.diagnostic.severity.I] = '',
    [vim.diagnostic.severity.N] = '',
  }

  vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    signs = {
      priority = 10,
      text = signs,
    },
    float = {
      source = 'if_many',
    },
  })

  local function opts(desc)
    return { desc = desc }
  end
  vim.keymap.set('n', 'gdn', function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, opts('jump next'))
  vim.keymap.set('n', 'gdp', function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, opts('jump previous'))
  vim.keymap.set('n', 'gdh', vim.diagnostic.open_float, opts('open float'))
  vim.keymap.set('n', 'gdd', vim.diagnostic.setloclist, opts('current document'))
  vim.keymap.set('n', 'gdw', vim.diagnostic.setqflist, opts('current workspace'))
end

return M
