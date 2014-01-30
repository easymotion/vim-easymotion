scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:module = {
\	"name" : "Scroll"
\}
function! s:module.on_char_pre(cmdline)
	if a:cmdline.is_input("<Over>(scroll-y)")
		execute "normal! \<C-y>"
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("<Over>(scroll-u)")
		execute "normal! \<C-u>"
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("<Over>(scroll-f)")
		execute "normal! \<C-f>"
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("<Over>(scroll-e)")
		execute "normal! \<C-e>"
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("<Over>(scroll-d)")
		execute "normal! \<C-d>"
		call a:cmdline.setchar('')
	elseif a:cmdline.is_input("<Over>(scroll-b)")
		execute "normal! \<C-b>"
		call a:cmdline.setchar('')
	endif
endfunction


function! s:make()
	return deepcopy(s:module)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
