" EasyMotion - vim motions on speed
"
" Author: Kim Silkebækken <kim.silkebaekken+github@gmail.com>
" Source: https://github.com/Lokaltog/EasyMotion
" Version: 1.0
" Modified: 2011-03-28
"
" Heavily modified version of Bartlomiej Podolak's PreciseJump script:
" http://www.vim.org/scripts/script.php?script_id=3437
"
" This script addresses some issues with the original PreciseJump
" script. It only works in normal mode (for now), and it works correctly
" with the following motions: f F t T w e b
"
" Default key mapping:
" - <Leader> f {char}
" - <Leader> F {char}
" - <Leader> t {char}
" - <Leader> T {char}
" - <Leader> w
" - <Leader> e
" - <Leader> b
"
" Disable default mapping by setting g:EasyMotion_do_mapping = 0

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
			execute 'hi ' . g:EasyMotion_target_hl . ' ctermfg=red ctermbg=none cterm=bold gui=bold guibg=Red guifg=yellow'
		endif " }}}
		if ! hlexists(g:EasyMotion_shade_hl) " {{{
			execute 'hi ' . g:EasyMotion_shade_hl . ' ctermfg=black ctermbg=none cterm=bold gui=bold guibg=none guifg=black'
		endif " }}}
	" }}}
" }}}
" Default key mapping {{{
	if g:EasyMotion_do_mapping
		nnoremap <silent> <Leader>f :call EasyMotionF(0)<CR>
		nnoremap <silent> <Leader>F :call EasyMotionF(1)<CR>

		nnoremap <silent> <Leader>t :call EasyMotionT(0)<CR>
		nnoremap <silent> <Leader>T :call EasyMotionT(1)<CR>

		nnoremap <silent> <Leader>w :call EasyMotionW()<CR>
		nnoremap <silent> <Leader>e :call EasyMotionE()<CR>
		nnoremap <silent> <Leader>b :call EasyMotionB()<CR>
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
" }}}
" Motion functions {{{
	" F key motions {{{
		" Go to {char} to the right or the left
		function! EasyMotionF(direction)
			call <SID>Prompt('Search for character')

			let char = getchar()

			let re = '\C' . escape(nr2char(char), '.$^~')

			call <SID>EasyMotion(re, a:direction)
		endfunction
	" }}}
	" T key motions {{{
		" Go to {char} to the right (before) or the left (after)
		function! EasyMotionT(direction)
			call <SID>Prompt('Search for character')

			let char = getchar()

			if a:direction == 1
				let re = '\C' . escape(nr2char(char), '.$^~') . '\zs.'
			else
				let re = '\C.' . escape(nr2char(char), '.$^~')
			endif

			call <SID>EasyMotion(re, a:direction)
		endfunction
	" }}}
	" W key motions {{{
		" Beginning of word forward
		function! EasyMotionW()
			call <SID>EasyMotion('\<.', 0)
		endfunction
	" }}}
	" E key motions {{{
		" End of word forward
		function! EasyMotionE()
			call <SID>EasyMotion('.\>', 0)
		endfunction
	" }}}
	" B key motions {{{
		" Beginning of word backward
		function! EasyMotionB()
			call <SID>EasyMotion('\<.', 1)
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
		" Get the lines that need to be changed {{{
			let lines = []
			let lines_set = {}
			for group in a:groups
				for [line, col] in group
					if ! has_key(lines_set, line)
						call add(lines, line)

						let lines_set[line] = 1
					endif
				endfor
			endfor
		" }}}
		" Create copies of the lines {{{
			let orig_lines = {}
			let marker_lines = {}

			for line_num in lines
				let orig_lines[line_num] = getline(line_num)
				let marker_lines[line_num] = split(getline(line_num), '\zs')
			endfor
		" }}}
		" Add markers to the lines and prepare highlighting {{{
			let current_group = 0
			let hl_coords = []

			for group in a:groups
				let element = 0

				for [line, col] in group
					" Create marker
					let marker_lines[line][col - 1] = s:index_to_key[single_group ? element : current_group]
					let element += 1

					" Add highlighting coordinates
					call add(hl_coords, '\%' . line . 'l\%' . col . 'c')
				endfor

				let current_group += 1
			endfor
		" }}}

		let input_char = ''

		" Store original properties {{{
			let modified = &modified
			let modifiable = &modifiable
			let readonly = &readonly
		" }}}

		try
			" Highlight source
			let target_hl_id = matchadd(g:EasyMotion_target_hl, join(hl_coords, '\|'), 1)

			" Make sure we can change the buffer {{{
				if modifiable == 0
					silent setl modifiable
				endif

				if readonly == 1
					silent setl noreadonly
				endif
			" }}}

			" Set lines with markers
			for [line_num, line_arr] in items(marker_lines)
				try
					undojoin
				catch
				endtry

				call setline(line_num, join(line_arr, ''))
			endfor

			redraw

			" Get target/group character
			if single_group
				call <SID>Prompt('Target character')
			else
				call <SID>Prompt('Group character')
			endif

			let input_char = nr2char(getchar())

			redraw
		finally
			" Restore original lines
			for [line_num, line] in items(orig_lines)
				try
					undojoin
				catch
				endtry

				call setline(line_num, line)
			endfor

			call matchdelete(target_hl_id)

			redraw

			" Restore original properties {{{
				if modified == 0
					silent setl nomodified
				endif

				if modifiable == 0
					silent setl nomodifiable
				endif

				if readonly == 1
					silent setl readonly
				endif
			" }}}

			" Check if the input char is valid
			if ! has_key(s:key_to_index, input_char) || s:key_to_index[input_char] >= targets_len
				" Invalid input char
				return []
			else
				if single_group
					" Return target coordinates
					return a:groups[0][s:key_to_index[input_char]]
				else
					" Prompt for target character
					return s:PromptUser([a:groups[s:key_to_index[input_char]]])
				endif
			endif
		endtry
	endfunction "}}}
	function! s:EasyMotion(regexp, direction) " {{{
		let orig_pos = [line('.'), col('.')]
		let targets = []

		" Find motion targets
		while 1
			let search_direction = (a:direction == 1 ? 'b' : '')
			let search_stopline = line(a:direction == 1 ? 'w0' : 'w$')

			let pos = searchpos(a:regexp, search_direction, search_stopline)

			if pos == [0, 0]
				break
			endif

			call add(targets, pos)
		endwhile

		let targets_len = len(targets)
		let groups_len = len(s:index_to_key)

		if targets_len == 0
			redraw

			call <SID>Message('No matches')

			return
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
				let shade_hl_re = '\%^\_.*' . shade_hl_pos
			else
				let shade_hl_re = shade_hl_pos . '\_.*\%$'
			endif

			let shade_hl_id = matchadd(g:EasyMotion_shade_hl, shade_hl_re, 0)
		endif

		let coords = <SID>PromptUser(groups)

		" Remove shading
		if g:EasyMotion_shade
			call matchdelete(shade_hl_id)
		endif

		if len(coords) != 2
			" Cancelled by user
			call <SID>Message('Operation cancelled')

			return
		else
			" Jump to coords
			let virtualedit = &virtualedit
			setl virtualedit=

			silent execute 'normal! ' . coords[0] . 'gg'
			silent execute 'normal! "0|"'
			silent execute 'normal! ' . (coords[1] - 1) . 'l'
			silent execute 'setl virtualedit=' . virtualedit

			call <SID>Message('Jumping to [' . coords[0] . ', ' . coords[1] . ']')
		endif
	endfunction " }}}
" }}}
