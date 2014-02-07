scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:module = {
\	"name" : "Cancel"
\}

function! s:module.on_char_pre(cmdline)
	if a:cmdline.is_input("\<Esc>")
\	|| a:cmdline.is_input("\<C-c>")
" 		call a:cmdline.cancel()
		call a:cmdline.exit(1)
		call a:cmdline.setchar("")
	endif
endfunction


function! s:make()
	return deepcopy(s:module)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
