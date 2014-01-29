scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim



let s:module = {
\	"name" : "Incsearch",
\	"highlights" : {
\		"incserach" : "IncSearch"
\	},
\	"pattern" : "",
\	"search_flag" : "",
\	"mode" : "",
\}


function! s:module.search_hl_off()
	if exists("self.search_hl_id")
		call matchdelete(self.search_hl_id)
		unlet self.search_hl_id
	endif
endfunction


function! s:module.search_hl_on(pattern)
	call self.search_hl_off()
	let self.search_hl_id = matchadd(self.highlights.incserach, a:pattern)
endfunction


function! s:module.on_enter(...)
	let self.old_pos = getpos(".")
endfunction


function! s:module.on_leave(...)
	call setpos(".", self.old_pos)
	call self.search_hl_off()
endfunction


function! s:module.on_char(cmdline)
	call self.search_hl_off()
	let line = a:cmdline.getline()
	let result = get(matchlist(line, self.pattern), 1, "")
	if result != ""
		let pos = searchpos(result, self.search_flag)
		if pos == [0, 0]
			return
		endif
		call self.search_hl_on('\%' . pos[0] . 'l' . (&ignorecase ? '\c' : "") . result)
	endif
endfunction

function! s:make(...)
	let module = deepcopy(s:module)
	let module.mode   = get(a:, 1, "/")
	let module.pattern = get(a:, 2, '^\(.\+\)')
	let module.search_flag = get(a:, 3, 'c')
	return module
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
