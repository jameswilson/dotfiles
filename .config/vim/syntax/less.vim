" The recovered LESS plugin mixes property names with value keywords.
" Use Vim's bundled parser, which keeps those contexts separate.
if exists('b:current_syntax')
  finish
endif
execute 'source ' . fnameescape($VIMRUNTIME . '/syntax/less.vim')
