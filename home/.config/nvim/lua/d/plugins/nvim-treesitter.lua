return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  dependencies = {
    'RRethy/nvim-treesitter-endwise',
    'andymass/vim-matchup',
    'windwp/nvim-ts-autotag',
  },
  config = function()
    require('nvim-treesitter').setup()

    -- auto-install parsers
    local ensure_installed = {
      'bash',
      'c',
      'comment',
      'css',
      'dockerfile',
      'html',
      'javascript',
      'jsdoc',
      'json',
      'lua',
      'markdown',
      'markdown_inline',
      'query',
      'regex',
      'ruby',
      'scss',
      'sql',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'yaml',
    }

    local installed = require('nvim-treesitter').get_installed()
    local to_install = vim.tbl_filter(function(lang)
      return not vim.tbl_contains(installed, lang)
    end, ensure_installed)

    if #to_install > 0 then
      require('nvim-treesitter').install(to_install)
    end

    vim.api.nvim_set_hl(0, 'MatchWord', { italic = true })
  end,
}
