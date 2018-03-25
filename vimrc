" directory /home/$USER/.vimrc

" tab=spaces; tab=2spaces; indentation(e.g.>>)=2spaces
set expandtab tabstop=2 shiftwidth=2

" plugins
call plug#begin('~/.vim/plugIn')
Plug '$HOME/build/wal.vim'
call plug#end()

colorscheme wal

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

" -----------------------------------------------------------------------------------
