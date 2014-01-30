scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:module = {
\	"name" : "CursorMove"
\}
function! s:module.on_char_pre(cmdline)
	if a:cmdline.is_input("\<Right>")
		call a:cmdline.line.next()
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<Left>")
		call a:cmdline.line.prev()
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<C-b>")
\		|| a:cmdline.is_input("\<Home>")
		call a:cmdline.setline(0)
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<C-e>")
\		|| a:cmdline.is_input("\<End>")
		call a:cmdline.setline(a:cmdline.line.length())
		call a:cmdline.setchar('')
	endif
endfunction


function! s:make()
	return deepcopy(s:module)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
