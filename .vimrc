scriptencoding utf-8
set nocompatible
set relativenumber

" https://vim.fandom.com/wiki/Backspace_and_delete_problems
set backspace=indent,eol,start

" https://wincent.com/blog/automatic-wrapping-of-git-commit-messages-using-vim
filetype indent plugin on

augroup vimrcEx
  autocmd!

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell
augroup END

