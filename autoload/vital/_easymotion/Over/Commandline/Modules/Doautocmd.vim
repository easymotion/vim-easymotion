scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:cache_command = {}
function! s:doautocmd_user(prefix, command)
	let group =  a:prefix . "-vital-over-commandline-doautocmd-dummy"
	if !has_key(s:cache_command, a:command)
		execute "autocmd " . group
\			. " User " . a:command." silent! execute ''"

		if v:version > 703 || v:version == 703 && has("patch438")
			let s:cache_command[a:command] = "doautocmd <nomodeline> User " . a:command
		else
			let s:cache_command[a:command] = "doautocmd User " . a:command
		endif
	endif

	execute s:cache_command[a:command]
endfunction

let s:hooks = [
\	"enter",
\	"leave",
\	"char",
\	"char_pre",
\	"draw",
\	"draw_pre",
\	"execute_pre",
\	"execute_failed",
\	"execute",
\	"exception",
\]

let s:hooks_camel = [
\	"Enter",
\	"Leave",
\	"Char",
\	"CharPre",
\	"Draw",
\	"DrawPre",
\	"ExecutePre",
\	"ExecuteFailed",
\	"Execute",
\	"Exception",
\]


let s:module = {
\	"name" : "Doautocmd",
\}


for s:i in range(len(s:hooks))
	execute join([
\		"function! s:module.on_" . s:hooks[s:i] . "(...)",
\		"	call s:doautocmd_user(self.prefix, self.prefix . " . string(s:hooks_camel[s:i]) . ")",
\		"endfunction",
\	], "\n")
endfor


function! s:make(prefix)
	execute "augroup " a:prefix . "-vital-over-commandline-doautocmd-dummy"
		autocmd!
	augroup END

	let module = deepcopy(s:module)
	let module.prefix = a:prefix
	return module
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
