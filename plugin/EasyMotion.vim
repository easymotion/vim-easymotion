" EasyMotion - Vim motions on speed!
"
" Author: Kim Silkebækken <kim.silkebaekken+vim@gmail.com>
" Source repository: https://github.com/Lokaltog/vim-easymotion

" Prevent double loading {{{
	if exists('g:EasyMotion_loaded')
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
	function! s:InitHL(group, gui, cterm256, cterm) " {{{
		if ! hlexists(a:group)
			let guihl = printf('guibg=%s guifg=#%s gui=%s', a:gui[0], a:gui[1], a:gui[2])
			let ctermhl = &t_Co == 256
				\ ? printf('ctermbg=%s ctermfg=%s cterm=%s', a:cterm256[0], a:cterm256[1], a:cterm256[2])
				\ : printf('ctermbg=%s ctermfg=%s cterm=%s', a:cterm[0], a:cterm[1], a:cterm[2])

			execute printf('hi %s %s %s', a:group, guihl, ctermhl)
		endif
	endfunction " }}}

	call s:InitOption('keys', 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
	call s:InitOption('target_hl', 'EasyMotionTarget')
	call s:InitOption('shade_hl', 'EasyMotionShade')
	call s:InitOption('do_shade', 1)
	call s:InitOption('do_mapping', 1)

	call s:InitHL(g:EasyMotion_target_hl, ['none', 'ff0000', 'bold'], ['none', '196', 'bold'], ['none', 'red', 'bold'])
	call s:InitHL(g:EasyMotion_shade_hl, ['none', '585858', 'none'], ['none', '240', 'none'], ['none', 'darkgrey', 'none'])
" }}}
" Default key mapping {{{
	if g:EasyMotion_do_mapping
		nnoremap <silent> <Leader>f      :call EasyMotionF(0, 0)<CR>
		vnoremap <silent> <Leader>f :<C-U>call EasyMotionF(1, 0)<CR>

		nnoremap <silent> <Leader>F      :call EasyMotionF(0, 1)<CR>
		vnoremap <silent> <Leader>F :<C-U>call EasyMotionF(1, 1)<CR>

		nnoremap <silent> <Leader>t      :call EasyMotionT(0, 0)<CR>
		vnoremap <silent> <Leader>t :<C-U>call EasyMotionT(1, 0)<CR>

		nnoremap <silent> <Leader>T      :call EasyMotionT(0, 1)<CR>
		vnoremap <silent> <Leader>T :<C-U>call EasyMotionT(1, 1)<CR>

		nnoremap <silent> <Leader>w      :call EasyMotionW(0)<CR>
		vnoremap <silent> <Leader>w :<C-U>call EasyMotionW(1)<CR>

		nnoremap <silent> <Leader>e      :call EasyMotionE(0)<CR>
		vnoremap <silent> <Leader>e :<C-U>call EasyMotionE(1)<CR>

		nnoremap <silent> <Leader>b      :call EasyMotionB(0)<CR>
		vnoremap <silent> <Leader>b :<C-U>call EasyMotionB(1)<CR>
	endif
" }}}
" Initialize variables {{{
	let s:index_to_key = split(g:EasyMotion_keys, '\zs')
	let s:key_to_index = {}

	let index = 0
	for i in s:index_to_key
	    let s:key_to_index[i] = index
	    let index += 1
	endfor

	let s:var_reset = {}
" }}}
" Motion functions {{{
	function! EasyMotionF(visualmode, direction) " {{{
		let char = s:GetSearchChar(a:visualmode)

		if empty(char)
			return
		endif

		let re = '\C' . escape(char, '.$^~')

		call s:EasyMotion(re, a:direction, a:visualmode ? visualmode() : '')
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

		call s:EasyMotion(re, a:direction, a:visualmode ? visualmode() : '')
	endfunction " }}}
	function! EasyMotionW(visualmode) " {{{
		call s:EasyMotion('\<.', 0, a:visualmode ? visualmode() : '')
	endfunction " }}}
	function! EasyMotionE(visualmode) " {{{
		call s:EasyMotion('.\>', 0, a:visualmode ? visualmode() : '')
	endfunction " }}}
	function! EasyMotionB(visualmode) " {{{
		call s:EasyMotion('\<.', 1, a:visualmode ? visualmode() : '')
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
		for [line_num, line] in a:lines
			try
				" Try to join changes with previous undo block
				undojoin
			catch
			endtry

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
	function! s:GetSearchChar(visualmode)
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
	endfunction
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

					" Substitute marker character
					let lines[line_num]['marker'] = substitute(lines[line_num]['marker'], '\%' . col_num . 'c.', s:index_to_key[single_group ? element : current_group], '')

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
			call matchdelete(target_hl_id)

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
	function! s:EasyMotion(regexp, direction, visualmode) " {{{
		let orig_pos = [line('.'), col('.')]
		let targets = []

		try
			" Reset properties
			call s:VarReset('&scrolloff', 0)
			call s:VarReset('&modified', 0)
			call s:VarReset('&modifiable', 1)
			call s:VarReset('&readonly', 0)

			" Find motion targets
			while 1
				let search_direction = (a:direction == 1 ? 'b' : '')
				let search_stopline = line(a:direction == 1 ? 'w0' : 'w$')

				let pos = searchpos(a:regexp, search_direction, search_stopline)

				" Reached end of search range
				if pos == [0, 0]
					break
				endif

				" Skip folded lines
				if foldclosed(pos[0]) != -1
					if a:direction == 1
						normal! k$
					else
						normal! j^
					endif

					continue
				endif

				call add(targets, pos)
			endwhile

			let targets_len = len(targets)
			let groups_len = len(s:index_to_key)

			if targets_len == 0
				throw 'No matches'
			endif

			" Restore cursor position
			call setpos('.', [0, orig_pos[0], orig_pos[1]])

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
				call setpos('.', [0, orig_pos[0], orig_pos[1]])

				exec 'normal! ' . a:visualmode
			endif

			" Update cursor position
			call setpos('.', [0, coords[0], coords[1]])

			call s:Message('Jumping to [' . coords[0] . ', ' . coords[1] . ']')
		catch
			redraw

			" Show exception message
			call s:Message(v:exception)

			" Restore cursor position/selection
			if ! empty(a:visualmode)
				silent exec 'normal! gv'
			else
				call setpos('.', [0, orig_pos[0], orig_pos[1]])
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
