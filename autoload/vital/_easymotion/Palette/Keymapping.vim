scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:_vital_loaded(V)
	let s:V = a:V
	let s:Message  = s:V.import("Vim.Message")
endfunction


function! s:_vital_depends()
	return [
\		"Vim.Message",
\	]
endfunction


function! s:capture(...)
	let mode = get(a:, 1, "")
	if mode != "" && mode !~# "[nvoicsxl]"
		return ""
	endif
	return s:Message.capture(mode . "map")
endfunction


function! s:_keymapping(str)
	return a:str =~# '^[nvoicsxl]\s'
endfunction


function! s:capture_list(...)
	let mode = get(a:, 1, "")
	return filter(split(s:capture(mode), "\n"), "s:_keymapping(v:val)")
endfunction


function! s:escape_special_key(key)
	execute 'let result = "' . substitute(escape(a:key, '\"'), '\(<.\{-}>\)', '\\\1', 'g') . '"'
	return result
endfunction


function! s:parse_lhs(text, ...)
	let mode = get(a:, 1, '[nvoicsxl]')
	return matchstr(a:text, mode . '\s\+\zs\S\{-}\ze\s\+')
endfunction


function! s:parse_lhs_list(...)
	let mode = get(a:, 1, "")
	return map(s:capture_list(mode), "s:parse_lhs(v:val, mode)")
endfunction


function! s:lhs_key_list(...)
	let mode = get(a:, 1, "")
	return map(s:parse_lhs_list(mode), "s:escape_special_key(v:val)")
endfunction


function! s:rhs_key_list(...)
	let mode = get(a:, 1, "")
	let abbr = get(a:, 2, 0)
	let dict = get(a:, 3, 0)
	
	return map(s:parse_lhs_list(mode), "maparg(v:val, mode, abbr, dict)")
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
