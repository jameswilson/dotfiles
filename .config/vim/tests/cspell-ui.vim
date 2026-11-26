function! s:Wait(buffer) abort
  for attempt in range(1, 300)
    if getbufvar(a:buffer, 'cspell_completed_run', -1) == getbufvar(a:buffer, 'cspell_run', 0)
      return
    endif
    sleep 20m
  endfor
  call assert_report('CSpell background job timed out')
endfunction

execute 'edit ' . fnameescape($VIM_CSPELL_TEST_ROOT . '/example.txt')
let s:buffer = bufnr('%')
let s:window = win_getid()
call s:Wait(s:buffer)
call assert_true(get(b:cspell_result, 'ok', 0), string(b:cspell_result))
call assert_equal(['wrdzzcheck'], map(copy(b:cspell_result.issues), 'v:val.word'))
call assert_equal(0, &spell)
call assert_true(len(filter(getmatches(), 'v:val.group == "CSpellBad"')) > 0)

CSpellDisable
call assert_equal(0, b:cspell_enabled)
call assert_equal([], filter(getmatches(), 'v:val.group == "CSpellBad"'))
CSpellEnable
call s:Wait(s:buffer)
call assert_equal(1, getbufvar(s:buffer, 'cspell_enabled'))
call assert_equal(1, len(getloclist(win_id2win(s:window))))
lclose
call win_gotoid(s:window)

" A successful write automatically replaces old diagnostics.
call setline(1, 'druplicon projectwordzz')
write
call s:Wait(s:buffer)
call assert_equal([], b:cspell_result.issues)
call assert_equal([], filter(getmatches(), 'v:val.group == "CSpellBad"'))

" Results for an older buffer version must not be painted after an edit.
call cspell#Check(0)
let s:run = b:cspell_run
call setline(1, 'unsaved wrdzzcheck')
for attempt in range(1, 300)
  if job_status(b:cspell_job) != 'run' | break | endif
  sleep 20m
endfor
call assert_notequal(s:run, get(b:, 'cspell_completed_run', -1))
call assert_equal([], filter(getmatches(), 'v:val.group == "CSpellBad"'))

execute 'edit! ' . fnameescape($VIM_CSPELL_TEST_ROOT . '/excluded.txt')
call s:Wait(bufnr('%'))
call assert_equal(v:false, b:cspell_result.checked)
call assert_equal([], filter(getmatches(), 'v:val.group == "CSpellBad"'))
let s:spell = synIDtrans(hlID('CSpellBad'))
call assert_equal('', synIDattr(s:spell, 'fg#', 'gui'))
call assert_equal('', synIDattr(s:spell, 'bg#', 'gui'))
call writefile([json_encode({'errors': v:errors, 'messages': execute('messages')})], $VIM_CSPELL_TEST_REPORT)
qa!
