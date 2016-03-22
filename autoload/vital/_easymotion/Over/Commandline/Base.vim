scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:_vital_loaded(V)
	let s:V = a:V
	let s:String  = s:V.import("Over.String")
	let s:Signals = s:V.import("Over.Signals")
	let s:Input = s:V.import("Over.Input")
	let s:Keymapping = s:V.import("Over.Keymapping")
	let s:Module = s:V.import("Over.Commandline.Modules")
	let s:base.variables.modules = s:Signals.make()
	function! s:base.variables.modules.get_slot(val)
		return a:val.slot.module
	endfunction

	let s:Highlight = s:V.import("Palette.Highlight")
endfunction


function! s:_vital_depends()
	return [
\		"Over.String",
\		"Over.Signals",
\		"Over.Input",
\		"Over.Keymapping",
\		"Over.Commandline.Modules",
\		"Palette.Highlight",
\	]
endfunction


function! s:make(...)
	let result = deepcopy(s:base)
	call result.set_prompt(get(a:, 1, ":"))
	call result.connect(result, "_")
	return result
endfunction


function! s:make_plain()
	return deepcopy(s:base)
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
\		"is_setted" : 0,
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
	if overwrite || self.variables.is_setted == 0
		let self.variables.input = a:char
		let self.variables.is_setted = 1
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
	return self.get_tap_key() ==# prekey
\		&& self.char() ==# a:key
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


function! s:base.backward_word(...)
	let pat = get(a:, 1, '\k\+\s*\|.')
	return matchstr(self.backward(), '\%(' . pat . '\)$')
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
	let key = s:Keymapping.as_key_config(a:rhs)
	let key.noremap = 1
	let self.variables.keymapping[a:lhs] = key
endfunction


function! s:base.cunmap(lhs)
	unlet self.variables.keymapping[a:lhs]
endfunction


function! s:base.keymapping()
	return self.__keymapping__()
endfunction


function! s:base.__keymapping__()
	return {}
endfunction


function! s:base.execute(...)
	let command = get(a:, 1, self.getline())
	call self.__execute(command)
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
" 	call self.__on_cancel()
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
	let exit_code = call(self.__main, a:000, self)
	return exit_code
endfunction


function! s:base.__empty(...)
endfunction


function! s:base.get(...)
	let Old_execute = self.execute
	let self.execute = self.__empty
	try
		let exit_code = call(self.start, a:000, self)
		if exit_code == 0
			return self.getline()
		endif
	finally
		let self.execute = Old_execute
	endtry
	return ""
endfunction


function! s:base.input_key_stack()
	return self.variables.input_key_stack
endfunction


function! s:base.input_key_stack_string()
	return join(self.variables.input_key_stack, "")
endfunction


function! s:base.set_input_key_stack(stack)
	let self.variables.input_key_stack = a:stack
	return self.variables.input_key_stack
endfunction


function! s:base.input_key_stack_pop()
	return remove(self.input_key_stack(), 0)
endfunction


function! s:base.getchar(...)
	if empty(self.input_key_stack())
		return call(s:Input.getchar, a:000, s:Input)
	endif
	return self.input_key_stack_pop()
endfunction


function! s:base.__init_variables()
	let self.variables.tap_key = ""
	let self.variables.char = ""
	let self.variables.input = ""
	let self.variables.exit = 0
	let self.variables.exit_code = 1
	let self.variables.enable_keymapping = 1
	let self.variables.input_key_stack = []
	let self.line = deepcopy(s:String.make())
endfunction


function! s:_is_valid_highlight(name)
	let highlight = s:Highlight.get(a:name)
	if empty(highlight)
		return 0
	endif

	if has("gui_running")
\	&& (has_key(highlight, "guifg") || has_key(highlight, "guibg"))
		return 1
	elseif (has_key(highlight, "ctermfg") || has_key(highlight, "ctermbg"))
		return 1
	endif
	return 0
endfunction


function! s:base.__init()
	call self.__init_variables()
	call self.hl_cursor_off()
	if !hlexists(self.highlights.cursor)
		if s:_is_valid_highlight("Cursor")
			execute "highlight link " . self.highlights.cursor . " Cursor"
		else
			" Workaround by CUI Vim Cursor Highlight
			" issues #92
			" https://github.com/osyo-manga/vital-over/issues/92
			execute "highlight " . self.highlights.cursor . " term=reverse cterm=reverse gui=reverse"
		endif
	endif
	if !hlexists(self.highlights.cursor_on)
		execute "highlight link " . self.highlights.cursor_on . " " . self.highlights.cursor
	endif
	if !hlexists(self.highlights.cursor_insert)
		execute "highlight " . self.highlights.cursor_insert . " cterm=underline term=underline gui=underline"
	endif
endfunction


function! s:base.__execute(command)
	call self.callevent("on_execute_pre")
	try
		call self.__execute__(a:command)
	catch
		echohl ErrorMsg
		echom matchstr(v:exception, 'Vim\((\w*)\)\?:\zs.*\ze')
		echohl None
		call self.callevent("on_execute_failed")
	finally
		call self.callevent("on_execute")
	endtry
endfunction


function! s:base.__execute__(cmd)
	execute a:cmd
endfunction


function! s:base.__input_char(char)
	let char = a:char
	let self.variables.input_key = char
	let self.variables.char = char
	call self.setchar(self.variables.char)
	let self.variables.is_setted = 0
	call self.callevent("on_char_pre")
	call self.insert(self.variables.input)
	call self.callevent("on_char")
endfunction


function! s:base.__input(input, ...)
	if a:input == ""
		return
	endif

	let self.variables.input_key = a:input
	if a:0 == 0
		let keymapping = self.__get_keymapping()
	else
		let keymapping = a:1
	endif
	if self.is_enable_keymapping()
		let key = s:Keymapping.unmapping(keymapping, a:input)
	else
		let key = a:input
	endif
	if key == ""
		return
	endif

	call self.set_input_key_stack(s:String.split_by_keys(key))
	while !(empty(self.input_key_stack()) || self.is_exit())
		call self.__input_char(self.input_key_stack_pop())
	endwhile
endfunction


function! s:is_input_waiting(keymapping, input)
	let num = len(filter(copy(a:keymapping), 'stridx(v:key, a:input) == 0'))
	return num > 1 || (num == 1 && !has_key(a:keymapping, a:input))
endfunction


function! s:base.__inputting()
	if !self.is_enable_keymapping()
		return self.__input(s:Input.getchar())
	endif

	let input = s:Input.getchar()
	let old_line = self.getline()
	let old_pos  = self.getpos()
	let keymapping = self.__get_keymapping()
	try
		let t = reltime()
		while s:is_input_waiting(keymapping, input)
\		&& str2nr(reltimestr(reltime(t))) * 1000 < &timeoutlen
			call self.setline(old_line)
			call self.insert(input)
			call self.setpos(old_pos)
			call self.draw()
			let input .= s:Input.getchar(0)
		endwhile
	finally
		call self.setline(old_line)
		call self.setpos(old_pos)
	endtry
	call self.__input(input, keymapping)
endfunction


function! s:base.__update()
" 	call self.callevent("on_update")
" 	if !getchar(1)
" 		continue
" 	endif
"
" 	call self.__input(s:getchar(0))
" 	call self.draw()

	call self.callevent("on_update")
	call self.__inputting()
" 	call self.__input(s:Input.getchar())
	if self.is_exit()
		return -1
	endif
	call self.draw()
endfunction


function! s:base.__main(...)
	try
		call self.__init()
		call self.callevent("on_enter")

		call self.__input(get(a:, 1, ""))
		call self.draw()
		while !self.is_exit()
			try
				if self.__update()
					break
				endif
			catch
				call self.callevent("on_exception")
			endtry
		endwhile
	catch
		echohl ErrorMsg | echom v:throwpoint . " " . v:exception | echohl None
		let self.variables.exit_code = -1
	finally
		call self.__finish()
		call self.callevent("on_leave")
	endtry
	return self.exit_code()
endfunction


function! s:base.__finish()
	call self.hl_cursor_on()
endfunction


function! s:base.__is_exit()
	return self.is_exit()
endfunction


function! s:base.is_exit()
	return self.variables.exit
endfunction


function! s:base.__get_keymapping()
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


let &cpo = s:save_cpo
unlet s:save_cpo
" ___Revitalizer___
" NOTE: below code is generated by :Revitalize.
" Do not mofidify the code nor append new lines
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:___revitalizer_function___(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:___revitalizer_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze____revitalizer_SID$')
  endfunction
  let s:___revitalizer_sid = '<SNR>' . s:___revitalizer_SID() . '_'
  function! s:___revitalizer_function___(fstr) abort
    return function(substitute(a:fstr, 's:', s:___revitalizer_sid, 'g'))
  endfunction
endif

let s:___revitalizer_functions___ = {'_vital_depends': s:___revitalizer_function___('s:_vital_depends'),'make_plain': s:___revitalizer_function___('s:make_plain'),'is_input_waiting': s:___revitalizer_function___('s:is_input_waiting'),'make': s:___revitalizer_function___('s:make'),'_vital_loaded': s:___revitalizer_function___('s:_vital_loaded')}

unlet! s:___revitalizer_sid
delfunction s:___revitalizer_function___

function! vital#_easymotion#Over#Commandline#Base#import() abort
  return s:___revitalizer_functions___
endfunction
" ___Revitalizer___
