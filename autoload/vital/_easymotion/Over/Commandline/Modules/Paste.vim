scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:module = {
\	"name" : "Paste"
\}

function! s:module.on_char_pre(cmdline)
	if a:cmdline.is_input("<Over>(paste)")
		let register = v:register == "" ? '"' : v:register
		call a:cmdline.insert(tr(getreg("*"), "\n", "\r"))
		call a:cmdline.setchar('')
	endif
endfunction


function! s:make()
	return deepcopy(s:module)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
