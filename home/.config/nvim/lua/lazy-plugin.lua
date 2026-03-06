local M = {}

function M.setup()
  vim.api.nvim_set_keymap('', '<Space>', '<Nop>', {})
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)

  require('lazy').setup('d.plugins', {
    checker = {
      enabled = false,
      notify = false,
    },
    change_detection = {
      notify = false,
    },
    rocks = {
      hererocks = false,
      enabled = false,
    },
    performance = {
      rtp = {
        disabled_plugins = {
          'gzip',
          'matchit',
          'matchparen',
          'netrw',
          'netrwPlugin',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
        },
      },
    },
  })
end

return M
