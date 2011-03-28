" EasyMotion - Vim motions on speed!
"
" Author: Kim Silkebækken <kim.silkebaekken+github@gmail.com>
" Source: https://github.com/Lokaltog/EasyMotion

" Prevent double loading {{{
	if exists('g:EasyMotion_loaded')
		finish
	endif

	let g:EasyMotion_loaded = 1
" }}}
" Default configuration {{{
	if ! exists('g:EasyMotion_keys') " {{{
		let g:EasyMotion_keys  = ''
		let g:EasyMotion_keys .= 'abcdefghijklmnopqrstuvwxyz'
		let g:EasyMotion_keys .= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	endif " }}}
	if ! exists('g:EasyMotion_target_hl') " {{{
		let g:EasyMotion_target_hl = 'EasyMotionTarget'
	endif " }}}
	if ! exists('g:EasyMotion_shade_hl') " {{{
		let g:EasyMotion_shade_hl = 'EasyMotionShade'
	endif " }}}
	if ! exists('g:EasyMotion_do_shade') " {{{
		let g:EasyMotion_shade = 1
	endif " }}}
	if ! exists('g:EasyMotion_do_mapping') " {{{
		let g:EasyMotion_do_mapping = 1
	endif " }}}
	" Create default highlighting {{{
		if ! hlexists(g:EasyMotion_target_hl) " {{{
			let hl = 'guibg=none guifg=#ff0000 gui=bold '

			if &t_Co == 256
				let hl .= 'ctermbg=none ctermfg=196 cterm=bold '
			else
				let hl .= 'ctermbg=none ctermfg=red cterm=bold '
			endif

			execute 'hi ' . g:EasyMotion_target_hl . ' ' . hl
		endif " }}}
		if ! hlexists(g:EasyMotion_shade_hl) " {{{
			let hl = 'guibg=none guifg=#585858 gui=none '

			if &t_Co == 256
				let hl .= 'ctermbg=none ctermfg=240 cterm=none '
			else
				let hl .= 'ctermbg=none ctermfg=darkgrey cterm=none '
			endif

			execute 'hi ' . g:EasyMotion_shade_hl . ' ' . hl
		endif " }}}
	" }}}
" }}}
" Default key mapping {{{
	if g:EasyMotion_do_mapping
		nnoremap <silent> <Leader>f      :call EasyMotionF(0, 0)<CR>
		vnoremap <silent> <Leader>f :<C-U>call EasyMotionF(0, 1)<CR>

		nnoremap <silent> <Leader>F      :call EasyMotionF(1, 0)<CR>
		vnoremap <silent> <Leader>F :<C-U>call EasyMotionF(1, 1)<CR>

		nnoremap <silent> <Leader>t      :call EasyMotionT(0, 0)<CR>
		vnoremap <silent> <Leader>t :<C-U>call EasyMotionT(0, 1)<CR>

		nnoremap <silent> <Leader>T      :call EasyMotionT(1, 0)<CR>
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
	" F key motions {{{
		" Go to {char} to the right or the left
		function! EasyMotionF(direction, visualmode)
			call <SID>Prompt('Search for character')

			let char = getchar()

			let re = '\C' . escape(nr2char(char), '.$^~')

			call <SID>EasyMotion(re, a:direction, a:visualmode ? visualmode() : '')
		endfunction
	" }}}
	" T key motions {{{
		" Go to {char} to the right (before) or the left (after)
		function! EasyMotionT(direction, visualmode)
			call <SID>Prompt('Search for character')

			let char = getchar()

			if a:direction == 1
				let re = '\C' . escape(nr2char(char), '.$^~') . '\zs.'
			else
				let re = '\C.' . escape(nr2char(char), '.$^~')
			endif

			call <SID>EasyMotion(re, a:direction, a:visualmode ? visualmode() : '')
		endfunction
	" }}}
	" W key motions {{{
		" Beginning of word forward
		function! EasyMotionW(visualmode)
			call <SID>EasyMotion('\<.', 0, a:visualmode ? visualmode() : '')
		endfunction
	" }}}
	" E key motions {{{
		" End of word forward
		function! EasyMotionE(visualmode)
			call <SID>EasyMotion('.\>', 0, a:visualmode ? visualmode() : '')
		endfunction
	" }}}
	" B key motions {{{
		" Beginning of word backward
		function! EasyMotionB(visualmode)
			call <SID>EasyMotion('\<.', 1, a:visualmode ? visualmode() : '')
		endfunction
	" }}}
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
		if a:0 == 0 && has_key(s:var_reset, a:var)
			" Reset var to original value
			call setbufvar(bufname(0), a:var, s:var_reset[a:var])
		elseif a:0 == 1
			let new_value = a:0 == 1 ? a:1 : ''

			" Store original value
			let s:var_reset[a:var] = getbufvar(bufname(0), a:var)

			" Set new var value
			call setbufvar(bufname(0), a:var, new_value)
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

		" Set lines with markers
		call <SID>SetLines(lines_items, 'marker')

		redraw

		" Get target/group character
		if single_group
			call <SID>Prompt('Target character')
		else
			call <SID>Prompt('Group character')
		endif

		let input_char = nr2char(getchar())

		redraw

		" Restore original lines
		call <SID>SetLines(lines_items, 'orig')

		" Un-highlight code
		call matchdelete(target_hl_id)

		redraw

		" Check if the input char is valid
		if ! has_key(s:key_to_index, input_char) || s:key_to_index[input_char] >= targets_len
			throw 'Cancelled'
		endif

		if single_group
			" Return target coordinates
			return a:groups[0][s:key_to_index[input_char]]
		else
			" Prompt for target character
			return s:PromptUser([a:groups[s:key_to_index[input_char]]])
		endif
	endfunction "}}}
	function! s:EasyMotion(regexp, direction, visualmode) " {{{
		let orig_pos = [line('.'), col('.')]
		let targets = []

		try
			" Reset properties
			call <SID>VarReset('&scrolloff', 0)
			call <SID>VarReset('&modified', 0)
			call <SID>VarReset('&modifiable', 1)
			call <SID>VarReset('&readonly', 0)

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
					call <SID>Message('Only displaying the first matches')

					let groups = groups[0 : groups_len - 1]
				endif
			" }}}

			" Shade inactive source
			if g:EasyMotion_shade
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
			let coords = <SID>PromptUser(groups)

			if ! empty(a:visualmode)
				" Store original marks
				let m_a = getpos("'a")
				let m_b = getpos("'b")

				" Store start/end positions
				call setpos("'a", [0, orig_pos[0], orig_pos[1]])
				call setpos("'b", [0, coords[0], coords[1]])

				" Update selection
				silent exec 'normal! `a' . a:visualmode . '`b'

				" Restore original marks
				call setpos("'a", m_a)
				call setpos("'b", m_b)
			else
				" Update cursor position
				call setpos('.', [0, coords[0], coords[1]])
			endif

			call <SID>Message('Jumping to [' . coords[0] . ', ' . coords[1] . ']')
		catch /.*/
			redraw

			" Show exception message
			call <SID>Message(v:exception)

			" Restore cursor position/selection
			if ! empty(a:visualmode)
				silent exec 'normal! `<' . a:visualmode . '`>'
			else
				call setpos('.', [0, orig_pos[0], orig_pos[1]])
			endif
		finally
			redraw

			" Remove shading
			if g:EasyMotion_shade
				call matchdelete(shade_hl_id)
			endif

			" Restore properties
			call <SID>VarReset('&scrolloff')
			call <SID>VarReset('&modified')
			call <SID>VarReset('&modifiable')
			call <SID>VarReset('&readonly')
		endtry
	endfunction " }}}
" }}}
