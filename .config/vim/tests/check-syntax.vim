let s:root = fnamemodify(expand('<sfile>:p'), ':h')
let s:cases = json_decode(join(readfile(s:root . '/manifest.json'), "\n"))
for s:extra in json_decode($VIM_SYNTAX_EXTRA)
  call add(s:cases, {'file': s:extra, 'filetypes': ['json'], 'plain': 0})
endfor
let s:report = {'theme': get(g:, 'colors_name', ''), 'truecolor': &termguicolors, 'files': [], 'spell_groups': {}}
for s:case in s:cases
  let s:file = s:case.file =~ '^/' ? s:case.file : s:root . '/fixtures/' . s:case.file
  try
    execute 'edit ' . fnameescape(s:file)
    syntax sync fromstart
    let s:groups = {}
    for s:lnum in range(1, line('$'))
      for s:col in range(1, strlen(getline(s:lnum)))
        let s:id = synIDtrans(synID(s:lnum, s:col, 1))
        let s:name = synIDattr(s:id, 'name')
        if !empty(s:name) && !has_key(s:groups, s:name)
          let s:groups[s:name] = {'fg': synIDattr(s:id, 'fg#'), 'bg': synIDattr(s:id, 'bg#')}
        endif
      endfor
    endfor
    call add(s:report.files, {'file': s:case.file, 'expected': s:case.filetypes,
          \ 'plain': s:case.plain, 'filetype': &filetype, 'syntax': &syntax,
          \ 'loaded': get(b:, 'current_syntax', ''), 'spell': &spell, 'groups': s:groups})
  catch
    call add(s:report.files, {'file': s:case.file, 'error': v:exception})
  endtry
endfor
" Reloading the theme must not reintroduce spelling backgrounds.
colorscheme one-monokai
for s:group in ['SpellBad', 'SpellCap', 'SpellRare', 'SpellLocal']
  let s:id = hlID(s:group)
  let s:report.spell_groups[s:group] = {'gui_fg': synIDattr(s:id, 'fg#', 'gui'),
        \ 'gui_bg': synIDattr(s:id, 'bg#', 'gui'), 'cterm_fg': synIDattr(s:id, 'fg', 'cterm'),
        \ 'cterm_bg': synIDattr(s:id, 'bg', 'cterm'), 'undercurl': synIDattr(s:id, 'undercurl', 'gui')}
endfor
let s:report.messages = execute('messages')
call writefile([json_encode(s:report)], $VIM_SYNTAX_REPORT)
qa!
