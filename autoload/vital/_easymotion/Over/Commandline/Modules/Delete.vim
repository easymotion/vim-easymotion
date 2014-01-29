scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:module = {
\	"name" : "Delete",
\}
function! s:module.on_charpre(cmdline)
	if a:cmdline.is_input("\<C-h>")
		if a:cmdline.line.length() == 0
			call a:cmdline.exit()
		endif
		call a:cmdline.line.remove_prev()
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<C-w>")
		let backward = matchstr(a:cmdline.backward(), '^\zs.\{-}\ze\(\(\w*\)\|\(.\)\)$')
		call a:cmdline.setline(backward . a:cmdline.line.pos_word() . a:cmdline.forward())
		call a:cmdline.setline(strchars(backward))
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("\<C-u>")
		call a:cmdline.setline(a:cmdline.line.pos_word() . a:cmdline.forward())
		call a:cmdline.setline(0)
		call a:cmdline.setchar('')
	endif
endfunction


function! s:make()
	return deepcopy(s:module)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
