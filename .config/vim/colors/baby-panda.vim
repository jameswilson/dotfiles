" Baby Panda for classic Vim. Palette: gsgualbano/baby-panda-vscode 0.0.1.
" Fresh implementation; TextMate scopes are mapped to Vim syntax groups.
" Source and mapping notes: ../docs/baby-panda.md
set background=dark
highlight clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'baby-panda'

" 256-color entries use the fixed cube/grayscale, independent of ANSI colors.
let s:p = {
      \ 'bg': ['#292a2b', 235], 'fg': ['#e6e6e6', 254],
      \ 'comment': ['#676b79', 242], 'muted': ['#bbbbbb', 250],
      \ 'line': ['#31353a', 237], 'panel': ['#242526', 235],
      \ 'status': ['#222223', 235], 'border': ['#373b41', 237],
      \ 'gutter': ['#858585', 102], 'whitespace': ['#4e5260', 240],
      \ 'mint': ['#19f9d8', 50], 'pink': ['#ff75b5', 211],
      \ 'red': ['#ff4b82', 204], 'tag': ['#ff2c6d', 197],
      \ 'orange': ['#ffb86c', 215], 'peach': ['#ffcc95', 222],
      \ 'purple': ['#b084eb', 140], 'blue': ['#6fc1ff', 75],
      \ 'deepblue': ['#45a9f9', 75], 'lightpink': ['#ff9ac1', 211],
      \ 'selection': ['#5f4e3b', 239], 'search': ['#755d97', 96],
      \ 'diffadd': ['#237d70', 29], 'diffdelete': ['#7f374e', 95],
      \ 'difftext': ['#875b6d', 95],
      \ }

function! s:Hi(group, fg, bg, ...) abort
  let fg = get(s:p, a:fg, ['NONE', 'NONE'])
  let bg = get(s:p, a:bg, ['NONE', 'NONE'])
  let style = get(a:, 1, 'NONE')
  let special = get(s:p, get(a:, 2, ''), ['NONE'])[0]
  execute 'highlight' a:group 'guifg=' . fg[0] 'guibg=' . bg[0]
        \ 'ctermfg=' . fg[1] 'ctermbg=' . bg[1] 'gui=' . style
        \ 'cterm=' . style 'term=' . style 'guisp=' . special
endfunction

" Editor surfaces. Alpha colors from VS Code are blended over #292a2b.
call s:Hi('Normal', 'fg', 'bg')
call s:Hi('NormalNC', 'fg', 'bg')
call s:Hi('Cursor', 'bg', 'red')
call s:Hi('CursorLine', '', 'line')
call s:Hi('CursorColumn', '', 'line')
call s:Hi('ColorColumn', '', 'line')
call s:Hi('LineNr', 'gutter', 'bg')
call s:Hi('CursorLineNr', 'fg', 'bg')
call s:Hi('SignColumn', 'fg', 'bg')
call s:Hi('FoldColumn', 'gutter', 'bg')
call s:Hi('Folded', 'muted', 'panel')
call s:Hi('NonText', 'whitespace', '')
call s:Hi('EndOfBuffer', 'whitespace', '')
call s:Hi('SpecialKey', 'whitespace', '')
call s:Hi('Whitespace', 'whitespace', '')
call s:Hi('VertSplit', 'border', 'bg')
call s:Hi('WinSeparator', 'border', 'bg')
call s:Hi('Visual', '', 'selection')
call s:Hi('VisualNOS', '', 'selection')
call s:Hi('Search', 'fg', 'search')
call s:Hi('IncSearch', 'bg', 'purple')
call s:Hi('CurSearch', 'bg', 'purple')
call s:Hi('MatchParen', 'mint', '', 'bold,underline')
call s:Hi('StatusLine', 'fg', 'status')
call s:Hi('StatusLineNC', 'muted', 'panel')
call s:Hi('StatusLineTerm', 'fg', 'status')
call s:Hi('StatusLineTermNC', 'muted', 'panel')
call s:Hi('TabLine', 'fg', 'panel')
call s:Hi('TabLineFill', 'muted', 'panel')
call s:Hi('TabLineSel', 'mint', 'bg', 'bold')
call s:Hi('Pmenu', 'fg', 'line')
call s:Hi('PmenuSel', 'bg', 'mint')
call s:Hi('PmenuSbar', '', 'border')
call s:Hi('PmenuThumb', '', 'gutter')
call s:Hi('PmenuMatch', 'blue', 'line', 'bold')
call s:Hi('PmenuMatchSel', 'bg', 'mint', 'bold')
call s:Hi('WildMenu', 'bg', 'mint')
call s:Hi('Directory', 'blue', '')
call s:Hi('Title', 'mint', '', 'bold')
call s:Hi('Question', 'mint', '')
call s:Hi('MoreMsg', 'mint', '')
call s:Hi('ModeMsg', 'fg', '')
call s:Hi('ErrorMsg', 'red', '')
call s:Hi('WarningMsg', 'peach', '')
call s:Hi('DiffAdd', 'fg', 'diffadd')
call s:Hi('DiffDelete', 'fg', 'diffdelete')
call s:Hi('DiffChange', 'fg', 'selection')
call s:Hi('DiffText', 'fg', 'difftext', 'bold')

" Core token roles, based on Baby Panda's ordered TextMate rules.
for [s:role, s:groups] in items({
      \ 'pink': 'Statement Conditional Repeat Keyword Exception PreProc Define PreCondit',
      \ 'orange': 'Constant Number Boolean Float StorageClass Structure Macro Todo',
      \ 'purple': 'Type Typedef Debug',
      \ 'blue': 'Function', 'deepblue': 'Character SpecialChar',
      \ 'mint': 'String', 'peach': 'Label Delimiter Special',
      \ 'fg': 'Identifier Operator', 'lightpink': 'Include', 'tag': 'Tag',
      \ })
  for s:group in split(s:groups)
    call s:Hi(s:group, s:role, '')
  endfor
endfor
call s:Hi('Comment', 'comment', '', 'italic')
call s:Hi('SpecialComment', 'comment', '')
call s:Hi('Todo', 'orange', '', 'bold')
call s:Hi('Underlined', 'deepblue', '', 'underline')
call s:Hi('Ignore', '', '')
call s:Hi('Error', '', '', 'undercurl', 'red')

" Distinct roles that don't map to a standard Vim group.
call s:Hi('BabyPandaProperty', 'peach', '')
call s:Hi('BabyPandaBuiltinType', 'peach', '')
call s:Hi('BabyPandaMuted', 'muted', '')
call s:Hi('BabyPandaAttribute', 'orange', '')
call s:Hi('BabyPandaObject', 'lightpink', '')
call s:Hi('BabyPandaLogical', 'peach', '')
call s:Hi('BabyPandaExport', 'purple', '')
call s:Hi('BabyPandaRegexp', 'blue', '')
call s:Hi('BabyPandaSuper', 'tag', '')
call s:Hi('BabyPandaBold', 'orange', '', 'bold')
call s:Hi('BabyPandaItalic', 'lightpink', '', 'italic')
call s:Hi('BabyPandaHeading', 'muted', '', 'bold')
call s:Hi('BabyPandaCode', 'mint', '', 'italic')
call s:Hi('BabyPandaAdded', 'mint', '')
call s:Hi('BabyPandaRemoved', 'tag', '')
call s:Hi('BabyPandaChanged', 'pink', '')

" Installed syntaxes use different names than Vim's stock definitions.
let s:links = {
      \ 'Normal': 'Noise jsonNoise jsonBraces jsNoise jsBraces jsParens jsBrackets jsFuncArgs jsFuncBlock jsFuncArgExpression jsBlock jsDestructuringBlock jsObjectBraces typescriptBraces typescriptParens typescriptEndColons typescriptDotNotation typescriptTypeBrackets typescriptTypeAnnotation typescriptObjectType typescriptBlock typescriptCall cssBraces cssProp cssAttrRegion sassCssAttribute htmlTitle lessProperty lessCssAttribute typescriptFuncCallArg typescriptTemplateSubstitution',
      \ 'Operator': 'OperatorChars jsOperator jsAssignmentOperator typescriptOperator typescriptAssign tsxEqual',
      \ 'Identifier': 'jsVariableDef jsDestructuringValue jsObjectProp typescriptIdentifier typescriptDefaultImportName phpVarSelector phpIdentifier twigVariable twigVar typescriptMember typescriptBOMWindowProp typescriptPaymentShippingOptionProp shDerefSimple shDerefVar shDeref zshDeref zshSubstQuoted',
      \ 'String': 'jsonString jsonQuote jsString jsTemplateString typescriptString typescriptTemplate phpStringSingle phpStringDouble phpStringBacktick htmlString htmlValue twigString cssStringQ cssStringQQ cssURL yamlPlainScalar yamlFlowString rubyStringDelimiter shQuote markdownH1Delimiter markdownH2Delimiter markdownH3Delimiter markdownH4Delimiter markdownH5Delimiter markdownH6Delimiter',
      \ 'Number': 'jsonNumber jsNumber typescriptNumber phpNumber phpFloat cssValueLength cssUnitDecorators yamlInteger yamlFloat',
      \ 'Boolean': 'jsonBoolean jsonNull jsBoolean jsNull typescriptBoolean typescriptNull phpBoolean yamlBool sqlSpecial pythonBuiltinConstant',
      \ 'SpecialChar': 'jsonEscape jsSpecial jsSpecialChar typescriptSpecial phpSpecialChar htmlSpecialChar xmlEntity xmlEntityPunct goSpecialString',
      \ 'Function': 'jsFuncName jsFuncCall jsFunctionKey typescriptFuncName phpFunctions phpFunctionName twigFilter twigFunction cssFunctionName rubyFunction sassMixinName lessFunction vimFunctionName goFunction goFunctionCall goBuiltins',
      \ 'BabyPandaRegexp': 'jsRegexpString jsRegexpCharClass typescriptRegexpString',
      \ 'StorageClass': 'jsStorageClass jsFunction typescriptFuncKeyword typescriptVariable typescriptVariableDeclaration typescriptInterfaceKeyword typescriptClassKeyword typescriptEnumKeyword typescriptAliasKeyword typescriptAccessibilityModifier phpStorageClass rubyClass pythonClassKeyword pythonDefine goDeclaration goTypeDecl goDeclType rustStructure',
      \ 'SpecialComment': 'doxygenBrief doxygenBody doxygenComment phpDocComment pythonDocstring',
      \ 'Keyword': 'jsStatement jsConditional jsRepeat jsReturn jsAsyncKeyword typescriptStatement typescriptConditional typescriptRepeat typescriptReserved typescriptTry typescriptExceptions phpStatement phpConditional phpRepeat phpKeyword twigStatement twigConditional twigRepeat twigBlock sqlKeyword markdownListMarker',
      \ 'Type': 'jsClassDefinition typescriptTypeReference typescriptTypeParameter typescriptTypeAlias typescriptClassName typescriptInterfaceName typescriptEnumName typescriptAliasDeclaration typescriptGeneric phpClasses phpClass phpClassName rubyClassName rubyConstant pythonClass goTypeName rustTrait',
      \ 'Include': 'jsImport jsFrom jsModuleKeyword typescriptImport typescriptExport',
      \ 'Tag': 'htmlTagName htmlSpecialTagName xmlTagName jsxTagName tsxTagName vueTagName cssTagName',
      \ 'Delimiter': 'htmlTag htmlEndTag xmlTag xmlEndTag jsxTag jsxCloseTag tsxTag tsxCloseTag twigDelimiter twigOperator',
      \ 'BabyPandaProperty': 'jsonKeyword jsonKeywordMatch yamlBlockMappingKey yamlFlowMappingKey yamlKey tomlKey tomlKeyDq tomlKeySq dosiniLabel doxygenSpecial',
      \ 'BabyPandaBuiltinType': 'typescriptPredefinedType phpType pythonBuiltinType cType cppType javaType goType goSignedInts goUnsignedInts goFloats goComplexes rustType',
      \ 'BabyPandaMuted': 'markdownUrl',
      \ 'BabyPandaAttribute': 'htmlArg xmlAttrib jsxAttrib tsxAttrib cssClassName cssClassNameDot cssIdentifier cssPseudoClassId sassClass sassClassChar sassId sassIdChar lessClass lessClassChar lessId lessIdChar lessClassCall lessClassIdCall',
      \ 'BabyPandaObject': 'jsThis jsSuper typescriptThis phpThis yamlAnchor yamlAlias sassVariable lessVariable doxygenParam',
      \ 'BabyPandaLogical': 'jsOperatorKeyword jsOperatorWords typescriptBinaryOp typescriptTernary typescriptUnaryOp sqlOperator',
      \ 'BabyPandaExport': 'jsExport cssAtRule', 'BabyPandaSuper': 'typescriptSuper',
      \ 'BabyPandaBold': 'htmlBold markdownBold',
      \ 'BabyPandaItalic': 'htmlItalic markdownItalic',
      \ 'BabyPandaHeading': 'markdownH1 markdownH2 markdownH3 markdownH4 markdownH5 markdownH6 markdownHeadingRule',
      \ 'BabyPandaCode': 'markdownCode markdownCodeBlock',
      \ 'BabyPandaAdded': 'diffAdded diffNewFile',
      \ 'BabyPandaRemoved': 'diffRemoved diffOldFile',
      \ 'BabyPandaChanged': 'diffChanged',
      \ }
for [s:target, s:groups] in items(s:links)
  for s:group in split(s:groups)
    execute 'highlight! link' s:group s:target
  endfor
endfor

" Diagnostics are overlays, never opaque blocks on top of syntax colors.
call s:Hi('SpellBad', '', '', 'undercurl', 'red')
call s:Hi('SpellCap', '', '', 'undercurl', 'orange')
call s:Hi('SpellRare', '', '', 'undercurl', 'purple')
call s:Hi('SpellLocal', '', '', 'undercurl', 'blue')
for [s:group, s:role] in items({'DiagnosticUnderlineError': 'red', 'DiagnosticUnderlineWarn': 'orange', 'DiagnosticUnderlineInfo': 'blue', 'DiagnosticUnderlineHint': 'mint'})
  call s:Hi(s:group, '', '', 'undercurl', s:role)
endfor
highlight! link CSpellBad SpellBad
highlight! link SyntasticError SpellBad
highlight! link SyntasticWarning SpellCap
call s:Hi('SyntasticErrorSign', 'red', 'bg')
call s:Hi('SyntasticWarningSign', 'orange', 'bg')
call s:Hi('SignifySignAdd', 'mint', 'bg')
call s:Hi('SignifySignDelete', 'tag', 'bg')
call s:Hi('SignifySignChange', 'peach', 'bg')
highlight! link NERDTreeDir Directory
highlight! link NERDTreeCWD Directory
highlight! link NERDTreeOpenable Delimiter
highlight! link NERDTreeClosable Delimiter
highlight! link NERDTreeHelp Comment

unlet s:role s:group s:groups s:target s:links
delfunction s:Hi
