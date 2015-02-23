scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:module = {
\	"name" : "NoInsert",
\	"chars" : []
\}


function! s:module.is_no_insert(char)
	return index(self.chars, a:char) >= 0
endfunction


function! s:module.on_char_pre(cmdline)
	if self.is_no_insert(a:cmdline.char())
		call a:cmdline.setchar("", 0)
	endif
endfunction


function! s:make(chars)
	let module = deepcopy(s:module)
	let module.chars = type(a:chars) == type([]) ? a:chars : [a:chars]
	return module
endfunction


function! s:make_special_chars()
	let module = s:make([])
	function! module.is_no_insert(char)
		return char2nr(a:char) == 128 || char2nr(a:char) < 27
	endfunction
	return module
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
