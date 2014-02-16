scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:_vital_loaded(V)
	let s:V = a:V
endfunction


function! s:get(name)
	if exists("s:" . a:name)
		return s:{a:name}
	endif
	let s:{a:name} = s:V.import('Over.Commandline.Modules.' . a:name)
	return s:{a:name}
endfunction


function! s:make(name, ...)
	let module = s:get(a:name)
	return call(module.make, a:000, module)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
