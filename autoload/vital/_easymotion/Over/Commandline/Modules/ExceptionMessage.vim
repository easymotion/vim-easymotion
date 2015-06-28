scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:vname = expand("<sfile>:h:h:h:h:t")


let s:module = {
\	"name" : "ExceptionMessage",
\}


function! s:module.on_exception(cmdline)
	let self.exception  = v:exception
	let self.throwpoint = v:throwpoint
endfunction


function! s:module.on_draw_pre(cmdline)
	if has_key(self, "exception")
		call self.message(a:cmdline)
		unlet self.exception
	endif
endfunction

function! s:module.message(...)
	echohl ErrorMsg
	execute self.command string(self.prefix . " : " . self.throwpoint . " " . self.exception)
	echohl None
endfunction


function! s:module.on_leave(cmdline)
	if has_key(self, "exception")
		call self.message(a:cmdline)
		unlet self.exception
	endif
endfunction


function! s:make(...)
	let result = deepcopy(s:module)
	let result.prefix = get(a:, 1, "vital-over(".s:vname.") Exception")
	let result.command = get(a:, 2, "echom")
	return result
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
