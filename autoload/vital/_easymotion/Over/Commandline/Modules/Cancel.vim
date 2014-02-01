scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:module = {
\	"name" : "Cancel"
\}

function! s:module.on_char_pre(cmdline)
	if a:cmdline.is_input("\<Esc>")
\	|| a:cmdline.is_input("\<C-c>")
\	||(a:cmdline.is_input("\<BS>") && a:cmdline.line.length() == 0)
\	||(a:cmdline.is_input("\<C-h>") && a:cmdline.line.length() == 0)
		call a:cmdline.cancel()
		call a:cmdline.setchar("")
	endif
endfunction


function! s:make()
	return deepcopy(s:module)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
