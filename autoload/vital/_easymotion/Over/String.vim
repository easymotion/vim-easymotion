scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:_vital_loaded(V)
	let s:V = a:V
	let s:List = s:V.import("Data.List")
endfunction


function! s:_vital_depends()
	return [
\		"Data.List",
\	]
endfunction


function! s:_clamp(x, max, min)
	return min([max([a:x, a:max]), a:min])
endfunction


let s:base = {}

function! s:base.set(item)
	return type(a:item) == type("") ? self.set_str(a:item)
\		 : type(a:item) == type(0)  ? self.set_pos(a:item)
\		 : self
endfunction

function! s:base.str()
	return join(self.list, "")
endfunction

function! s:base.set_pos(pos)
	let self.col = s:_clamp(a:pos, 0, self.length())
	return self
endfunction

function! s:base.backward()
	return self.col > 0 ? join(self.list[ : self.col-1], '') : ""
endfunction

function! s:base.forward()
	return join(self.list[self.col+1 : ], '')
endfunction

function! s:base.pos_char()
	return get(self.list, self.col, "")
endfunction

function! s:base.set_str(str)
	let self.list = split(a:str, '\zs')
	let self.col  = strchars(a:str)
	return self
endfunction

function! s:base.pos()
	return self.col
endfunction

function! s:base.input(str)
	call extend(self.list, split(a:str, '\zs'), self.col)
	let self.col += len(split(a:str, '\zs'))
	return self
endfunction

function! s:base.length()
	return len(self.list)
endfunction

function! s:base.next()
	return self.set_pos(self.col + 1)
endfunction

function! s:base.prev()
	return self.set_pos(self.col - 1)
endfunction

function! s:base.remove(index)
	if a:index < 0 || self.length() <= a:index
		return self
	endif
	unlet self.list[a:index]
	if a:index < self.col
		call self.set(self.col - 1)
	endif
	return self
endfunction

function! s:base.remove_pos()
	return self.remove(self.col)
endfunction

function! s:base.remove_prev()
	return self.remove(self.col - 1)
endfunction

function! s:base.remove_next()
	return self.remove(self.col + 1)
endfunction


function! s:make(...)
	let default = get(a:, 1, "")
	let result = deepcopy(s:base)
	call result.set(default)
	return result
endfunction


function! s:_split(str, pat)
	let pat = (exists("+regexpengine") ? '\%#=2' : '') . a:pat
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


" Workaround
" https://github.com/osyo-manga/vital-over/pull/63
" http://lingr.com/room/vim/archives/2014/10/29#message-20492403
if exists("+regexpengine")
	function! s:_split_keystring(str, ...)
		return split(a:str, '\%#=2' . "\\m\\%(" . get(a:, 1, '') . "\x80\xfc.\\%(\x80..\\|.\\)\\zs\\|\x80..\\zs\\|.\\zs\\)")
	endfunction

	function! s:split_by_keys(str)
		return s:_split_keystring(a:str, "\\%(\<Plug>\\|<Over>\\)(.\\{-})\\zs\\|")
	endfunction
else
	function! s:split_by_keys(str)
		return s:_split_keystring(a:str, s:special_keys)
	endfunction
endif


function! s:index(haystack, needle, ...)
	let start = get(a:, 1, 0)
	let ignorecase = get(a:, 2, &ignorecase)
	if ignorecase
		return stridx(tolower(a:haystack), tolower(a:needle), start)
	else
		return stridx(a:haystack, a:needle, start)
	endif
endfunction


function! s:length(str)
	return len(s:split_by_keys(a:str))
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
