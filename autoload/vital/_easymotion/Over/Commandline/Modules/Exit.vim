scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:module = {
\	"name" : "Exit",
\	"exit_code" : 0
\}


function! s:module.on_char_pre(cmdline)
	if a:cmdline.is_input("<Over>(exit)")
		call a:cmdline.setchar("")
		call a:cmdline.exit(self.exit_code)
	endif
endfunction


function! s:make()
	return deepcopy(s:module)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
