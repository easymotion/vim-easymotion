scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:modules = [
\	"Scroll",
\	"CursorMove",
\	"Delete",
\	"HistAdd",
\	"History",
\	"Cancel",
\	"Enter",
\	"NoInsert",
\	"InsertRegister",
\]


function! s:_vital_loaded(V)
	let s:V = a:V
	for module in s:modules
		let s:{module} = s:V.import('Over.Commandline.Modules.' . module)
	endfor
	let s:String = s:V.import("Over.String")
endfunction


function! s:_vital_depends()
	return ["Over.String"]
\		 + map(copy(s:modules), "'Over.Commandline.Modules.' . v:val")
endfunction


function! s:get_module(name)
	if exists("s:" . a:name)
		return s:{a:name}
	endif
	let s:{a:name} = s:V.import('Over.Commandline.Modules.' . a:name)
	return s:{a:name}
endfunction


function! s:make_plain(prompt)
	let result = s:make(a:prompt)
	let result.prompt = a:prompt
	call result.connect("Enter")
	call result.connect("Cancel")
	return result
endfunction


function! s:make_standard(prompt)
	let result = s:make_plain(a:prompt)
	call result.connect("Delete")
	call result.connect("CursorMove")
	call result.connect("HistAdd")
	call result.connect("History")
	call result.connect("InsertRegister")
	call result.connect(s:get_module("NoInsert").make_special_chars())
	return result
endfunction


function! s:make(prompt)
	return deepcopy(s:base)
endfunction


let s:base = {
\	"prompt" : "",
\	"line" : {},
\	"variables" : {
\		"char" : "",
\		"input" : "",
\		"tap_key" : "",
\		"exit" : 0,
\		"keymapping" : {},
\		"modules" : {},
\	},
\	"highlights" : {
\		"prompt" : "NONE",
\		"cursor" : "OverCommandLineDefaultCursor",
\		"cursor_insert" : "OverCommandLineDefaultCursorInsert"
\	},
\}


function! s:base.getline()
	return self.line.str()
endfunction


function! s:base.setline(line)
	return self.line.set(a:line)
endfunction


function! s:base.char()
	return self.variables.char
endfunction


function! s:base.setchar(char)
	let self.variables.input = a:char
endfunction


function! s:base.getpos()
	return self.line.pos()
endfunction


function! s:base.setpos(pos)
	return self.line.set_pos(a:pos)
endfunction


function! s:base.tap_keyinput(key)
	let self.variables.tap_key = a:key
endfunction


function! s:base.untap_keyinput(key)
	if self.variables.tap_key == a:key
		let self.variables.tap_key = ""
		return 1
	endif
endfunction


function! s:base.get_tap_key()
	return self.variables.tap_key
endfunction


function! s:base.is_input(key, ...)
	let prekey = get(a:, 1, "")
	return self.get_tap_key() == prekey
\		&& self.char() == a:key
endfunction


function! s:base.input_key()
	return self.variables.input_key
endfunction


function! s:base.insert(word, ...)
	if a:0
		call self.line.set(a:1)
	endif
	call self.line.input(a:word)
endfunction

function! s:base.forward()
	return self.line.forward()
endfunction

function! s:base.backward()
	return self.line.backward()
endfunction


function! s:base.connect(module, ...)
	if type(a:module) == type("")
		return self.connect(s:get_module(a:module).make())
	endif
	let name = get(a:, 1, a:module.name)
	let self.variables.modules[name] = a:module
endfunction


function! s:base.disconnect(name)
	unlet self.variables.modules[a:name] = a:module
endfunction


for s:_ in ["enter", "leave", "char", "char_pre", "execute_pre", "execute_failed", "execute", "cancel"]
	execute join([
\		"function! s:base._on_" . s:_ . "()",
\		"	call map(copy(self.variables.modules), 'has_key(v:val, \"on_" . s:_ . "\") ? v:val.on_" . s:_ . "(self) : 0')",
\		"	call self.on_" . s:_ . "()",
\		"endfunction",
\	], "\n")
	
	execute "function! s:base.on_" . s:_ . "()"
	endfunction
endfor
unlet s:_


function! s:base.cmap(lhs, rhs)
	let self.variables.keymapping[a:lhs] = a:rhs
endfunction


function! s:base.cnoremap(lhs, rhs)
	let self.variables.keymapping[a:lhs] = {
\		"key"     : a:rhs,
\		"noremap" : 1,
\	}
endfunction


function! s:base.cunmap(lhs)
	unlet self.variables.keymapping[a:lhs]
endfunction


function! s:base.keymapping()
	return {}
endfunction


function! s:base.execute()
	execute self.getline()
endfunction


function! s:base.exit(...)
	let self.variables.exit = 1
	let self.variables.exit_code = get(a:, 1, 0)
endfunction


" function! s:base.cancel()
" 	call self.exit(1)
" 	call self._on_cancel()
" endfunction


function! s:base.exit_code()
	return self.variables.exit_code
endfunction


function! s:base.hl_cursor_on()
	if exists("self.variables.old_hi_cursor")
		execute "highlight Cursor " . self.variables.old_hi_cursor
		unlet self.variables.old_hi_cursor
	endif
	if exists("self.variables.old_t_ve")
		let &t_ve = self.variables.old_t_ve
		unlet self.variables.old_t_ve
	endif
endfunction


function! s:base.hl_cursor_off()
	if exists("self.variables.old_hi_cursor")
		return self.variables.old_hi_cursor
	endif
	let self.variables.old_hi_cursor = "cterm=reverse"
	if hlexists("Cursor")
		let save_verbose = &verbose
		let &verbose = 0
		try
			redir => cursor
			silent highlight Cursor
			redir END
		finally
			let &verbose = save_verbose
		endtry
		let hl = substitute(matchstr(cursor, 'xxx \zs.*'), '[ \t\n]\+\|cleared', ' ', 'g')
		if !empty(substitute(hl, '\s', '', 'g'))
			let self.variables.old_hi_cursor = hl
		endif
		highlight Cursor NONE
	endif
	let self.variables.old_t_ve = &t_ve
	set t_ve=

	return self.variables.old_hi_cursor
endfunction


function! s:base.start(...)
	let exit_code = call(self._main, a:000, self)
	if exit_code == 0
		call self._execute()
	endif
endfunction


function! s:base.get(...)
	let exit_code = call(self._main, a:000, self)
	if exit_code == 0
		return self.getline()
	endif
	return ""
endfunction


function! s:base._init()
	let self.variables.tap_key = ""
	let self.variables.char = ""
	let self.variables.input = ""
	let self.variables.exit = 0
	let self.variables.exit_code = 1
	let hl_cursor = self.hl_cursor_off()
	if !hlexists("OverCommandLineDefaultCursor")
		execute "highlight OverCommandLineDefaultCursor " . hl_cursor
	endif
	if !hlexists("OverCommandLineDefaultCursorInsert")
		execute "highlight OverCommandLineDefaultCursorInsert " . hl_cursor . " term=underline gui=underline"
	endif
endfunction


function! s:base._execute()
	call s:redraw()
	call self._on_execute_pre()
	try
		call self.execute()
	catch
		echohl ErrorMsg
		echo matchstr(v:exception, 'Vim\((\w*)\)\?:\zs.*\ze')
		echohl None
		call self._on_execute_failed()
	finally
		call self._on_execute()
	endtry
endfunction


function! s:base._main(...)
	try
		call self._init()
		let self.line = deepcopy(s:String.make(get(a:, 1, "")))
		call self._on_enter()

		while !self._is_exit()
			call s:_echo_cmdline(self)

			let self.variables.input_key = s:_getchar()
			let self.variables.char = s:_unmap(self._get_keymapping(), self.variables.input_key)

			call self.setchar(self.variables.char)

			call self._on_char_pre()
			call self.insert(self.variables.input)
			call self._on_char()
		endwhile
	catch
		echohl ErrorMsg | echo v:throwpoint . " " . v:exception | echohl None
		return -1
	finally
		call self._finish()
		call self._on_leave()
	endtry
	call s:redraw()
	return self.exit_code()
endfunction


function! s:base._finish()
	call self.hl_cursor_on()
endfunction


function! s:_echo_cmdline(cmdline)
	call s:redraw()
	execute "echohl" a:cmdline.highlights.prompt
	echon a:cmdline.prompt
	echohl NONE
	echon a:cmdline.backward()
	if empty(a:cmdline.line.pos_word())
		execute "echohl" a:cmdline.highlights.cursor
		echon  ' '
	else
		execute "echohl" a:cmdline.highlights.cursor_insert
		echon a:cmdline.line.pos_word()
	endif
	echohl NONE
	echon a:cmdline.forward()
endfunction


function! s:base._is_exit()
	return self.variables.exit
endfunction


function! s:_as_key_config(config)
	let base = {
\		"noremap" : 0,
\		"lock"    : 0,
\	}
	return type(a:config) == type({}) ? extend(base, a:config)
\		 : extend(base, {
\		 	"key" : a:config,
\		 })
endfunction


function! s:_unmap(mapping, key)
	if !has_key(a:mapping, a:key)
		return a:key
	endif
	let rhs  = s:_as_key_config(a:mapping[a:key])
	let next = s:_as_key_config(get(a:mapping, rhs.key, {}))
	if rhs.noremap && next.lock == 0
		return rhs.key
	endif
	return s:_unmap(a:mapping, rhs.key)
endfunction


function! s:base._get_keymapping()
	let result = {}
	for module in values(self.variables.modules)
		if has_key(module, "keymapping")
			call extend(result, module.keymapping(self))
		endif
	endfor
	return extend(extend(result, self.variables.keymapping), self.keymapping())
endfunction


function! s:redraw()
	redraw
	echo ""
endfunction


function! s:_getchar()
	let char = getchar()
	return type(char) == type(0) ? nr2char(char) : char
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
