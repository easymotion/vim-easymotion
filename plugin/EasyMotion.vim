" EasyMotion - Vim motions on speed!
"
" Author: Kim Silkebækken <kim.silkebaekken+vim@gmail.com>
" Source repository: https://github.com/Lokaltog/vim-easymotion

" Script initialization {{{
	if exists('g:EasyMotion_loaded') || &compatible || version < 702
		finish
	endif

	let g:EasyMotion_loaded = 1
" }}}
" Default configuration {{{
	function! s:InitOptions(options) " {{{
		for [key, value] in items(a:options)
			if ! exists('g:EasyMotion_' . key)
				exec 'let g:EasyMotion_' . key . ' = ' . string(value)
			endif
		endfor
	endfunction " }}}
	function! s:InitHL(group, colors) " {{{
		let guihl = printf('guibg=%s guifg=%s gui=%s', a:colors.gui[0], a:colors.gui[1], a:colors.gui[2])
		let ctermhl = &t_Co == 256
			\ ? printf('ctermbg=%s ctermfg=%s cterm=%s', a:colors.cterm256[0], a:colors.cterm256[1], a:colors.cterm256[2])
			\ : printf('ctermbg=%s ctermfg=%s cterm=%s', a:colors.cterm[0], a:colors.cterm[1], a:colors.cterm[2])

		execute printf('hi default %s %s %s', a:group, guihl, ctermhl)
	endfunction " }}}
	function! s:InitMappings(motions) "{{{
		for motion in keys(a:motions)
			call s:InitOptions({ 'mapping_' . motion : '<Leader>' . motion })
		endfor

		if g:EasyMotion_do_mapping
			for [motion, fn] in items(a:motions)
				silent exec 'nnoremap <silent> ' . g:EasyMotion_mapping_{motion} . '      :call EasyMotion' . fn.name . '(0, ' . fn.dir . ')<CR>'
				silent exec 'onoremap <silent> ' . g:EasyMotion_mapping_{motion} . '      :call EasyMotion' . fn.name . '(0, ' . fn.dir . ')<CR>'
				silent exec 'vnoremap <silent> ' . g:EasyMotion_mapping_{motion} . ' :<C-U>call EasyMotion' . fn.name . '(1, ' . fn.dir . ')<CR>'
			endfor
		endif
	endfunction "}}}
	" Default options {{{
		call s:InitOptions({
		\   'keys'       : 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
		\ , 'target_hl'  : 'EasyMotionTarget'
		\ , 'shade_hl'   : 'EasyMotionShade'
		\ , 'do_shade'   : 1
		\ , 'do_mapping' : 1
		\ })
	" }}}
	" Default highlighting {{{
		let s:target_hl_defaults = {
		\   'gui'     : ['NONE', '#ff0000' , 'bold']
		\ , 'cterm256': ['NONE', '196'     , 'bold']
		\ , 'cterm'   : ['NONE', 'red'     , 'bold']
		\ }

		let s:shade_hl_defaults = {
		\   'gui'     : ['NONE', '#585858' , 'NONE']
		\ , 'cterm256': ['NONE', '240'     , 'NONE']
		\ , 'cterm'   : ['NONE', 'darkgrey', 'NONE']
		\ }

		call s:InitHL(g:EasyMotion_target_hl, s:target_hl_defaults)
		call s:InitHL(g:EasyMotion_shade_hl,  s:shade_hl_defaults)

		" Reset highlighting after loading a new color scheme {{{
			augroup EasyMotionInitHL
				autocmd!

				autocmd ColorScheme * call s:InitHL(g:EasyMotion_target_hl, s:target_hl_defaults)
				autocmd ColorScheme * call s:InitHL(g:EasyMotion_shade_hl,  s:shade_hl_defaults)
			augroup end
		" }}}
	" }}}
	" Default key mapping {{{
		call s:InitMappings({
		\   'f' : { 'name': 'F' , 'dir': 0 }
		\ , 'F' : { 'name': 'F' , 'dir': 1 }
		\ , 't' : { 'name': 'T' , 'dir': 0 }
		\ , 'T' : { 'name': 'T' , 'dir': 1 }
		\ , 'w' : { 'name': 'WB', 'dir': 0 }
		\ , 'b' : { 'name': 'WB', 'dir': 1 }
		\ , 'e' : { 'name': 'E' , 'dir': 0 }
		\ , 'ge': { 'name': 'E' , 'dir': 1 }
		\ , 'j' : { 'name': 'JK', 'dir': 0 }
		\ , 'k' : { 'name': 'JK', 'dir': 1 }
		\ })
	" }}}
" }}}
" Motion functions {{{
	function! EasyMotionF(visualmode, direction) " {{{
		let char = s:GetSearchChar(a:visualmode)

		if empty(char)
			return
		endif

		let re = '\C' . escape(char, '.$^~')

		call s:EasyMotion(re, a:direction, a:visualmode ? visualmode() : '', mode(1))
	endfunction " }}}
	function! EasyMotionT(visualmode, direction) " {{{
		let char = s:GetSearchChar(a:visualmode)

		if empty(char)
			return
		endif

		if a:direction == 1
			let re = '\C' . escape(char, '.$^~') . '\zs.'
		else
			let re = '\C.' . escape(char, '.$^~')
		endif

		call s:EasyMotion(re, a:direction, a:visualmode ? visualmode() : '', mode(1))
	endfunction " }}}
	function! EasyMotionWB(visualmode, direction) " {{{
		call s:EasyMotion('\<.', a:direction, a:visualmode ? visualmode() : '', '')
	endfunction " }}}
	function! EasyMotionE(visualmode, direction) " {{{
		call s:EasyMotion('.\>', a:direction, a:visualmode ? visualmode() : '', mode(1))
	endfunction " }}}
	function! EasyMotionJK(visualmode, direction) " {{{
		call s:EasyMotion('\%1v', a:direction, a:visualmode ? visualmode() : '', '')
	endfunction " }}}
" }}}
" Helper functions {{{
	function! s:Message(message) " {{{
		echo 'EasyMotion: ' . a:message
	endfunction " }}}
	function! s:Prompt(message) " {{{
		echohl Question
		echo a:message . ': '
		echohl None
	endfunction " }}}
	function! s:VarReset(var, ...) " {{{
		if ! exists('s:var_reset')
			let s:var_reset = {}
		endif

		let buf = bufname("")

		if a:0 == 0 && has_key(s:var_reset, a:var)
			" Reset var to original value
			call setbufvar(buf, a:var, s:var_reset[a:var])
		elseif a:0 == 1
			let new_value = a:0 == 1 ? a:1 : ''

			" Store original value
			let s:var_reset[a:var] = getbufvar(buf, a:var)

			" Set new var value
			call setbufvar(buf, a:var, new_value)
		endif
	endfunction " }}}
	function! s:SetLines(lines, key) " {{{
		try
			" Try to join changes with previous undo block
			undojoin
		catch
		endtry

		for [line_num, line] in a:lines
			call setline(line_num, line[a:key])
		endfor
	endfunction " }}}
	function! s:GetChar() " {{{
		let char = getchar()

		if char == 27
			" Escape key pressed
			redraw

			call s:Message('Cancelled')

			return ''
		endif

		return nr2char(char)
	endfunction " }}}
	function! s:GetSearchChar(visualmode) " {{{
		call s:Prompt('Search for character')

		let char = s:GetChar()

		" Check that we have an input char
		if empty(char)
			" Restore selection
			if ! empty(a:visualmode)
				silent exec 'normal! gv'
			endif

			return ''
		endif

		return char
	endfunction " }}}
" }}}
" Core functions {{{
	" Create key index {{{
		function! s:CreateIndex(chars) " {{{
			let index_to_key = {}
			let key_to_index = {}

			let idx = 0
			for char in split(a:chars, '\zs')
				let index_to_key[idx]  = char
				let key_to_index[char] = idx

				let idx += 1
			endfor

			return [index_to_key, key_to_index]
		endfunction "}}}

		let [s:index_to_key, s:key_to_index] = s:CreateIndex(g:EasyMotion_keys)
	" }}}
	function! s:PromptUser(groups) "{{{
		let single_group = len(a:groups) == 1
		let targets_len = single_group ? len(a:groups[0]) : len(a:groups)

		" If only one possible match, jump directly to it {{{
			if single_group && targets_len == 1
				redraw

				return a:groups[0][0]
			endif
		" }}}
		" Prepare marker lines {{{
			let lines = {}
			let hl_coords = []
			let current_group = 0

			for group in a:groups
				let element = 0

				for [line_num, col_num] in group
					" Add original line and marker line
					if ! has_key(lines, line_num)
						let current_line = getline(line_num)

						let lines[line_num] = { 'orig': current_line, 'marker': current_line }
					endif

					let marker_char = s:index_to_key[single_group ? element : current_group]

					if strlen(lines[line_num]['marker']) > 0
						" Replace hard tab with spaces
						if match(lines[line_num]['marker'], '\%' . col_num . 'c\t') != -1
							let marker_char .= repeat(' ', string(&tabstop) - strlen(marker_char))
						endif

						" Substitute marker character if line length > 0
						let lines[line_num]['marker'] = substitute(lines[line_num]['marker'], '\%' . col_num . 'c.', marker_char, '')
					else
						" Set the line to the marker character if the line is empty
						let lines[line_num]['marker'] = marker_char
					endif

					" Add highlighting coordinates
					call add(hl_coords, '\%' . line_num . 'l\%' . col_num . 'c')

					let element += 1
				endfor

				let current_group += 1
			endfor

			let lines_items = items(lines)
		" }}}
		" Highlight targets {{{
			let target_hl_id = matchadd(g:EasyMotion_target_hl, join(hl_coords, '\|'), 1)
		" }}}

		try
			" Set lines with markers
			call s:SetLines(lines_items, 'marker')

			redraw

			" Get target/group character {{{
				if single_group
					call s:Prompt('Target character')
				else
					call s:Prompt('Group character')
				endif

				let char = s:GetChar()
			" }}}
		finally
			" Restore original lines
			call s:SetLines(lines_items, 'orig')

			" Un-highlight targets {{{
				if exists('target_hl_id')
					call matchdelete(target_hl_id)
				endif
			" }}}

			redraw
		endtry

		" Check if we have an input char {{{
			if empty(char)
				throw 'Cancelled'
			endif
		" }}}
		" Check if the input char is valid {{{
			if ! has_key(s:key_to_index, char) || s:key_to_index[char] >= targets_len
				throw 'Invalid target'
			endif
		" }}}

		if single_group
			" Return target coordinates
			return a:groups[0][s:key_to_index[char]]
		else
			" Prompt for target character
			return s:PromptUser([a:groups[s:key_to_index[char]]])
		endif
	endfunction "}}}
	function! s:EasyMotion(regexp, direction, visualmode, mode) " {{{
		let orig_pos = [line('.'), col('.')]
		let targets = []

		try
			" Reset properties {{{
				call s:VarReset('&scrolloff', 0)
				call s:VarReset('&modified', 0)
				call s:VarReset('&modifiable', 1)
				call s:VarReset('&readonly', 0)
			" }}}
			" Find motion targets {{{
				let search_direction = (a:direction == 1 ? 'b' : '')
				let search_stopline = line(a:direction == 1 ? 'w0' : 'w$')

				while 1
					let pos = searchpos(a:regexp, search_direction, search_stopline)

					" Reached end of search range
					if pos == [0, 0]
						break
					endif

					" Skip folded lines
					if foldclosed(pos[0]) != -1
						continue
					endif

					call add(targets, pos)
				endwhile

				let targets_len = len(targets)
				if targets_len == 0
					throw 'No matches'
				endif
			" }}}
			" Split targets into key groups {{{
				let groups_len = len(s:index_to_key)
				let groups = []
				let i = 0

				while i < targets_len
					call add(groups, targets[i : i + groups_len - 1])

					let i += groups_len
				endwhile
			" }}}
			" Too many groups; only display the first ones {{{
				if len(groups) > groups_len
					call s:Message('Only displaying the first matches')

					let groups = groups[0 : groups_len - 1]
				endif
			" }}}
			" Shade inactive source {{{
				if g:EasyMotion_do_shade
					let shade_hl_pos = '\%' . orig_pos[0] . 'l\%'. orig_pos[1] .'c'

					if a:direction == 1
						" Backward
						let shade_hl_re = '\%'. line('w0') .'l\_.*' . shade_hl_pos
					else
						" Forward
						let shade_hl_re = shade_hl_pos . '\_.*\%'. line('w$') .'l'
					endif

					let shade_hl_id = matchadd(g:EasyMotion_shade_hl, shade_hl_re, 0)
				endif
			" }}}

			" Prompt user for target group/character
			let coords = s:PromptUser(groups)

			" Update selection {{{
				if ! empty(a:visualmode)
					call cursor(orig_pos[0], orig_pos[1])

					exec 'normal! ' . a:visualmode
				endif
			" }}}
			" Handle operator-pending mode {{{
				if a:mode == 'no'
					" This mode requires that we eat one more
					" character to the right if we're using
					" a forward motion
					if a:direction != 1
						let coords[1] += 1
					endif
				endif
			" }}}

			" Update cursor position
			call cursor(coords[0], coords[1])

			call s:Message('Jumping to [' . coords[0] . ', ' . coords[1] . ']')
		catch
			redraw

			" Show exception message
			call s:Message(v:exception)

			" Restore original cursor position/selection {{{
				if ! empty(a:visualmode)
					silent exec 'normal! gv'
				else
					call cursor(orig_pos[0], orig_pos[1])
				endif
			" }}}
		finally
			" Restore properties {{{
				call s:VarReset('&scrolloff')
				call s:VarReset('&modified')
				call s:VarReset('&modifiable')
				call s:VarReset('&readonly')
			" }}}
			" Remove shading {{{
				if g:EasyMotion_do_shade && exists('shade_hl_id')
					call matchdelete(shade_hl_id)
				endif
			" }}}
		endtry
	endfunction " }}}
" }}}
