" Open the language gallery in one Vim; use :next and :previous to navigate.
let s:root = fnamemodify(expand('<sfile>:p'), ':h')
let s:cases = json_decode(join(readfile(s:root . '/manifest.json'), "\n"))
execute 'args ' . join(map(s:cases, 'fnameescape(s:root . "/fixtures/" . v:val.file)'), ' ')
echom 'Syntax gallery: :next / :previous; :args lists the samples.'
