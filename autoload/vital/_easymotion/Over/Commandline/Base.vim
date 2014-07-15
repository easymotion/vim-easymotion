scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:_vital_loaded(V)
	let s:V = a:V
	let s:String  = s:V.import("Over.String")
	let s:Signals = s:V.import("Over.Signals")
	let s:Module = s:V.import("Over.Commandline.Modules")
	let s:List = s:V.import("Data.List")
	let s:base.variables.modules = s:Signals.make()
	function! s:base.variables.modules.get_slot(val)
		return a:val.slot.module
	endfunction
endfunction


function! s:_vital_depends()
	return [
\		"Over.String",
\		"Over.Signals",
\		"Over.Commandline.Modules",
\		"Data.List",
\	]
endfunction


function! s:make(...)
	let result = deepcopy(s:base)
	call result.set_prompt(get(a:, 1, ":"))
	call result.connect(result, "_")
	return result
endfunction


function! s:make_plain()
	return deepcpy(s:base)
endfunction


let s:base = {
\	"line" : {},
\	"variables" : {
\		"prompt" : "",
\		"char" : "",
\		"input" : "",
\		"tap_key" : "",
\		"exit" : 0,
\		"keymapping" : {},
\		"suffix" : "",
\	},
\	"highlights" : {
\		"prompt" : "NONE",
\		"cursor" : "VitalOverCommandLineCursor",
\		"cursor_on" : "VitalOverCommandLineCursorOn",
\		"cursor_insert" : "VitalOverCommandLineOnCursor",
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


function! s:base.setchar(char, ...)
	" 1 の場合は既に設定されていても上書きする
	" 0 の場合は既に設定されていれば上書きしない
	let overwrite = get(a:, 1, 1)
	if overwrite || self.variables.input == self.char()
		let self.variables.input = a:char
	endif
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


function! s:base.set_prompt(prompt)
	let self.variables.prompt = a:prompt
endfunction


function! s:base.get_prompt()
	return self.variables.prompt
endfunction


function! s:base.set_suffix(str)
	let self.variables.suffix = a:str
endfunction


function! s:base.get_suffix()
	return self.variables.suffix
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
		return call(self.connect, [s:Module.make(a:module)] + a:000, self)
	endif
	if empty(a:module)
		return
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


function! s:base.get_module(name)
	let slot = self.variables.modules.find_first_by("get(v:val.slot, 'name', '') == " . string(a:name))
	return empty(slot) ? {} : slot.slot.module
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


function! s:base.execute(...)
	let command = get(a:, 1, self.getline())
	call self._execute(command)
" 	execute self.getline()
endfunction


function! s:base.draw()
	call self.callevent("on_draw_pre")
	call self.callevent("on_draw")
endfunction


function! s:base.exit(...)
	let self.variables.exit = 1
	let self.variables.exit_code = get(a:, 1, 0)
endfunction


function! s:base.enable_keymapping()
	let self.variables.enable_keymapping = 1
endfunction


function! s:base.disable_keymapping()
	let self.variables.enable_keymapping = 0
endfunction


function! s:base.is_enable_keymapping()
	return self.variables.enable_keymapping
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
		set guicursor&
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
	set guicursor=n:block-NONE
	let self.variables.old_t_ve = &t_ve
	set t_ve=
endfunction


function! s:base.start(...)
	let exit_code = call(self._main, a:000, self)
	return exit_code
endfunction


function! s:base.__empty(...)
endfunction


function! s:base.get(...)
	let Old_execute = self.execute
	let self.execute = self.__empty
	try
		let exit_code = self.start()
		if exit_code == 0
			return self.getline()
		endif
	finally
		let self.execute = Old_execute
	endtry
	return ""
endfunction


function! s:base._init()
	let self.variables.tap_key = ""
	let self.variables.char = ""
	let self.variables.input = ""
	let self.variables.exit = 0
	let self.variables.exit_code = 1
	let self.variables.enable_keymapping = 1
	call self.hl_cursor_off()
	if !hlexists(self.highlights.cursor)
		execute "highlight link " . self.highlights.cursor . " Cursor"
	endif
	if !hlexists(self.highlights.cursor_on)
		execute "highlight link " . self.highlights.cursor_on . " " . self.highlights.cursor
	endif
	if !hlexists(self.highlights.cursor_insert)
		execute "highlight " . self.highlights.cursor_insert . " cterm=underline term=underline gui=underline"
	endif
endfunction


function! s:base._execute(command)
	call self.callevent("on_execute_pre")
	try
		execute a:command
	catch
		echohl ErrorMsg
		echom matchstr(v:exception, 'Vim\((\w*)\)\?:\zs.*\ze')
		echohl None
		call self.callevent("on_execute_failed")
	finally
		call self.callevent("on_execute")
	endtry
endfunction


function! s:base._input(input, ...)
	let self.variables.input_key = a:input
	if self.is_enable_keymapping()
		let key = s:_unmap(self._get_keymapping(), a:input)
	else
		let key = a:input
	endif

	for char in s:_split_keys(key)
		let self.variables.input_key = char
		let self.variables.char = char
		call self.setchar(self.variables.char)
		call self.callevent("on_char_pre")
		call self.insert(self.variables.input)
		call self.callevent("on_char")
	endfor
endfunction


function! s:base._main(...)
	try
		call self._init()
		let self.line = deepcopy(s:String.make(get(a:, 1, "")))
		call self.callevent("on_enter")

		call self.draw()
		while !self._is_exit()
			try
" 				call self.callevent("on_update")
" 				if !getchar(1)
" 					continue
" 				endif
"
" 				call self._input(s:_getchar(0))
" 				call self.draw()
				call self._input(s:_getchar())
				call self.draw()
			catch
				call self.callevent("on_exception")
			endtry
		endwhile
	catch
		echohl ErrorMsg | echom v:throwpoint . " " . v:exception | echohl None
		let self.variables.exit_code = -1
	finally
		call self._finish()
		call self.callevent("on_leave")
	endtry
	return self.exit_code()
endfunction


function! s:base._finish()
	call self.hl_cursor_on()
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
	let keys = s:_split_keys(a:key)
	if len(keys) > 1
		return join(map(keys, 's:_unmap(a:mapping, v:val)'), '')
	endif
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


function! s:_getchar(...)
	let char = call("getchar", a:000)
	return type(char) == type(0) ? nr2char(char) : char
endfunction



function! s:_split(str, pat)
	let pat = '\%#=2' . a:pat
	let list = split(a:str,  pat . '\zs')
	return s:List.flatten(map(list, 'v:val == a:pat ? a:pat : v:val =~ pat . ''$'' ? split(v:val, pat) + [a:pat] : v:val'))
endfunction


function! s:_split_keystring(str, pats, ...)
	if a:str =~ '^<Over>(.\{-})$'
\	|| a:str =~ "^\<Plug>(.\\{-})$"
		return [a:str]
	endif
	let pats = a:pats
	let index = get(a:, 1, 0)
	if !exists("+regexpengine")
\	|| index > len(pats)
\	|| len(filter(copy(pats), 'a:str =~ ''\%#=2'' . v:val')) == 0
		if len(filter(copy(pats), 'a:str ==# v:val')) == 0
			return split(a:str, '\zs')
		else
			return [a:str]
		endif
	endif
	if len(filter(copy(pats), 'a:str == v:val')) == 1
		return [a:str]
	endif

	let result = []
	let pat = pats[index]
	let list = s:_split(a:str, pat)
	let result += eval(join(map(list, "s:_split_keystring(v:val, pats, index+1)"), "+"))
	return result
endfunction




let s:special_keys = [
\	"\<BS>",
\	"\<Down>",
\	"\<Up>",
\	"\<Left>",
\	"\<Right>",
\	"\<Home>",
\	"\<End>",
\	"\<Insert>",
\	"\<Delete>",
\	"\<PageUp>",
\	"\<PageDown>",
\	"\<F1>",
\	"\<F2>",
\	"\<F3>",
\	"\<F4>",
\	"\<F5>",
\	"\<F6>",
\	"\<F7>",
\	"\<F8>",
\	"\<F9>",
\	"\<F10>",
\	"\<F11>",
\	"\<F12>",
\	"\<A-BS>",
\	"\<A-Down>",
\	"\<A-Up>",
\	"\<A-Left>",
\	"\<A-Right>",
\	"\<A-Home>",
\	"\<A-End>",
\	"\<A-Insert>",
\	"\<A-Delete>",
\	"\<A-PageUp>",
\	"\<A-PageDown>",
\	"\<A-F1>",
\	"\<A-F2>",
\	"\<A-F3>",
\	"\<A-F4>",
\	"\<A-F5>",
\	"\<A-F6>",
\	"\<A-F7>",
\	"\<A-F8>",
\	"\<A-F9>",
\	"\<A-F10>",
\	"\<A-F11>",
\	"\<A-F12>",
\	"\<A-Tab>",
\	"\<C-BS>",
\	"\<C-Down>",
\	"\<C-Up>",
\	"\<C-Left>",
\	"\<C-Right>",
\	"\<C-Home>",
\	"\<C-End>",
\	"\<C-Insert>",
\	"\<C-Delete>",
\	"\<C-PageUp>",
\	"\<C-PageDown>",
\	"\<C-Tab>",
\	"\<C-F1>",
\	"\<C-F2>",
\	"\<C-F3>",
\	"\<C-F4>",
\	"\<C-F5>",
\	"\<C-F6>",
\	"\<C-F7>",
\	"\<C-F8>",
\	"\<C-F9>",
\	"\<C-F10>",
\	"\<C-F11>",
\	"\<C-F12>",
\	"\<S-Down>",
\	"\<S-Up>",
\	"\<S-Left>",
\	"\<S-Right>",
\	"\<S-Home>",
\	"\<S-Insert>",
\	"\<S-PageUp>",
\	"\<S-PageDown>",
\	"\<S-F1>",
\	"\<S-F2>",
\	"\<S-F3>",
\	"\<S-F4>",
\	"\<S-F5>",
\	"\<S-F6>",
\	"\<S-F7>",
\	"\<S-F8>",
\	"\<S-F9>",
\	"\<S-F10>",
\	"\<S-F11>",
\	"\<S-F12>",
\	"\<S-Tab>",
\]
" Issues #45
" \	"\<S-End>",
" \	"\<S-Delete>",

function! s:_split_keys(str)
	return s:_split_keystring(a:str, s:special_keys)
endfunction



let &cpo = s:save_cpo
unlet s:save_cpo
