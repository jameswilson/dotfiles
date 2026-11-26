" Asynchronous project-aware CSpell; native Vim spelling stays optional.
function! cspell#Clear() abort
  for id in get(w:, 'cspell_matches', [])
    silent! call matchdelete(id)
  endfor
  let w:cspell_matches = []
endfunction

function! cspell#Render(manual) abort
  call cspell#Clear()
  let result = get(b:, 'cspell_result', {})
  if empty(result) || !get(b:, 'cspell_enabled', 1)
    return
  endif
  if !result.ok
    if a:manual || get(b:, 'cspell_last_error', '') != result.error
      echohl WarningMsg | echom 'CSpell: ' . result.error | echohl None
      let b:cspell_last_error = result.error
    endif
    return
  endif
  let positions = map(copy(result.issues), '[v:val.lnum, v:val.col, v:val.length]')
  if !empty(positions)
    for start in range(0, len(positions) - 1, 8)
      call add(w:cspell_matches, matchaddpos('CSpellBad', positions[start : start + 7], 5))
    endfor
  endif
  if a:manual
    let items = map(copy(result.issues), '{"bufnr": bufnr("%"), "lnum": v:val.lnum, "col": v:val.col, "text": "Unknown word: " . v:val.word, "type": "W"}')
    call setloclist(0, [], ' ', {'title': 'CSpell: ' . expand('%:t'), 'items': items})
    if !empty(items)
      lopen
    else
      echom result.checked ? 'CSpell: no spelling issues.' : 'CSpell: file excluded by configuration.'
    endif
  endif
endfunction

function! s:Output(state, channel, message) abort
  call add(a:state.output, a:message)
endfunction

function! s:Error(state, channel, message) abort
  call add(a:state.errors, a:message)
endfunction

function! s:Done(state, channel) abort
  let state = a:state
  if !bufexists(state.buf) || getbufvar(state.buf, 'changedtick') != state.tick
        \ || getbufvar(state.buf, 'cspell_run', -1) != state.run
    return
  endif
  try
    let result = json_decode(join(state.output, "\n"))
  catch
    let result = {'ok': 0, 'error': 'Checker failed: ' . join(state.errors, ' ')}
  endtry
  call setbufvar(state.buf, 'cspell_result', result)
  call setbufvar(state.buf, 'cspell_completed_run', state.run)
  for window in win_findbuf(state.buf)
    call win_execute(window, 'call cspell#Render(' . (state.manual && window == state.window) . ')')
  endfor
endfunction

function! cspell#Check(manual) abort
  if &buftype != '' || !filereadable(expand('%:p')) || !get(b:, 'cspell_enabled', 1)
    return
  endif
  call cspell#Clear()
  if &modified
    if a:manual | echom 'CSpell: save this buffer before checking it.' | endif
    return
  endif
  if !executable('node')
    let b:cspell_result = {'ok': 0, 'error': 'Node.js is required for CSpell.'}
    call cspell#Render(a:manual)
    return
  endif
  let b:cspell_run = get(b:, 'cspell_run', 0) + 1
  if exists('b:cspell_job') && job_status(b:cspell_job) == 'run'
    call job_stop(b:cspell_job)
  endif
  let state = {'buf': bufnr('%'), 'tick': b:changedtick, 'run': b:cspell_run,
        \ 'window': win_getid(), 'manual': a:manual, 'output': [], 'errors': []}
  let b:cspell_job = job_start([exepath('node'), $VIM_XDG_CONFIG_HOME . '/cspell/check.mjs', expand('%:p'), &filetype],
        \ {'in_io': 'null', 'out_mode': 'nl', 'err_mode': 'nl',
        \ 'out_cb': function('s:Output', [state]), 'err_cb': function('s:Error', [state]),
        \ 'close_cb': function('s:Done', [state])})
endfunction

function! cspell#Enable() abort
  let b:cspell_enabled = 1
  call cspell#Check(1)
endfunction

function! cspell#Leave() abort
  call cspell#Clear()
  if len(win_findbuf(bufnr('%'))) <= 1 && exists('b:cspell_job') && job_status(b:cspell_job) == 'run'
    let b:cspell_run = get(b:, 'cspell_run', 0) + 1
    call job_stop(b:cspell_job)
  endif
endfunction

function! cspell#Disable() abort
  let b:cspell_enabled = 0
  let b:cspell_run = get(b:, 'cspell_run', 0) + 1
  if exists('b:cspell_job') && job_status(b:cspell_job) == 'run'
    call job_stop(b:cspell_job)
  endif
  for window in win_findbuf(bufnr('%'))
    call win_execute(window, 'call cspell#Clear()')
  endfor
  echom 'CSpell: disabled for this buffer.'
endfunction
