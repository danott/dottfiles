return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    lazygit = {},
    input = {},
    bigfile = {},
    quickfile = {},
    explorer = {},
    picker = {
      enabled = true,
      ui_select = true,
      sources = {
        explorer = {
          follow_file = true,
          focus = 'list',
          auto_close = false,
          jump = { close = false },
        },
        files = { hidden = true },
      },
    },
  },
  keys = {
    { '<leader>e', function() Snacks.explorer() end, desc = 'toggle explorer' },
    { '<leader>f', function() Snacks.picker.smart() end, mode = { 'n', 'x' }, desc = 'find files' },
    { '<leader>b', function() Snacks.picker.buffers() end, mode = { 'n', 'x' }, desc = 'find buffers' },
    { '<leader>s', function() Snacks.picker.grep() end, mode = { 'n', 'x' }, desc = 'live grep' },
    { '<leader>w', function() Snacks.picker.grep_word() end, mode = { 'n', 'x' }, desc = 'grep word' },
    { '<leader>g', function() Snacks.lazygit() end, mode = { 'n', 'x' }, desc = 'lazygit' },
    { 'z=', function() Snacks.picker.spelling() end, mode = 'n', desc = 'spell suggest' },
  },
}
