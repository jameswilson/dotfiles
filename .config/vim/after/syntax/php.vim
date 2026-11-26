" Vim's PHP syntax leaves user-defined declaration names unclassified.
syntax match phpFunctionName /\%(\<function\s\+&\?\s*\)\@<=\h\w*\ze\s*(/ contained
syntax cluster phpClFunction add=phpFunctionName
highlight default link phpFunctionName Function
syntax match phpClassName /\%(\<\%(class\|interface\|trait\|enum\)\s\+\)\@<=\h\w*/ contained
syntax cluster phpClFunction add=phpClassName
highlight default link phpClassName Type
" PIV enables SQL in every PHP string. Keep SQL only in SQL-named heredocs.
syntax cluster phpAddStrings remove=@sqlTop
" NULL is a value, not a type name, despite the bundled parser's default group.
syntax keyword phpBoolean null contained
