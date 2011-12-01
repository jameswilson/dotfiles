" File:   ~/.vimrc
" Info:   My configurations and Settings for VIM, a command line editor.
" Author: James Wilson <james@elementalidad.com>

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Note when ~/.vimrc present the following is done automatically
set nocompatible

" Use utf-8 file encodings by default.
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
  set fileencodings=utf-8,latin1
endif

" Configure external bundles via pathogen.
" https://github.com/tpope/vim-pathogen
call pathogen#infect()


""""""""""""""""""""""""""""""""""""""""""""""""
"            Operational settings
""""""""""""""""""""""""""""""""""""""""""""""""

" Automatic file type detection.
filetype on
filetype plugin on

" The 'more' prompt.
set more

" Watch for file changes by other programs.
set autoread

" Don't automatically write on :next, etc.
set noautowrite

" Allow editing multiple unsaved buffers.
set hidden

" Keep at least 5 lines above/below cursor.
set scrolloff=5

" Keep at least 5 columns left/right of cursor.
set sidescrolloff=5

" Reduce visual noise. The t_vb bit removes any delay also.
set visualbell t_vb=


""""""""""""""""""""""""""""""""""""""""""""""""
"             Color scheme
""""""""""""""""""""""""""""""""""""""""""""""""

" All my terminals have dark backgrounds.
set background=dark

" The official list of top 100 colorschemes...
" http://www.vi-improved.org/color_sampler_pack/
" This one is my current favorite.
colorscheme jellybeans

" Make the completion menus readable.
highlight Pmenu ctermfg=0 ctermbg=3
highlight PmenuSel ctermfg=0 ctermbg=7

" The following should be done automatically for
" the default colour scheme at least, but it is
" not in Vim 7.0.17.
if &bg == "dark"
  highlight MatchParen ctermbg=darkblue guibg=blue
endif


""""""""""""""""""""""""""""""""""""""""""""""""
"                   Font
""""""""""""""""""""""""""""""""""""""""""""""""

" My current preferred coding font; with the font
" size optimized for the smaller MacBook Air screen.
set guifont=Inconsolata:h17


""""""""""""""""""""""""""""""""""""""""""""""""
"              General Editing
""""""""""""""""""""""""""""""""""""""""""""""""

" Line numbers on by default.
set number

" Usually annoys me.
set nowrap

" Show matching brackets when typing.
set showmatch

" Jump to the last cursor position, when reopening.
if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal g'\"" |
  \ endif
endif

" Hit <F2> to past from outside vim, which will turn
" off indention and other auto commands. You can tell
" you are in paste mode when the ruler is not visible.
set pastetoggle=<F2>


""""""""""""""""""""""""""""""""""""""""""""""""
"               Code Completion
""""""""""""""""""""""""""""""""""""""""""""""""

" Show menu with possible tab completions.
set wildmenu

" Ignore these files when completing names and in Explorer.
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif


""""""""""""""""""""""""""""""""""""""""""""""""
"             Syntax highlighting
""""""""""""""""""""""""""""""""""""""""""""""""

" Current line and column highlighting is too annoying.
set nocursorline
set nocursorcolumn

" Syntax highlighting if appropriate. The incremental
" search setting highlights the search string as you type.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  set incsearch
endif

" Syntax highlight shell scripts as per POSIX,
" not the original Bourne shell which very few use.
let g:is_posix = 1

" Flag problematic whitespace (trailing and spaces before tabs).
" Note that you get the same by doing let c_space_errors=1 but
" this rule really applies to everything.
highlight RedundantSpaces term=standout ctermbg=red guibg=red

" \ze sets end of match so only spaces highlighted.
match RedundantSpaces /\s\+$\| \+\ze\t/

" Use :set list! to toggle visible whitespace on/off.
set listchars=tab:>-,trail:.,extends:>


""""""""""""""""""""""""""""""""""""""""""""""""
"                Diff options
""""""""""""""""""""""""""""""""""""""""""""""""

" Turn of syntax highlighting in diff mode.
if &diff
  syntax off
endif

" Ignore all whitespace and sync.
set diffopt=filler,iwhite


""""""""""""""""""""""""""""""""""""""""""""""""
"                Key bindings
""""""""""""""""""""""""""""""""""""""""""""""""

" Note <leader> is the user modifier key (like g is the vim modifier key)
" One can change it from the default of \ using: let mapleader = ","

" \n to turn off search highlighting
nmap <silent> <leader>n :silent :nohlsearch<CR>

" \l to toggle visible whitespace
nmap <silent> <leader>l :set list!<CR>

" Shift-tab to insert a hard tab
imap <silent> <S-tab> <C-v><tab>


""""""""""""""""""""""""""""""""""""""""""""""""
"               Mouse integration
""""""""""""""""""""""""""""""""""""""""""""""""

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a

  " Hide the mouse when typing text.
  set mousehide

  " This makes the mouse paste a block of text without formatting it
  " (good for code)
  map <MouseMiddle> <esc>"*p

  " ,p and shift-insert will paste the X buffer, even on the command line
  nmap <LocalLeader>p i<S-MiddleMouse><ESC>
  imap <S-Insert> <S-MiddleMouse>
  cmap <S-Insert> <S-MiddleMouse>
endif


""""""""""""""""""""""""""""""""""""""""""""""""
"             Indentation and Tabs
""""""""""""""""""""""""""""""""""""""""""""""""

" Use smart indentation, backspace, and tabs.
set autoindent smartindent
set smarttab

" Use spaces, not tabs.
set expandtab

" Make tabstops and indents 2 spaces wide.
set tabstop=2
set shiftwidth=2

" Allow backspacing over indent, eol, & start
set backspace=eol,start,indent


""""""""""""""""""""""""""""""""""""""""""""""""
"            History and Backups
""""""""""""""""""""""""""""""""""""""""""""""""

" Vim backup files (*~) if versions don't exist.
if has("vms")
  set nobackup
else
  set backup
  set backupext=~
endif

" Number of forgivable mistakes
set undolevels=1000

" Write swap file to disk every 100 chars.
set updatecount=100

" Remember the last 200 commands.
set history=200

" Do lots of scanning on tab completion.
set complete=.,w,b,u,U,t,i,d

" Save history to ~/.viminfo
set viminfo=%100,'100,/100,h,\"500,:100,n~/.viminfo


""""""""""""""""""""""""""""""""""""""""""""""""
"             Drupal specific
""""""""""""""""""""""""""""""""""""""""""""""""

if has("autocmd")
  " Drupal *.module and *.install files.
  augroup module
    autocmd BufRead,BufNewFile *.inc set filetype=php
    autocmd BufRead,BufNewFile *.module set filetype=php
    autocmd BufRead,BufNewFile *.install set filetype=php
  augroup END
endif
