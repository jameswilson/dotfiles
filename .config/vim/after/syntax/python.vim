" Give standalone triple-quoted documentation its own highlight group.
" Assigned string values retain the parser's normal string highlighting.
syntax region pythonDocstring start=+^\s*[uUrR]\?"""+ skip=+\\.+ end=+"""+ keepend contains=@Spell
syntax region pythonDocstring start=+^\s*[uUrR]\?'''+ skip=+\\.+ end=+'''+ keepend contains=@Spell
highlight default link pythonDocstring Comment

" The bundled parser combines built-in types/functions and all statements.
syntax keyword pythonBuiltinType bool bytearray bytes complex dict float frozenset
syntax keyword pythonBuiltinType int list memoryview object range set slice str tuple
syntax match pythonBuiltinType /\<type\ze\(\s\+\h\w*\)\@!/
syntax keyword pythonBuiltinConstant True False None NotImplemented Ellipsis
syntax keyword pythonClassKeyword class nextgroup=pythonClass skipwhite
syntax keyword pythonDefine def nextgroup=pythonFunction skipwhite
highlight default link pythonBuiltinType Type
highlight default link pythonBuiltinConstant Constant
highlight default link pythonClassKeyword StorageClass
highlight default link pythonDefine StorageClass

" Preserve the bundled parser's exclusion for attributes such as value.type.
silent! syntax clear pythonAttribute
syntax match pythonAttribute /\.\h\w*/hs=s+1 transparent
      \ contains=ALLBUT,pythonBuiltin,pythonBuiltinType,pythonBuiltinConstant,pythonClass,pythonFunction,pythonType,pythonAsync
