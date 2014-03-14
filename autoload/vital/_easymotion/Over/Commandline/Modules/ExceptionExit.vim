scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:module = {
\	"name" : "ExceptionExit",
\}


function! s:module.on_exception(cmdline)
	call a:cmdline.exit(-1)
endfunction


function! s:make(...)
	let result = deepcopy(s:module)
	let result.exit_code = get(a:, 1, 0)
	return result
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
