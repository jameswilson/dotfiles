" Vim's javascriptreact.vim is a placeholder with no JSX markup rules.
" The bundled TSX grammar also handles plain JSX; keep the JSX filetype.
if exists('b:current_syntax')
  finish
endif
execute 'source ' . fnameescape($VIMRUNTIME . '/syntax/typescriptreact.vim')
