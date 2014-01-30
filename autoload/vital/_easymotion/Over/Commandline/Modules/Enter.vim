scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:module = {
\	"name" : "Enter"
\}

function! s:module.on_char_pre(cmdline)
	if a:cmdline.is_input("\<CR>")
\	|| a:cmdline.is_input("\<NL>")
\	|| a:cmdline.is_input("\<C-j>")
		call a:cmdline.exit(0)
		call a:cmdline.setchar("")
	endif
endfunction


function! s:make()
	return deepcopy(s:module)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
