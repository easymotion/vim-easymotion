let s:V = vital#of('easymotion')
let s:HitAHintMotion = s:V.import('HitAHint.Motion')

function! EasyMotion#overwin#move(pattern) abort
  return s:HitAHintMotion.move(a:pattern, {
  \   'keys': g:EasyMotion_keys,
  \   'use_upper': g:EasyMotion_use_upper,
  \   'highlight': {
  \     'shade': g:EasyMotion_hl_group_shade,
  \     'target': g:EasyMotion_hl_group_target,
  \   },
  \ })
endfunction

function! EasyMotion#overwin#line() abort
  return EasyMotion#overwin#move('^')
endfunction

function! EasyMotion#overwin#w() abort
  return EasyMotion#overwin#move('\(\<.\|^$\)')
endfunction
