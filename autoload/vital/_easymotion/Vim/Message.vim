let s:save_cpo = &cpo
set cpo&vim



function! s:echomsg(hl, msg) abort
  execute 'echohl' a:hl
  try
    for m in split(a:msg, "\n")
      echomsg m
    endfor
  finally
    echohl None
  endtry
endfunction

function! s:error(msg) abort
  call s:echomsg('ErrorMsg', a:msg)
endfunction

function! s:warn(msg) abort
  call s:echomsg('WarningMsg', a:msg)
endfunction

function! s:capture(command) abort
  try
    redir => out
    silent execute a:command
  finally
    redir END
  endtry
  return out
endfunction

" * Get max length of |hit-enter|.
"   If a string length of a message is greater than the max length,
"   Vim waits for user input according to |hit-enter|.
" XXX: Those fixed values may be different between different OSes?
"      Currently tested on only Windows.
function! s:get_hit_enter_max_length() abort
  let maxlen = &columns * &cmdheight - 1
  if &ruler
    " TODO
  endif
  if &showcmd
    let maxlen -= 11
  endif
  return maxlen
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0:
