scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


function! s:_clamp(x, max, min)
	return min([max([a:x, a:max]), a:min])
endfunction


let s:base = {}
	
function! s:base.set(item)
	return type(a:item) == type("") ? self.set_str(a:item)
\			 : type(a:item) == type(0)  ? self.set_pos(a:item)
\			 : self
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

function! s:base.pos_word()
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


let &cpo = s:save_cpo
unlet s:save_cpo
