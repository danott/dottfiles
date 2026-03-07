return {
  'williamboman/mason.nvim',
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    require('mason').setup()

    require('mason-tool-installer').setup({
      ensure_installed = {
        'bash-language-server',
        'codespell',
        'css-lsp',
        'html-lsp',
        'json-lsp',
        'lua-language-server',
        'prettierd',
        'ruby-lsp',
        'shellcheck',
        'stylua',
        'tailwindcss-language-server',
        'typescript-language-server',
        'vim-language-server',
        'yaml-language-server',
      },
      auto_update = true,
      run_on_start = true,
      start_delay = 10000,
      debounce_hours = 5,
    })
  end,
}
