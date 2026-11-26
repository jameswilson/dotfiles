" Baby Panda palette for the existing vim-airline status bar.
let g:airline#themes#baby_panda#palette = {}
let s:p = g:airline#themes#baby_panda#palette
let s:middle = ['#e6e6e6', '#31353a', 254, 237]
let s:body = ['#e6e6e6', '#222223', 254, 235]
for [s:mode, s:accent] in items({
      \ 'normal': ['#19f9d8', 50], 'insert': ['#6fc1ff', 75],
      \ 'visual': ['#b084eb', 140], 'replace': ['#ff4b82', 204],
      \ 'terminal': ['#19f9d8', 50],
      \ })
  let s:p[s:mode] = airline#themes#generate_color_map(
        \ ['#292a2b', s:accent[0], 235, s:accent[1], 'bold'], s:middle, s:body)
  let s:p[s:mode . '_modified'] = {'airline_c': ['#ffcc95', '#222223', 222, 235]}
  let s:p[s:mode].airline_error = ['#292a2b', '#ff4b82', 235, 204]
  let s:p[s:mode].airline_warning = ['#292a2b', '#ffcc95', 235, 222]
endfor
let s:p.inactive = airline#themes#generate_color_map(
      \ ['#bbbbbb', '#242526', 250, 235], ['#bbbbbb', '#242526', 250, 235], ['#bbbbbb', '#242526', 250, 235])
let s:p.accents = {'red': ['#ff4b82', '', 204, ''], 'green': ['#19f9d8', '', 50, ''],
      \ 'blue': ['#6fc1ff', '', 75, ''], 'yellow': ['#ffcc95', '', 222, ''],
      \ 'orange': ['#ffb86c', '', 215, ''], 'purple': ['#b084eb', '', 140, '']}
unlet s:p s:middle s:body s:mode s:accent
