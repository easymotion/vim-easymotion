scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim



function! s:to_string(expr)
	return type(a:expr) == type("") ? a:expr : string(a:expr)
endfunction


function! s:input(cmdline)
	call a:cmdline.hl_cursor_on()
	try
		redraw
		let input = input("=", "", "expression")
		if !empty(input)
			let input = s:to_string(eval(input))
		endif
	catch
		return ""
	finally
		call a:cmdline.hl_cursor_off()
	endtry
	return input
endfunction


let s:module = {
\	"name" : "InsertRegister"
\}


function! s:module.on_enter(...)
	let self.cword = expand("<cword>")
	let self.cWORD = expand("cWORD")
	let self.cfile = expand("<cfile>")
endfunction


function! s:module.on_char_pre(cmdline)
	if a:cmdline.is_input("\<C-r>")
		call a:cmdline.setchar('"')
		call a:cmdline.tap_keyinput("InsertRegister")
		let self.old_line = a:cmdline.getline()
		let self.old_pos  = a:cmdline.getpos()
		return
	elseif a:cmdline.get_tap_key() == "InsertRegister"
		call a:cmdline.setline(self.old_line)
		call a:cmdline.setpos(self.old_pos)
		let char = a:cmdline.char()
		if char =~ '^[0-9a-zA-z.%#:/"\-*]$'
 			execute "let regist = @" . char
			call a:cmdline.setchar(regist)
		elseif a:cmdline.is_input('=', "InsertRegister")
			call a:cmdline.setchar(s:input(a:cmdline))
		elseif a:cmdline.is_input("\<C-w>", "InsertRegister")
			call a:cmdline.setchar(self.cword)
		elseif a:cmdline.is_input("\<C-a>", "InsertRegister")
			call a:cmdline.setchar(self.cWORD)
		elseif a:cmdline.is_input("\<C-f>", "InsertRegister")
			call a:cmdline.setchar(self.cfile)
		elseif a:cmdline.is_input("\<C-r>", "InsertRegister")
			call a:cmdline.setchar('"')
		else
			call a:cmdline.setchar("")
		endif
	endif
endfunction


function! s:module.on_char(cmdline)
	if a:cmdline.is_input("\<C-r>", "InsertRegister")
		call a:cmdline.setpos(a:cmdline.getpos()-1)
	else
		call a:cmdline.untap_keyinput("InsertRegister")
	endif
endfunction



function! s:make()
	return deepcopy(s:module)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
