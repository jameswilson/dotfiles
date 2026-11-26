let s:root = fnamemodify(expand('<sfile>:p'), ':h')
colorscheme baby-panda
let s:cases = [
      \ ['composer.json', 'drupal/entity_pager', 0, '#ffcc95'],
      \ ['composer.json', '2.0@alpha', 0, '#19f9d8'],
      \ ['composer.json', 'true', 0, '#ffb86c'],
      \ ['drupal.yml', 'path:', 0, '#ffcc95'],
      \ ['drupal.yml', '/syntax-review', 0, '#19f9d8'],
      \ ['javascript.js', 'const settings', 0, '#ffb86c'],
      \ ['javascript.js', 'greeting', 0, '#6fc1ff'],
      \ ['javascript.js', 'return', 0, '#ff75b5'],
      \ ['javascript.js', "'Drupal'", 1, '#19f9d8'],
      \ ['javascript.js', 'entity_[', 0, '#6fc1ff'],
      \ ['react.jsx', 'Greeting', 0, '#6fc1ff'],
      \ ['react.jsx', '<section', 1, '#ff2c6d'],
      \ ['react.jsx', 'className=', 0, '#ffb86c'],
      \ ['typescript.ts', 'EntityReference', 0, '#b084eb'],
      \ ['typescript.ts', 'interface', 0, '#ffb86c'],
      \ ['typescript.ts', 'type Result', 0, '#ffb86c'],
      \ ['typescript.ts', 'Result<T>', 0, '#b084eb'],
      \ ['typescript.ts', 'label(entity', 0, '#6fc1ff'],
      \ ['typescript.ts', 'number', 0, '#ffcc95'],
      \ ['react.tsx', 'Greeting', 0, '#6fc1ff'],
      \ ['react.tsx', '<div', 1, '#ff2c6d'],
      \ ['html.html', '<html', 1, '#ff2c6d'],
      \ ['html.html', 'class=', 0, '#ffb86c'],
      \ ['html.html', '"hello"', 1, '#19f9d8'],
      \ ['template.twig', 'if entity', 0, '#ff75b5'],
      \ ['template.twig', 'default(', 0, '#6fc1ff'],
      \ ['template.twig', "'Drupal'", 1, '#19f9d8'],
      \ ['php.php', 'render(string', 0, '#6fc1ff'],
      \ ['php.php', 'Render Drupal vocabulary', 0, '#676b79'],
      \ ['php.php', 'final class', 0, '#ffb86c'],
      \ ['php.php', 'Greeting', 0, '#b084eb'],
      \ ['php.php', 'return [', 0, '#ff75b5'],
      \ ['php.php', "'#markup'", 2, '#19f9d8'],
      \ ['styles.css', '.entity-reference', 1, '#ffb86c'],
      \ ['styles.css', 'color:', 0, '#e6e6e6'],
      \ ['python.py', 'Module documentation', 0, '#676b79'],
      \ ['python.py', 'Hash comments', 0, '#676b79'],
      \ ['python.py', 'Python annotations', 0, '#676b79'],
      \ ['python.py', 'Method documentation', 0, '#676b79'],
      \ ['python.py', '"Drupal"', 1, '#19f9d8'],
      \ ['python.py', 'An assigned multiline value', 0, '#19f9d8'],
      \ ['python.py', 'Its continuation', 0, '#19f9d8'],
      \ ['config.toml', 'name =', 0, '#ffcc95'],
      \ ['settings.ini', 'name =', 0, '#ffcc95'],
      \ ['config.toml', 'true', 0, '#ffb86c'],
      \ ['settings.ini', 'true', 0, '#19f9d8'],
      \ ['config.toml', 'Drupal syntax review', 0, '#19f9d8'],
      \ ['settings.ini', 'Drupal', 0, '#19f9d8'],
      \ ['config.toml', 'TOML tables', 0, '#676b79'],
      \ ['settings.ini', 'INI sections', 0, '#676b79'],
      \ ['php.php', '''#cache''', 2, '#19f9d8'],
      \ ['php.php', '''max-age''', 1, '#19f9d8'],
      \ ['php.php', 'string $name', 0, '#ffcc95'],
      \ ['drupal.module', 'and fieldblock', 0, '#19f9d8'],
      \ ['drupal.module', 'NULL', 0, '#ffb86c'],
      \ ['drupal.module', 'syntax_review_help', 0, '#6fc1ff'],
      \ ['drupal.install', 'Add a sample', 0, '#676b79'],
      \ ['drupal.install', 'Updated entity', 0, '#19f9d8'],
      \ ['drupal.theme', 'Implements hook', 0, '#676b79'],
      \ ['drupal.theme', 'syntax_review/global', 0, '#19f9d8'],
      \ ['legacy.inc', 'Legacy Drupal', 0, '#676b79'],
      \ ['legacy.inc', '''Twig''', 1, '#19f9d8'],
      \ ['drupal.yaml', 'Alternate YAML', 0, '#676b79'],
      \ ['drupal.yaml', 'true', 0, '#ffb86c'],
      \ ['drupal.yaml', '&defaults', 0, '#ff9ac1'],
      \ ['javascript.js', 'Comments, strings', 0, '#676b79'],
      \ ['javascript.js', 'settings =', 0, '#e6e6e6'],
      \ ['typescript.ts', 'return {', 0, '#ff75b5'],
      \ ['typescript.ts', 'id: number', 0, '#e6e6e6'],
      \ ['typescript.ts', 'prefix ??', 0, '#e6e6e6'],
      \ ['typescript.ts', 'entity.label', 7, '#e6e6e6'],
      \ ['react.jsx', '{name}', 1, '#e6e6e6'],
      \ ['react.tsx', '{name}', 1, '#e6e6e6'],
      \ ['html.html', 'Drupal syntax review', 0, '#e6e6e6'],
      \ ['html.html', '&amp;', 0, '#45a9f9'],
      \ ['xml.xml', '<project', 1, '#ff2c6d'],
      \ ['xml.xml', 'enabled=', 0, '#ffb86c'],
      \ ['xml.xml', 'https://example.invalid', 0, '#19f9d8'],
      \ ['xml.xml', '&amp;', 0, '#45a9f9'],
      \ ['xml.xml', '&amp;', 1, '#45a9f9'],
      \ ['xml.xml', 'XML elements', 0, '#676b79'],
      \ ['page.html.twig', '<article', 1, '#ff2c6d'],
      \ ['page.html.twig', 'class=', 0, '#ffb86c'],
      \ ['page.html.twig', 'if title', 0, '#ff75b5'],
      \ ['page.html.twig', '''entity-reference''', 1, '#19f9d8'],
      \ ['styles.scss', 'entity-reference', 0, '#ffb86c'],
      \ ['styles.scss', '$accent', 0, '#ff9ac1'],
      \ ['styles.scss', 'space($size)', 0, '#6fc1ff'],
      \ ['styles.scss', 'padding:', 0, '#e6e6e6'],
      \ ['styles.scss', 'color:', 0, '#e6e6e6'],
      \ ['styles.scss', 'SCSS variables', 0, '#676b79'],
      \ ['styles.less', '@accent', 0, '#ff9ac1'],
      \ ['styles.less', 'entity-reference', 0, '#ffb86c'],
      \ ['styles.less', 'color:', 0, '#e6e6e6'],
      \ ['styles.less', 'LESS variables', 0, '#676b79'],
      \ ['styles.css', 'min-width', 0, '#e6e6e6'],
      \ ['styles.css', '1.5rem', 0, '#ffb86c'],
      \ ['styles.css', '@media', 0, '#b084eb'],
      \ ['markdown.md', 'Syntax review', 0, '#bbbbbb'],
      \ ['markdown.md', '# Syntax', 0, '#19f9d8'],
      \ ['markdown.md', 'bold', 0, '#ffb86c'],
      \ ['markdown.md', 'italic', 0, '#ff9ac1'],
      \ ['markdown.md', 'inline_code', 0, '#19f9d8'],
      \ ['markdown.md', 'https://example.invalid', 0, '#bbbbbb'],
      \ ['markdown.md', '- Drupal', 0, '#ff75b5'],
      \ ['notes.txt', 'Plain text', 0, '#e6e6e6'],
      \ ['notes.txt', 'Unicode:', 0, '#e6e6e6'],
      \ ['script.sh', 'POSIX shell', 0, '#676b79'],
      \ ['script.sh', 'if [', 0, '#ff75b5'],
      \ ['script.sh', 'Hello', 0, '#19f9d8'],
      \ ['script.sh', '$name', 0, '#e6e6e6'],
      \ ['script.bash', 'Bash arrays', 0, '#676b79'],
      \ ['script.bash', 'for module', 0, '#ff75b5'],
      \ ['script.bash', 'modules[@]', 0, '#e6e6e6'],
      \ ['script.zsh', 'Zsh arrays', 0, '#676b79'],
      \ ['script.zsh', 'for module', 0, '#ff75b5'],
      \ ['script.zsh', '$modules', 0, '#e6e6e6'],
      \ ['python.py', 'EntityReference', 0, '#b084eb'],
      \ ['python.py', 'class Entity', 0, '#ffb86c'],
      \ ['python.py', 'str =', 0, '#ffcc95'],
      \ ['python.py', 'int =', 0, '#ffcc95'],
      \ ['python.py', 'render(self', 0, '#6fc1ff'],
      \ ['ruby.rb', 'Ruby symbols', 0, '#676b79'],
      \ ['ruby.rb', 'EntityReference', 0, '#b084eb'],
      \ ['ruby.rb', 'render(name', 0, '#6fc1ff'],
      \ ['ruby.rb', '''Drupal''', 1, '#19f9d8'],
      \ ['ruby.rb', 'true', 0, '#ffb86c'],
      \ ['go.go', 'Go structs', 0, '#676b79'],
      \ ['go.go', 'type Entity', 0, '#ffb86c'],
      \ ['go.go', 'EntityReference struct', 0, '#b084eb'],
      \ ['go.go', 'main()', 0, '#6fc1ff'],
      \ ['go.go', 'Printf', 0, '#6fc1ff'],
      \ ['go.go', 'Label string', 6, '#ffcc95'],
      \ ['go.go', 'Drupal', 0, '#19f9d8'],
      \ ['go.go', '\n', 0, '#45a9f9'],
      \ ['rust.rs', 'Rust attributes', 0, '#676b79'],
      \ ['rust.rs', 'struct Entity', 0, '#ffb86c'],
      \ ['rust.rs', 'main()', 0, '#6fc1ff'],
      \ ['rust.rs', 'Drupal', 0, '#19f9d8'],
      \ ['rust.rs', 'String', 0, '#b084eb'],
      \ ['c.c', 'C macros', 0, '#676b79'],
      \ ['c.c', 'int main', 0, '#ffcc95'],
      \ ['c.c', 'Drupal', 0, '#19f9d8'],
      \ ['c.c', 'return', 0, '#ff75b5'],
      \ ['c.c', '42', 0, '#ffb86c'],
      \ ['cpp.cpp', 'C++ templates', 0, '#676b79'],
      \ ['cpp.cpp', 'typename', 0, '#ffb86c'],
      \ ['cpp.cpp', 'int main', 0, '#ffcc95'],
      \ ['cpp.cpp', 'Drupal', 0, '#19f9d8'],
      \ ['Example.java', 'Java generics', 0, '#676b79'],
      \ ['Example.java', 'public final', 0, '#ffb86c'],
      \ ['Example.java', 'void main', 0, '#ffcc95'],
      \ ['Example.java', 'Drupal', 0, '#19f9d8'],
      \ ['Dockerfile', 'FROM', 0, '#ff75b5'],
      \ ['Dockerfile', 'Syntax sample', 0, '#676b79'],
      \ ['Dockerfile', '"sh"', 1, '#19f9d8'],
      \ ['Makefile', 'Make variables', 0, '#676b79'],
      \ ['Makefile', 'review:', 0, '#6fc1ff'],
      \ ['Makefile', 'syntax review', 0, '#19f9d8'],
      \ ['.gitignore', 'Gitignore negation', 0, '#676b79'],
      \ ['.gitignore', 'node_modules', 0, '#e6e6e6'],
      \ ['query.sql', 'SQL identifiers', 0, '#676b79'],
      \ ['query.sql', 'SELECT', 0, '#ff75b5'],
      \ ['query.sql', 'FROM', 0, '#ff75b5'],
      \ ['query.sql', 'WHERE', 0, '#ff75b5'],
      \ ['query.sql', 'NULL', 0, '#ffb86c'],
      \ ['query.sql', 'AND', 0, '#ffcc95'],
      \ ['query.sql', '''Drupal''', 1, '#19f9d8'],
      \ ['query.graphql', 'GraphQL operations', 0, '#676b79'],
      \ ['query.graphql', 'query Entity', 0, '#ffb86c'],
      \ ['query.graphql', 'ID!', 0, '#b084eb'],
      \ ['query.graphql', '$id', 0, '#e6e6e6'],
      \ ['changes.diff', '-old value', 0, '#ff2c6d'],
      \ ['changes.diff', '+new value', 0, '#19f9d8'],
      \ ['Example.vue', '<section', 1, '#ff2c6d'],
      \ ['Example.vue', 'Vue combines', 0, '#676b79'],
      \ ['Example.vue', 'const greeting', 0, '#ffb86c'],
      \ ['Example.vue', 'Hello Drupal', 0, '#19f9d8'],
      \ ['config.vim', 'Vim functions', 0, '#676b79'],
      \ ['config.vim', 'SyntaxReview(name)', 0, '#6fc1ff'],
      \ ['config.vim', 'return', 0, '#ff75b5'],
      \ ['config.vim', '''Hello ''', 1, '#19f9d8'],
      \ ['python.py', 'True', 0, '#ffb86c'],
      \ ['python.py', 'value.type', 6, '#e6e6e6'],
      \ ['python.py', 'len(self', 0, '#6fc1ff'],
      \ ['php.php', 'SELECT id', 0, '#ff75b5'],
      \ ['php.php', 'FROM node', 0, '#ff75b5'],
      \ ['typescript.ts', 'label(entity,', 6, '#e6e6e6'],
      \ ]
let s:results = []
for s:case in s:cases
  execute 'edit ' . fnameescape(s:root . '/fixtures/' . s:case[0])
  syntax sync fromstart
  normal! zR
  redraw!
  let s:found = 0
  for s:line in range(1, line('$'))
    let s:col = match(getline(s:line), '\C\V' . escape(s:case[1], '\')) + 1
    if s:col > 0
      let s:found = 1
      let s:col += s:case[2]
      let s:raw = synID(s:line, s:col, 1)
      let s:id = synIDtrans(s:raw)
      let s:fg = tolower(synIDattr(s:id, 'fg#', 'gui'))
      if empty(s:fg) | let s:fg = tolower(synIDattr(hlID('Normal'), 'fg#', 'gui')) | endif
      call add(s:results, {'file': s:case[0], 'token': s:case[1], 'line': s:line, 'col': s:col,
            \ 'source': getline(s:line), 'group': synIDattr(s:raw, 'name'), 'color': s:fg, 'expected': s:case[3]})
      call assert_equal(s:case[3], s:fg, s:case[0] . ': ' . s:case[1])
      break
    endif
  endfor
  call assert_true(s:found, 'Missing fixture token: ' . string(s:case))
endfor

" Switching from the older theme must not leave its operator-color callback active.
colorscheme one-monokai
colorscheme baby-panda
execute 'edit ' . fnameescape(s:root . '/fixtures/javascript.js')
doautocmd Syntax
call assert_equal('baby-panda', g:colors_name)
call assert_equal('#e6e6e6', tolower(synIDattr(synIDtrans(hlID('OperatorChars')), 'fg#', 'gui')))
colorscheme baby-panda
call assert_equal('#292a2b', tolower(synIDattr(hlID('Normal'), 'bg#', 'gui')))
call assert_equal('#e6e6e6', tolower(synIDattr(hlID('Normal'), 'fg#', 'gui')))
for s:group in ['SpellBad', 'SpellCap', 'SpellRare', 'SpellLocal', 'CSpellBad']
  let s:id = synIDtrans(hlID(s:group))
  call assert_equal('', synIDattr(s:id, 'fg#', 'gui'), s:group)
  call assert_equal('', synIDattr(s:id, 'bg#', 'gui'), s:group)
  call assert_equal('', synIDattr(s:id, 'fg', 'cterm'), s:group)
  call assert_equal('', synIDattr(s:id, 'bg', 'cterm'), s:group)
endfor

set notermguicolors
colorscheme baby-panda
for s:group in ['Normal', 'String', 'Keyword', 'Type', 'Function', 'Comment', 'Visual', 'DiffAdd']
  let s:fg = synIDattr(hlID(s:group), 'fg', 'cterm')
  let s:bg = synIDattr(hlID(s:group), 'bg', 'cterm')
  call assert_true(!empty(s:fg) || !empty(s:bg), s:group . ' has no fallback color')
  for s:color in filter([s:fg, s:bg], '!empty(v:val)')
    call assert_true(str2nr(s:color) >= 16 && str2nr(s:color) <= 255, s:group . ': ' . s:color)
  endfor
endfor
set termguicolors
runtime autoload/airline/themes/baby_panda.vim
call assert_equal('#222223', g:airline#themes#baby_panda#palette.normal.airline_c[1])
call writefile([json_encode({'errors': v:errors, 'tokens': s:results, 'messages': execute('messages')})], $VIM_BABY_PANDA_REPORT)
qa!
