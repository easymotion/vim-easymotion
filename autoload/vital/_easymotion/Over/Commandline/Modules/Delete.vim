scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:module = {
\	"name" : "Delete",
\}
function! s:module.on_char_pre(cmdline)
	if a:cmdline.is_input("\<C-h>")
\	|| a:cmdline.is_input("\<BS>")
		if a:cmdline.line.length() == 0
			return a:cmdline.exit(1)
		else
			call a:cmdline.line.remove_prev()
			call a:cmdline.setchar('')
		endif
	elseif a:cmdline.is_input("\<Del>")
		call a:cmdline.line.remove_pos()
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<C-w>")
		let word = a:cmdline.backward_word()
		let backward = a:cmdline.backward()[ : -strlen(word)-1 ]
		call a:cmdline.setline(backward . a:cmdline.line.pos_char() . a:cmdline.forward())
		call a:cmdline.setline(strchars(backward))
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<C-u>")
		call a:cmdline.setline(a:cmdline.line.pos_char() . a:cmdline.forward())
		call a:cmdline.setline(0)
		call a:cmdline.setchar('')
	endif
endfunction


function! s:make()
	return deepcopy(s:module)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
