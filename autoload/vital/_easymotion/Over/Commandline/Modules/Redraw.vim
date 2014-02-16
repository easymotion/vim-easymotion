scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:module = {
\	"name" : "Redraw",
\}

function! s:module.on_execute_pre(cmdline)
	call self.redraw(a:cmdline)
endfunction

function! s:module.on_enter(...)
	let self.is_execute = 0
endfunction

function! s:module.on_execute(...)
	let self.is_execute = 1
endfunction

function! s:module.on_execute_failed(...)
	let self.is_execute = 0
endfunction

function! s:module.on_leave(cmdline)
	if self.is_execute == 0
		call self.redraw(a:cmdline)
	endif
endfunction

function! s:module.redraw(...)
	redraw
	echo ""
endfunction

function! s:make()
	return deepcopy(s:module)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
