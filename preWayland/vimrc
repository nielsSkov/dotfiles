" directory /home/$USER/.vimrc

" tab=spaces; tab=2spaces; indentation(e.g.>>)=2spaces
" set expandtab tabstop=2 shiftwidth=2
set tabstop=2 shiftwidth=2

" plugins
call plug#begin('~/.vim/plugIn')
Plug '$HOME/build/wal.vim'
call plug#end()

" colorscheme wal

hi ColorColumn ctermbg=black guibg=NONE
" execute "set colorcolumn=" . join(range(81,335), ',')
execute "set colorcolumn=" . 81

set number
set relativenumber

" avoid underline on current line-number
hi CursorLineNr cterm=bold ctermfg=012

" --------------- FROM ARCH DEFAULT VIMRC -------------------------------------------

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible                " Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start  " more powerful backspacing

" Now we set some defaults for the editor
set history=50                  " keep 50 lines of command line history
set ruler                       " show the cursor position all the time

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.png,.jpg

if has('gui_running')
  " Make shift-insert work like in Xterm
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>
endif

" ------------------------------------------------------------------------------

" tab settings for python files
autocmd FileType python setlocal tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab
