scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:capture(cmd)
	let verbose_save = &verbose
	let &verbose = 0
	try
		redir => result
		execute "silent!" a:cmd
		redir END
	finally
		let &verbose = verbose_save
	endtry
	return result
endfunction


function! s:escape_key(key)
	execute 'let result = "' . substitute(escape(a:key, '\"'), '\(<.\{-}>\)', '\\\1', 'g') . '"'
	return result
endfunction


function! s:parse_mapping_lhs(map, mode)
	return matchstr(a:map, a:mode . '\s\+\zs\S\{-}\ze\s\+')
endfunction


function! s:lhss(mode)
	let maps = s:capture(a:mode . "map")
	return filter(map(split(maps, "\n"), "s:parse_mapping_lhs(v:val, a:mode)"), 'v:val =~ ''\S\+''')
endfunction


function! s:rhss(mode, ...)
	let abbr = get(a:, 1, 0)
	let dict = get(a:, 2, 0)
	return map(s:lhss(a:mode), "maparg(v:val, a:mode, abbr, dict)")
endfunction


function! s:cmap_lhss()
	return s:lhss("c")
endfunction


function! s:cmap_rhss(...)
	return call("s:rhss", ["c"] + a:000)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
