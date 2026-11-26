" Prefer Vim's maintained PHP syntax to PIV's PHP 5.3-era parser.
" Keep PIV's other features; only its obsolete syntax definition is bypassed.
if exists('b:current_syntax')
  finish
endif
execute 'source ' . fnameescape($VIMRUNTIME . '/syntax/php.vim')
