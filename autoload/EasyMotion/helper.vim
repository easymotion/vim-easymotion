" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}
function! s:has_vimproc()
    if !exists('s:exists_vimproc')
        try
            silent call vimproc#version()
            let s:exists_vimproc = 1
        catch
            let s:exists_vimproc = 0
        endtry
    endif
    return s:exists_vimproc
endfunction

function! EasyMotion#helper#system(...)
    return call(s:has_vimproc() ? 'vimproc#system' : 'system', a:000)
endfunction

if exists('*strchars')
    function! EasyMotion#helper#strchars(str)
        return strchars(a:str)
    endfunction
else
    function! EasyMotion#helper#strchars(str)
        return strlen(substitute(str, ".", "x", "g"))
    endfunction
endif

function! EasyMotion#helper#include_multibyte_char(str)
    return strlen(a:str) != EasyMotion#helper#strchars(a:str)
endfunction
" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
