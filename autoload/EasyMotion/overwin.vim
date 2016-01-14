let s:V = vital#of('easymotion')
let s:HitAHintMotion = s:V.import('HitAHint.Motion')

function! EasyMotion#overwin#move(pattern) abort
  return s:HitAHintMotion.move(a:pattern)
endfunction
