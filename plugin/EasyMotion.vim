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
		let group_default = a:group . 'Default'

		" Prepare highlighting variables
		let guihl = printf('guibg=%s guifg=%s gui=%s', a:colors.gui[0], a:colors.gui[1], a:colors.gui[2])
		let ctermhl = &t_Co == 256
			\ ? printf('ctermbg=%s ctermfg=%s cterm=%s', a:colors.cterm256[0], a:colors.cterm256[1], a:colors.cterm256[2])
			\ : printf('ctermbg=%s ctermfg=%s cterm=%s', a:colors.cterm[0], a:colors.cterm[1], a:colors.cterm[2])

		" Create default highlighting group
		execute printf('hi default %s %s %s', group_default, guihl, ctermhl)

		" Check if the hl group exists
		if hlexists(a:group)
			redir => hlstatus | exec 'silent hi ' . a:group | redir END

			" Return if the group isn't cleared
			if hlstatus !~ 'cleared'
				return
			endif
		endif

		" No colors are defined for this group, link to defaults
		execute printf('hi default link %s %s', a:group, group_default)
	endfunction " }}}
	function! s:InitMappings(motions) "{{{
		for motion in keys(a:motions)
			call s:InitOptions({ 'mapping_' . motion : g:EasyMotion_leader_key . motion })
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
		\   'leader_key' : '<Leader>'
		\ , 'keys'       : 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
		\ , 'do_shade'   : 1
		\ , 'do_mapping' : 1
		\ , 'grouping'   : 1
		\ })
	" }}}
	" Default highlighting {{{
		let s:hl_group_target = 'EasyMotionTarget'
		let s:hl_group_shade  = 'EasyMotionShade'

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

		call s:InitHL(s:hl_group_target, s:target_hl_defaults)
		call s:InitHL(s:hl_group_shade,  s:shade_hl_defaults)

		" Reset highlighting after loading a new color scheme {{{
			augroup EasyMotionInitHL
				autocmd!

				autocmd ColorScheme * call s:InitHL(s:hl_group_target, s:target_hl_defaults)
				autocmd ColorScheme * call s:InitHL(s:hl_group_shade,  s:shade_hl_defaults)
			augroup end
		" }}}
	" }}}
	" Default key mapping {{{
		call s:InitMappings({
		\   'f' : { 'name': 'F'  , 'dir': 0 }
		\ , 'F' : { 'name': 'F'  , 'dir': 1 }
		\ , 't' : { 'name': 'T'  , 'dir': 0 }
		\ , 'T' : { 'name': 'T'  , 'dir': 1 }
		\ , 'w' : { 'name': 'WB' , 'dir': 0 }
		\ , 'W' : { 'name': 'WBW', 'dir': 0 }
		\ , 'b' : { 'name': 'WB' , 'dir': 1 }
		\ , 'B' : { 'name': 'WBW', 'dir': 1 }
		\ , 'e' : { 'name': 'E'  , 'dir': 0 }
		\ , 'E' : { 'name': 'EW' , 'dir': 0 }
		\ , 'ge': { 'name': 'E'  , 'dir': 1 }
		\ , 'gE': { 'name': 'EW' , 'dir': 1 }
		\ , 'j' : { 'name': 'JK' , 'dir': 0 }
		\ , 'k' : { 'name': 'JK' , 'dir': 1 }
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
		call s:EasyMotion('\(\<.\|^$\)', a:direction, a:visualmode ? visualmode() : '', '')
	endfunction " }}}
	function! EasyMotionWBW(visualmode, direction) " {{{
		call s:EasyMotion('\(\(^\|\s\)\@<=\S\|^$\)', a:direction, a:visualmode ? visualmode() : '', '')
	endfunction " }}}
	function! EasyMotionE(visualmode, direction) " {{{
		call s:EasyMotion('\(.\>\|^$\)', a:direction, a:visualmode ? visualmode() : '', mode(1))
	endfunction " }}}
	function! EasyMotionEW(visualmode, direction) " {{{
		call s:EasyMotion('\(\S\(\s\|$\)\|^$\)', a:direction, a:visualmode ? visualmode() : '', mode(1))
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
" Grouping algorithms {{{
	let s:grouping_algorithms = {
	\   1: 'SCTree'
	\ , 2: 'Original'
	\ }
	" Single-key/closest target priority tree {{{
		" This algorithm tries to assign one-key jumps to all the targets closest to the cursor.
		" It works recursively and will work correctly with as few keys as two.
		function! s:GroupingAlgorithmSCTree(targets, keys)
			" Prepare variables for working
			let targets_len = len(a:targets)
			let keys_len = len(a:keys)

			let groups = {}

			let keys = reverse(copy(a:keys))

			" Semi-recursively count targets {{{
				" We need to know exactly how many child nodes (targets) this branch will have
				" in order to pass the correct amount of targets to the recursive function.

				" Prepare sorted target count list {{{
					" This is horrible, I know. But dicts aren't sorted in vim, so we need to
					" work around that. That is done by having one sorted list with key counts,
					" and a dict which connects the key with the keys_count list.

					let keys_count = []
					let keys_count_keys = {}

					let i = 0
					for key in keys
						call add(keys_count, 0)

						let keys_count_keys[key] = i

						let i += 1
					endfor
				" }}}

				let targets_left = targets_len
				let level = 0
				let i = 0

				while targets_left > 0
					" Calculate the amount of child nodes based on the current level
					let childs_len = (level == 0 ? 1 : (keys_len - 1) )

					for key in keys
						" Add child node count to the keys_count array
						let keys_count[keys_count_keys[key]] += childs_len

						" Subtract the child node count
						let targets_left -= childs_len

						if targets_left <= 0
							" Subtract the targets left if we added too many too
							" many child nodes to the key count
							let keys_count[keys_count_keys[key]] += targets_left

							break
						endif

						let i += 1
					endfor

					let level += 1
				endwhile
			" }}}
			" Create group tree {{{
				let i = 0
				let key = 0

				call reverse(keys_count)

				for key_count in keys_count
					if key_count > 1
						" We need to create a subgroup
						" Recurse one level deeper
						let groups[a:keys[key]] = s:GroupingAlgorithmSCTree(a:targets[i : i + key_count - 1], a:keys)
					elseif key_count == 1
						" Assign single target key
						let groups[a:keys[key]] = a:targets[i]
					else
						" No target
						continue
					endif

					let key += 1
					let i += key_count
				endfor
			" }}}

			" Finally!
			return groups
		endfunction
	" }}}
	" Original {{{
		function! s:GroupingAlgorithmOriginal(targets, keys)
			" Split targets into groups (1 level)
			let targets_len = len(a:targets)
			let keys_len = len(a:keys)

			let groups = {}

			let i = 0
			let root_group = 0
			try
				while root_group < targets_len
					let groups[a:keys[root_group]] = {}

					for key in a:keys
						let groups[a:keys[root_group]][key] = a:targets[i]

						let i += 1
					endfor

					let root_group += 1
				endwhile
			catch | endtry

			" Flatten the group array
			if len(groups) == 1
				let groups = groups[a:keys[0]]
			endif

			return groups
		endfunction
	" }}}
	" Coord/key dictionary creation {{{
		function! s:CreateCoordKeyDict(groups, ...)
			" Dict structure:
			" 1,2 : a
			" 2,3 : b
			let coord_keys = {}
			let group_key = a:0 == 1 ? a:1 : ''

			for [key, item] in items(a:groups)
				let key = ( ! empty(group_key) ? group_key : key)

				if type(item) == 3
					" Destination coords
					let coord_keys[join(item, ',')] = key
				else
					" Item is a dict (has children)
					call extend(coord_keys, s:CreateCoordKeyDict(item, key))
				endif

				unlet item
			endfor

			return coord_keys
		endfunction
	" }}}
" }}}
" Core functions {{{
	function! s:PromptUser(groups) "{{{
		" If only one possible match, jump directly to it {{{
			let group_values = values(a:groups)

			if len(group_values) == 1
				redraw

				return group_values[0]
			endif
		" }}}
		" Prepare marker lines {{{
			let lines = {}
			let hl_coords = []

			for [coords, target_key] in items(s:CreateCoordKeyDict(a:groups))
				let [line_num, col_num] = split(coords, ',')

				" Add original line and marker line
				if ! has_key(lines, line_num)
					let current_line = getline(line_num)

					let lines[line_num] = { 'orig': current_line, 'marker': current_line }
				endif

				if strlen(lines[line_num]['marker']) > 0
					" Replace hard tab with spaces
					if match(lines[line_num]['marker'], '\%' . col_num . 'c\t') != -1
						let target_key .= repeat(' ', string(&tabstop) - strlen(target_key))
					endif

					" Substitute marker character if line length > 0
					let lines[line_num]['marker'] = substitute(lines[line_num]['marker'], '\%' . col_num . 'c.', target_key, '')
				else
					" Set the line to the marker character if the line is empty
					let lines[line_num]['marker'] = target_key
				endif

				" Add highlighting coordinates
				call add(hl_coords, '\%' . line_num . 'l\%' . col_num . 'c')
			endfor

			let lines_items = items(lines)
		" }}}
		" Highlight targets {{{
			let target_hl_id = matchadd(s:hl_group_target, join(hl_coords, '\|'), 1)
		" }}}

		try
			" Set lines with markers
			call s:SetLines(lines_items, 'marker')

			redraw

			" Get target character {{{
				call s:Prompt('Target key')

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
			if ! has_key(a:groups, char)
				throw 'Invalid target'
			endif
		" }}}

		let target = a:groups[char]

		if type(target) == 3
			" Return target coordinates
			return target
		else
			" Prompt for new target character
			return s:PromptUser(target)
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

			let GroupingFn = function('s:GroupingAlgorithm' . s:grouping_algorithms[g:EasyMotion_grouping])
			let groups = GroupingFn(targets, split(g:EasyMotion_keys, '\zs'))

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

					let shade_hl_id = matchadd(s:hl_group_shade, shade_hl_re, 0)
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
