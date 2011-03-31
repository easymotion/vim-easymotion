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
	function! s:InitOption(option, default) " {{{
		if ! exists('g:EasyMotion_' . a:option)
			exec 'let g:EasyMotion_' . a:option . ' = ' . string(a:default)
		endif
	endfunction " }}}
	function! s:InitHL(group, colors) " {{{
		let guihl = printf('guibg=%s guifg=%s gui=%s', a:colors.gui[0], a:colors.gui[1], a:colors.gui[2])
		let ctermhl = &t_Co == 256
			\ ? printf('ctermbg=%s ctermfg=%s cterm=%s', a:colors.cterm256[0], a:colors.cterm256[1], a:colors.cterm256[2])
			\ : printf('ctermbg=%s ctermfg=%s cterm=%s', a:colors.cterm[0], a:colors.cterm[1], a:colors.cterm[2])

		execute printf('hi default %s %s %s', a:group, guihl, ctermhl)
	endfunction " }}}

	call s:InitOption('keys', 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
	call s:InitOption('target_hl', 'EasyMotionTarget')
	call s:InitOption('shade_hl', 'EasyMotionShade')
	call s:InitOption('do_shade', 1)
	call s:InitOption('do_mapping', 1)

	" Init highlighting {{{
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
" }}}
" Default key mapping {{{
	if g:EasyMotion_do_mapping
		nnoremap <silent> <Leader>f       :call EasyMotionF(0, 0)<CR>
		onoremap <silent> <Leader>f       :call EasyMotionF(0, 0)<CR>
		vnoremap <silent> <Leader>f  :<C-U>call EasyMotionF(1, 0)<CR>

		nnoremap <silent> <Leader>F       :call EasyMotionF(0, 1)<CR>
		onoremap <silent> <Leader>F       :call EasyMotionF(0, 1)<CR>
		vnoremap <silent> <Leader>F  :<C-U>call EasyMotionF(1, 1)<CR>

		nnoremap <silent> <Leader>t       :call EasyMotionT(0, 0)<CR>
		onoremap <silent> <Leader>t       :call EasyMotionT(0, 0)<CR>
		vnoremap <silent> <Leader>t  :<C-U>call EasyMotionT(1, 0)<CR>

		nnoremap <silent> <Leader>T       :call EasyMotionT(0, 1)<CR>
		onoremap <silent> <Leader>T       :call EasyMotionT(0, 1)<CR>
		vnoremap <silent> <Leader>T  :<C-U>call EasyMotionT(1, 1)<CR>

		nnoremap <silent> <Leader>w       :call EasyMotionWB(0, 0)<CR>
		onoremap <silent> <Leader>w       :call EasyMotionWB(0, 0)<CR>
		vnoremap <silent> <Leader>w  :<C-U>call EasyMotionWB(1, 0)<CR>

		nnoremap <silent> <Leader>b       :call EasyMotionWB(0, 1)<CR>
		onoremap <silent> <Leader>b       :call EasyMotionWB(0, 1)<CR>
		vnoremap <silent> <Leader>b  :<C-U>call EasyMotionWB(1, 1)<CR>

		nnoremap <silent> <Leader>e       :call EasyMotionE(0, 0)<CR>
		onoremap <silent> <Leader>e       :call EasyMotionE(0, 0)<CR>
		vnoremap <silent> <Leader>e  :<C-U>call EasyMotionE(1, 0)<CR>

		nnoremap <silent> <Leader>ge      :call EasyMotionE(0, 1)<CR>
		onoremap <silent> <Leader>ge      :call EasyMotionE(0, 1)<CR>
		vnoremap <silent> <Leader>ge :<C-U>call EasyMotionE(1, 1)<CR>

		nnoremap <silent> <Leader>j       :call EasyMotionJK(0, 0)<CR>
		onoremap <silent> <Leader>j       :call EasyMotionJK(0, 0)<CR>
		vnoremap <silent> <Leader>j  :<C-U>call EasyMotionJK(1, 0)<CR>

		nnoremap <silent> <Leader>k       :call EasyMotionJK(0, 1)<CR>
		onoremap <silent> <Leader>k       :call EasyMotionJK(0, 1)<CR>
		vnoremap <silent> <Leader>k  :<C-U>call EasyMotionJK(1, 1)<CR>
	endif
" }}}
" Initialize variables {{{
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
		call s:EasyMotion('.\>', a:direction, a:visualmode ? visualmode() : '', '')
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
	function! s:PromptUser(groups) "{{{
		let single_group = len(a:groups) == 1
		let targets_len = single_group ? len(a:groups[0]) : len(a:groups)

		" Only one possible match {{{
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

		" Highlight source
		let target_hl_id = matchadd(g:EasyMotion_target_hl, join(hl_coords, '\|'), 1)

		try
			" Set lines with markers
			call s:SetLines(lines_items, 'marker')

			redraw

			" Get target/group character
			if single_group
				call s:Prompt('Target character')
			else
				call s:Prompt('Group character')
			endif

			let char = s:GetChar()
		finally
			" Restore original lines
			call s:SetLines(lines_items, 'orig')

			" Un-highlight code
			if exists('target_hl_id')
				call matchdelete(target_hl_id)
			endif

			redraw
		endtry

		" Check that we have an input char
		if empty(char)
			throw 'Cancelled'
		endif

		" Check if the input char is valid
		if ! has_key(s:key_to_index, char) || s:key_to_index[char] >= targets_len
			throw 'Invalid target'
		endif

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
			" Reset properties
			call s:VarReset('&scrolloff', 0)
			call s:VarReset('&modified', 0)
			call s:VarReset('&modifiable', 1)
			call s:VarReset('&readonly', 0)

			" Find motion targets
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

			let groups_len = len(s:index_to_key)

			" Split targets into key groups {{{
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

			" Shade inactive source
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

			" Prompt user for target group/character
			let coords = s:PromptUser(groups)

			if ! empty(a:visualmode)
				" Update selection
				call cursor(orig_pos[0], orig_pos[1])

				exec 'normal! ' . a:visualmode
			endif

			if a:mode == 'no'
				" Operator-pending mode
				"
				" This mode requires that we eat one more
				" character to the right if we're using
				" a forward motion
				if a:direction != 1
					let coords[1] += 1
				endif
			endif

			" Update cursor position
			call cursor(coords[0], coords[1])

			call s:Message('Jumping to [' . coords[0] . ', ' . coords[1] . ']')
		catch
			redraw

			" Show exception message
			call s:Message(v:exception)

			" Restore cursor position/selection
			if ! empty(a:visualmode)
				silent exec 'normal! gv'
			else
				call cursor(orig_pos[0], orig_pos[1])
			endif
		finally
			" Restore properties
			call s:VarReset('&scrolloff')
			call s:VarReset('&modified')
			call s:VarReset('&modifiable')
			call s:VarReset('&readonly')

			" Remove shading
			if g:EasyMotion_do_shade && exists('shade_hl_id')
				call matchdelete(shade_hl_id)
			endif
		endtry
	endfunction " }}}
" }}}
