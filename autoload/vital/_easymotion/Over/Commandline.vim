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
	let s:String  = s:V.import("Over.String")
	let s:Signals = s:V.import("Over.Signals")
	let s:base.variables.modules = s:Signals.make()
	function! s:base.variables.modules.get_slot(val)
		return a:val.slot.module
	endfunction
endfunction


function! s:_vital_depends()
	return [
\		"Over.String",
\		"Over.Signals",
\	] + map(copy(s:modules), "'Over.Commandline.Modules.' . v:val")
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
	call result.connect(result, "_")
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
\	},
\	"highlights" : {
\		"prompt" : "NONE",
\		"cursor" : "OverCommandLineDefaultCursor",
\		"cursor_on" : "OverCommandLineDefaultCursorOn",
\		"cursor_insert" : "OverCommandLineDefaultOnCursor",
\	},
\}

if exists("s:Signals")
	let s:base.variables.modules = s:Signals.make()
	function! s:base.variables.modules.get_slot(val)
		return a:val.slot.module
	endfunction
endif



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
" \		&& self.char() == (prekey . a:key)
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
		return call(self.connect, [s:get_module(a:module).make()] + a:000, self)
	endif
	let name = a:0 > 0 ? a:1 : a:module.name
	let slot = self.variables.modules.find_first_by("get(v:val.slot, 'name', '') == " . string(name))
	if empty(slot)
		call self.variables.modules.connect({ "name" : name, "module" : a:module })
	else
		let slot.slot.module = a:module
	endif
" 	let self.variables.modules[name] = a:module
endfunction


function! s:base.disconnect(name)
	return self.variables.modules.disconnect_by(
\		"get(v:val.slot, 'name', '') == " . string(a:name)
\	)
" 	unlet self.variables.modules[a:name]
endfunction


function! s:base.callevent(event)
	call self.variables.modules.sort_by("has_key(v:val.slot.module, 'priority') ? v:val.slot.module.priority('" . a:event . "') : 0")
	return self.variables.modules.call(a:event, [self])
" 	call map(filter(copy(self.variables.modules), "has_key(v:val, a:event)"), "v:val." . a:event . "(self)")
endfunction


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
	if exists("self.variables.old_guicursor")
		let &guicursor = self.variables.old_guicursor
		unlet self.variables.old_guicursor
	endif

	if exists("self.variables.old_t_ve")
		let &t_ve = self.variables.old_t_ve
		unlet self.variables.old_t_ve
	endif
endfunction


function! s:base.hl_cursor_off()
	if exists("self.variables.old_t_ve")
		return
	endif

	let self.variables.old_guicursor = &guicursor
	set guicursor=a:block-NONE
	let self.variables.old_t_ve = &t_ve
	set t_ve=
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
	call self.hl_cursor_off()
	if !hlexists("OverCommandLineDefaultCursor")
		highlight link OverCommandLineDefaultCursor Cursor
	endif
	if !hlexists("OverCommandLineDefaultCursorOn")
		highlight link OverCommandLineDefaultCursorOn OverCommandLineDefaultCursor
	endif
	if !hlexists("OverCommandLineDefaultCursorInsert")
		highlight OverCommandLineDefaultCursorInsert cterm=underline term=underline gui=underline
	endif
endfunction


function! s:base._execute()
	call s:redraw()
	call self.callevent("on_execute_pre")
	try
		call self.execute()
	catch
		echohl ErrorMsg
		echo matchstr(v:exception, 'Vim\((\w*)\)\?:\zs.*\ze')
		echohl None
		call self.callevent("on_execute_failed")
	finally
		call self.callevent("on_execute")
	endtry
endfunction


function! s:base._main(...)
	try
		call self._init()
		let self.line = deepcopy(s:String.make(get(a:, 1, "")))
		call self.callevent("on_enter")

		while !self._is_exit()
			call s:_echo_cmdline(self)

			let self.variables.input_key = s:_getchar()
			let self.variables.char = s:_unmap(self._get_keymapping(), self.variables.input_key)
" 			let self.variables.char = s:_unmap(self._get_keymapping(), self.get_tap_key() . self.variables.input_key)

			call self.setchar(self.variables.char)

			call self.callevent("on_char_pre")
			call self.insert(self.variables.input)
			call self.callevent("on_char")
		endwhile
	catch
		echohl ErrorMsg | echo v:throwpoint . " " . v:exception | echohl None
		return -1
	finally
		call self._finish()
		call s:redraw()
		call self.callevent("on_leave")
	endtry
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
		execute "echohl" a:cmdline.highlights.cursor_on
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
" 	for module in values(self.variables.modules)
	for module in self.variables.modules.slots()
		if has_key(module, "keymapping")
			if module isnot self
				call extend(result, module.keymapping(self))
			endif
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
