scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


let s:modules = [
\	"Scroll",
\	"CursorMove",
\	"Delete",
\	"Paste",
\	"HistAdd",
\	"History",
\	"Incsearch",
\	"BufferComplete",
\]

let s:modules_snake = [
\	"scroll",
\	"cursor_move",
\	"delete",
\	"paste",
\	"histadd",
\	"history",
\	"incsearch",
\	"buffer_complete",
\]


function! s:_vital_loaded(V)
	let s:V = a:V
	for module in s:modules
		let s:{module} = s:V.import('Over.Commandline.Modules.' . module)
	endfor
endfunction


function! s:_vital_depends()
	return map(copy(s:modules), "'Over.Commandline.Modules.' . v:val")
endfunction



let s:base = {
\	"prompt" : "> ",
\	"line" : {},
\	"variables" : {
\		"char" : "",
\		"input" : "",
\		"wait_key" : "",
\	},
\	"highlights" : {
\		"Cursor" : "OverCommandLineDefaultCursor",
\		"CursorInsert" : "OverCommandLineDefaultCursorInsert"
\	},
\	"modules" : {},
\	"keys" : {
\		"quit"  : "\<Esc>",
\		"enter" : "\<CR>",
\	}
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
	return self.line.set_pos(pos)
endfunction


function! s:base.wait_keyinput_on(key)
	let self.variables.wait_key = a:key
endfunction


function! s:base.wait_keyinput_off(key)
	if self.variables.wait_key == a:key
		let self.variables.wait_key = ""
		return 1
	endif
endfunction


function! s:base.get_wait_keyinput()
	return self.variables.wait_key
endfunction


function! s:base.is_input(key, ...)
	let prekey = get(a:, 1, "")
	return self.get_wait_keyinput() == prekey
\		&& get(self.keymappings(), self.char(), self.char()) == a:key
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


function! s:base.connect(module)
	let self.modules[a:module.name] = a:module
endfunction


for s:_ in ["enter", "leave", "char", "charpre", "executepre", "execute", "cancel"]
	execute join([
\		"function! s:base._on_" . s:_ . "()",
\		"	call map(copy(self.modules), 'has_key(v:val, \"on_" . s:_ . "\") ? v:val.on_" . s:_ . "(self) : 0')",
\		"	call self.on_" . s:_ . "()",
\		"endfunction",
\	], "\n")
	
	execute "function! s:base.on_" . s:_ . "()"
		
	endfunction
endfor
unlet s:_


" Overridable
function! s:base.keymappings()
	return {}
endfunction


function! s:make(prompt)
	let result = deepcopy(s:base)
	let result.prompt = a:prompt
	return result
endfunction


function! s:make_simple(prompt)
	let result = s:make(a:prompt)
	call result.connect(s:module_scroll())
	call result.connect(s:module_delete())
	call result.connect(s:module_cursor_move())
	call result.connect(s:module_histadd())
	call result.connect(s:module_history())
	call result.connect(s:module_buffer_complete())
	return result
endfunction


function! s:_echo_cmdline(cmdline)
	redraw
	echon a:cmdline.prompt . a:cmdline.backward()
	if empty(a:cmdline.line.pos_word())
		execute "echohl" a:cmdline.highlights.Cursor
		echon  ' '
	else
		execute "echohl" a:cmdline.highlights.CursorInsert
		echon a:cmdline.line.pos_word()
	endif
	echohl NONE
	echon a:cmdline.forward()
endfunction


function! s:base.execute()
	execute self.getline()
endfunction


function! s:base.exit(...)
	let self.variables.exit = get(a:, 1, 0)
endfunction


function! s:base.is_exit()
	return has_key(self.variables, "exit")
endfunction


function! s:base.start(...)
	let result = call(self.get, a:000, self)
	if result == ""
		return
	endif
	call self._execute()
endfunction


function! s:base.get(...)
	try
		call self._init()
		let self.line = deepcopy(s:_string_with_pos(get(a:, 1, "")))
		call self._on_enter()
		call self._inputkey()

		while !self.is_input(self.keys.quit)
			if self.is_input(self.keys.enter)
				return self.getline()
			else
				call self.insert(self.variables.input)
			endif
			call self._on_char()

			if self.is_exit()
				call s:_redraw()
				return ""
			endif

			call self._inputkey()
		endwhile
		call self._on_cancel()
		call s:_redraw()
	catch
		echohl ErrorMsg | echo v:throwpoint . " " . v:exception | echohl None
	finally
		call self._finish()
		call self._on_leave()
	endtry
	return ""
endfunction


function! s:base._init()
	let self.variables.wait_key = ""
	let self.variables.char = ""
	let self.variables.input = ""
	let hl_cursor = s:_hl_cursor_off()
	if !hlexists("OverCommandLineDefaultCursor")
		execute "highlight OverCommandLineDefaultCursor " . hl_cursor
	endif
	if !hlexists("OverCommandLineDefaultCursorInsert")
		execute "highlight OverCommandLineDefaultCursorInsert " . hl_cursor . " term=underline gui=underline"
	endif
	let s:old_t_ve = &t_ve
	set t_ve=
endfunction


function! s:base._execute()
	call self._on_executepre()
	try
		call self.execute()
	catch
		echohl ErrorMsg
		echo matchstr(v:exception, 'Vim\((\w*)\)\?:\zs.*\ze')
		echohl None
	finally
		call self._on_execute()
	endtry
endfunction


function! s:base._finish()
	cal s:_hl_cursor_on()
	let &t_ve = s:old_t_ve
endfunction


function! s:base._inputkey()
	call s:_echo_cmdline(self)
	let self.variables.char = s:_getchar()
	call self.setchar(self.variables.char)
	call self._on_charpre()
endfunction



for s:i in range(len(s:modules_snake))
	execute join([
\		"function! s:module_" . s:modules_snake[s:i] . "(...)",
\		"	return call(s:" . s:modules[s:i] . ".make, a:000, s:" . s:modules[s:i] . ")",
\		"endfunction",
\	], "\n")
endfor
unlet s:i





function! s:_redraw()
	redraw
	echo ""
endfunction


function! s:_getchar()
	let char = getchar()
	return type(char) == type(0) ? nr2char(char) : char
endfunction


function! s:_hl_cursor_on()
	if exists("s:old_hi_cursor")
		execute "highlight Cursor " . s:old_hi_cursor
		unlet s:old_hi_cursor
	endif
endfunction


function! s:_hl_cursor_off()
	if exists("s:old_hi_cursor")
		return s:old_hi_cursor
	endif
	let s:old_hi_cursor = "cterm=reverse"
	if hlexists("Cursor")
		redir => cursor
		silent highlight Cursor
		redir END
		let hl = substitute(matchstr(cursor, 'xxx \zs.*'), '[ \t\n]\+\|cleared', ' ', 'g')
		if !empty(substitute(hl, '\s', '', 'g'))
			let s:old_hi_cursor = hl
		endif
		highlight Cursor NONE
	endif
	return s:old_hi_cursor
endfunction


function! s:_clamp(x, max, min)
	return min([max([a:x, a:max]), a:min])
endfunction


function! s:_string_with_pos(...)
	let default = get(a:, 1, "")
	let self = {}
	
	function! self.set(item)
		return type(a:item) == type("") ? self.set_str(a:item)
\			 : type(a:item) == type(0)  ? self.set_pos(a:item)
\			 : self
	endfunction

	function! self.str()
		return join(self.list, "")
	endfunction

	function! self.set_pos(pos)
		let self.col = s:_clamp(a:pos, 0, self.length())
		return self
	endfunction

	function! self.backward()
		return self.col > 0 ? join(self.list[ : self.col-1], '') : ""
	endfunction

	function! self.forward()
		return join(self.list[self.col+1 : ], '')
	endfunction

	function! self.pos_word()
		return get(self.list, self.col, "")
	endfunction

	function! self.set_str(str)
		let self.list = split(a:str, '\zs')
		let self.col  = strchars(a:str)
		return self
	endfunction

	function! self.pos()
		return self.col
	endfunction

	function! self.input(str)
		call extend(self.list, split(a:str, '\zs'), self.col)
		let self.col += len(split(a:str, '\zs'))
		return self
	endfunction

	function! self.length()
		return len(self.list)
	endfunction

	function! self.next()
		return self.set_pos(self.col + 1)
	endfunction

	function! self.prev()
		return self.set_pos(self.col - 1)
	endfunction

	function! self.remove(index)
		if a:index < 0 || self.length() <= a:index
			return self
		endif
		unlet self.list[a:index]
		if a:index < self.col
			call self.set(self.col - 1)
		endif
		return self
	endfunction

	function! self.remove_pos()
		return self.remove(self.col)
	endfunction

	function! self.remove_prev()
		return self.remove(self.col - 1)
	endfunction

	function! self.remove_next()
		return self.remove(self.col + 1)
	endfunction

	call self.set(default)
	return self
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
