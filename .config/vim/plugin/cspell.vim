if exists('g:loaded_xdg_cspell')
  finish
endif
let g:loaded_xdg_cspell = 1

highlight default link CSpellBad SpellBad
command! CSpell call cspell#Check(1)
command! CSpellEnable call cspell#Enable()
command! CSpellDisable call cspell#Disable()

augroup XdgCSpell
  autocmd!
  autocmd BufWinEnter,BufWritePost * if get(g:, 'cspell_auto_enabled', 1) | call cspell#Check(0) | endif
  autocmd BufWinLeave * call cspell#Leave()
  autocmd TextChanged,TextChangedI * call cspell#Clear()
  autocmd ColorScheme * highlight default link CSpellBad SpellBad
augroup END
