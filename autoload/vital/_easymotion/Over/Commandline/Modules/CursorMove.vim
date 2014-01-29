scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:module = {
\	"name" : "CursorMove"
\}
function! s:module.on_charpre(cmdline)
	if a:cmdline.is_input("\<C-f>")
		call a:cmdline.line.next()
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<C-b>")
		call a:cmdline.line.prev()
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<C-d>")
		call a:cmdline.line.remove_pos()
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<C-a>")
		call a:cmdline.setline(0)
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<C-e>")
		call a:cmdline.setline(a:cmdline.line.length())
		call a:cmdline.setchar('')
	endif
endfunction


function! s:make()
	return deepcopy(s:module)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
