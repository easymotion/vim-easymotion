scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:module = {
\	"name" : "History",
\	"mode" : "cmd",
\}

function! s:module.histories()
	return map(range(&history), 'histget(self.mode, v:val * -1)')
endfunction


function! s:module.on_enter(...)
	let s:cmdhist = []
	let s:count = 0
endfunction

function! s:module.on_char_pre(cmdline)
	if !a:cmdline.is_input("\<Up>") && !a:cmdline.is_input("\<Down>")
		let s:cmdhist = []
		let s:count = 0
		return
	else
		if s:count == 0 && empty(s:cmdhist)
			let cmdline = '^' . a:cmdline.getline()
			let s:cmdhist = filter(self.histories(), 'v:val =~ cmdline')
		endif
	endif
	call a:cmdline.setchar("")
	if a:cmdline.is_input("\<Down>")
		let s:count = max([s:count - 1, 0])
	endif
	if a:cmdline.is_input("\<Up>")
		let s:count = min([s:count + 1, len(s:cmdhist)])
	endif
	call a:cmdline.setline(get(s:cmdhist, s:count, a:cmdline.getline()))
endfunction

function! s:make(...)
	let module = deepcopy(s:module)
	let module.mode = get(a:, 1, "cmd")
	return module
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
