scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:module = {
\	"name" : "Paste"
\}
function! s:module.on_charpre(cmdline)
	if a:cmdline.is_input("\<C-v>")
		call a:cmdline.insert(@*)
		call a:cmdline.setchar('')
	endif
endfunction


function! s:make()
	return deepcopy(s:module)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
