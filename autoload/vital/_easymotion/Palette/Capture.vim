scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:verbosefiles = []

function! s:_verbosefile_push(file)
	call add(s:verbosefiles, &verbosefile)
	let &verbosefile = a:file
	return a:file
endfunction


function! s:_verbosefile_pop()
	let filename = &verbosefile
	let &verbosefile = get(s:verbosefiles, -1)
	call remove(s:verbosefiles, -1)
	return filename
endfunction


function! s:_reset()
	let s:verbosefiles = []
endfunction


function! s:extend(dict, src)
	for [key, value] in items(a:src)
		let a:dict[key] = value
		unlet value
	endfor
endfunction


function! s:command(cmd, ...)
	" Workaround : Vim 7.3.xxx in Travis and Ubuntu
	" https://github.com/osyo-manga/vital-palette/issues/5
" 	call extend(l:, get(a:, 1, {}))
	if a:0 > 0
		call s:extend(l:, a:1)
	endif

	call s:_verbosefile_push(tempname())
	try
		redir =>result
		silent execute a:cmd
	finally
		redir END
	endtry
	call s:_verbosefile_pop()
" 	let result = substitute(result, "<SRN>", "\<SNR>", "g")
" 	let result = substitute(result, "<SID>", "\<SID>", "g")
	return result
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
" ___Revitalizer___
" NOTE: below code is generated by :Revitalize.
" Do not mofidify the code nor append new lines
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:___revitalizer_function___(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:___revitalizer_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze____revitalizer_SID$')
  endfunction
  let s:___revitalizer_sid = '<SNR>' . s:___revitalizer_SID() . '_'
  function! s:___revitalizer_function___(fstr) abort
    return function(substitute(a:fstr, 's:', s:___revitalizer_sid, 'g'))
  endfunction
endif

let s:___revitalizer_functions___ = {'extend': s:___revitalizer_function___('s:extend'),'command': s:___revitalizer_function___('s:command')}

unlet! s:___revitalizer_sid
delfunction s:___revitalizer_function___

function! vital#_easymotion#Palette#Capture#import() abort
  return s:___revitalizer_functions___
endfunction
" ___Revitalizer___
