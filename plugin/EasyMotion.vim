" EasyMotion - Vim motions on speed!
"
" Author: Kim Silkebækken <kim.silkebaekken+vim@gmail.com>
" Source repository: https://github.com/Lokaltog/vim-easymotion

" Script initialization {{{
	if exists('g:EasyMotion_loaded') || &compatible || version < 702
		finish
	endif

	let g:EasyMotion_loaded = 1
" }}}
" Default configuration {{{
	function! s:InitOptions(options) " {{{
		for [key, value] in items(a:options)
			if ! exists('g:EasyMotion_' . key)
				exec 'let g:EasyMotion_' . key . ' = ' . string(value)
			endif
		endfor
	endfunction " }}}
	function! s:InitMappings(motions) "{{{
		for motion in keys(a:motions)
			call s:InitOptions({ 'mapping_' . motion : g:EasyMotion_leader_key . motion })
		endfor

		if g:EasyMotion_do_mapping
			for [motion, fn] in items(a:motions)
				silent exec 'nnoremap <silent> ' . g:EasyMotion_mapping_{motion} . '      :call EasyMotion#' . fn.name . '(0, ' . fn.dir . ')<CR>'
				silent exec 'onoremap <silent> ' . g:EasyMotion_mapping_{motion} . '      :call EasyMotion#' . fn.name . '(0, ' . fn.dir . ')<CR>'
				silent exec 'vnoremap <silent> ' . g:EasyMotion_mapping_{motion} . ' :<C-U>call EasyMotion#' . fn.name . '(1, ' . fn.dir . ')<CR>'
			endfor
		endif
	endfunction "}}}
	" Default options {{{
		call s:InitOptions({
		\   'leader_key' : '<Leader>'
		\ , 'keys'       : 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
		\ , 'do_shade'   : 1
		\ , 'do_mapping' : 1
		\ , 'grouping'   : 1
		\ })
	" }}}
	" Default key mapping {{{
		call s:InitMappings({
		\   'f' : { 'name': 'F'  , 'dir': 0 }
		\ , 'F' : { 'name': 'F'  , 'dir': 1 }
		\ , 't' : { 'name': 'T'  , 'dir': 0 }
		\ , 'T' : { 'name': 'T'  , 'dir': 1 }
		\ , 'w' : { 'name': 'WB' , 'dir': 0 }
		\ , 'W' : { 'name': 'WBW', 'dir': 0 }
		\ , 'b' : { 'name': 'WB' , 'dir': 1 }
		\ , 'B' : { 'name': 'WBW', 'dir': 1 }
		\ , 'e' : { 'name': 'E'  , 'dir': 0 }
		\ , 'E' : { 'name': 'EW' , 'dir': 0 }
		\ , 'ge': { 'name': 'E'  , 'dir': 1 }
		\ , 'gE': { 'name': 'EW' , 'dir': 1 }
		\ , 'j' : { 'name': 'JK' , 'dir': 0 }
		\ , 'k' : { 'name': 'JK' , 'dir': 1 }
		\ })
	" }}}
" }}}
