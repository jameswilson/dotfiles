" Vim functions, options, strings, and mappings.
function! SyntaxReview(name) abort
  let greeting = 'Hello ' . a:name
  return greeting
endfunction
set number
nnoremap <leader>sr :echo SyntaxReview('Drupal')<CR>
