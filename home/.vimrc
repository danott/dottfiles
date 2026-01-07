set relativenumber
set backspace=indent,eol,start
set autoread
set updatetime=300

" Leader key
let mapleader = ","

" File browser
nnoremap <leader>e :Ex<CR>
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" Splits
nnoremap <leader>h :leftabove vsplit<CR>
nnoremap <leader>j :rightbelow split<CR>
nnoremap <leader>k :leftabove split<CR>
nnoremap <leader>l :rightbelow vsplit<CR>

" Navigation between splits with tmux integration
" This allows seamless navigation from vim back to tmux
function! TmuxOrSplitSwitch(direction)
  let wnr = winnr()
  execute 'wincmd ' . a:direction
  " If the window didn't change, we're at an edge, so send to tmux
  if wnr == winnr()
    let direction_map = {'h': 'L', 'j': 'D', 'k': 'U', 'l': 'R'}
    let tmux_direction = direction_map[a:direction]
    call system('tmux select-pane -' . tmux_direction)
  endif
endfunction

nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h')<CR>
nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j')<CR>
nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k')<CR>
nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l')<CR>

filetype indent plugin on

augroup vimrcEx
  autocmd!
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell
  " Trigger autoread when cursor is idle or window gains focus
  autocmd CursorHold,CursorHoldI,FocusGained * checktime
augroup END

" Disable all syntax highlighting except for comments
syntax on

" Function to link all syntax groups to Normal except Comment
function! DisableAllSyntaxExceptComments()
  " Link all major syntax groups to Normal (effectively disabling them)
  highlight! link Constant Normal
  highlight! link String Normal
  highlight! link Character Normal
  highlight! link Number Normal
  highlight! link Boolean Normal
  highlight! link Float Normal
  highlight! link Identifier Normal
  highlight! link Function Normal
  highlight! link Statement Normal
  highlight! link Conditional Normal
  highlight! link Repeat Normal
  highlight! link Label Normal
  highlight! link Operator Normal
  highlight! link Keyword Normal
  highlight! link Exception Normal
  highlight! link PreProc Normal
  highlight! link Include Normal
  highlight! link Define Normal
  highlight! link Macro Normal
  highlight! link PreCondit Normal
  highlight! link Type Normal
  highlight! link StorageClass Normal
  highlight! link Structure Normal
  highlight! link Typedef Normal
  highlight! link Special Normal
  highlight! link SpecialChar Normal
  highlight! link Tag Normal
  highlight! link Delimiter Normal
  highlight! link Debug Normal
  highlight! link Underlined Normal
  highlight! link Ignore Normal
  highlight! link Error Normal
  highlight! link Todo Normal

  " Keep Comment highlighted, link SpecialComment to it
  highlight! link SpecialComment Comment
  highlight Comment ctermfg=gray guifg=gray
endfunction

" Apply on startup and whenever colorscheme changes
augroup NoSyntaxExceptComments
  autocmd!
  autocmd VimEnter,ColorScheme * call DisableAllSyntaxExceptComments()
augroup END

" Call immediately for current session
call DisableAllSyntaxExceptComments()


