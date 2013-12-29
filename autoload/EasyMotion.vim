" EasyMotion - Vim motions on speed!
"
" Author: Kim Silkebækken <kim.silkebaekken+vim@gmail.com>
" Source repository: https://github.com/Lokaltog/vim-easymotion

" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}
" Reset {{{
function! EasyMotion#reset()
	" Reset Migemo Dictionary
	let s:migemo_dicts = {}
    return ""
endfunction "}}}
" Motion functions {{{
	" == Find Motion =========================
	function! EasyMotion#F(visualmode, direction) " {{{
		let char = s:GetSearchChar(a:visualmode)

		if empty(char)
			return
		endif

		let re = s:findMotion(char)

		call s:EasyMotion(re, a:direction, a:visualmode ? visualmode() : '', mode(1))
	endfunction " }}}
	function! EasyMotion#S(visualmode, direction) " {{{
		let char = s:GetSearchChar(a:visualmode)

		if empty(char)
			return
		endif

		let re = s:findMotion(char)

		call s:EasyMotion(re, a:direction, a:visualmode ? visualmode() : '', mode(1))
	endfunction " }}}
	function! EasyMotion#T(visualmode, direction) " {{{
		let char = s:GetSearchChar(a:visualmode)

		if empty(char)
			return
		endif

		let re = s:findMotion(char)

		if a:direction == 1
			" backward
			let re = re . '\zs.'
		else
			" forward
			let re = '.\ze' . re
		endif

		call s:EasyMotion(re, a:direction, a:visualmode ? visualmode() : '', mode(1))
	endfunction " }}}
	" == Word Motion =========================
	function! EasyMotion#WB(visualmode, direction) " {{{
		call s:EasyMotion('\(\<.\|^$\)', a:direction, a:visualmode ? visualmode() : '', '')
	endfunction " }}}
	function! EasyMotion#WBW(visualmode, direction) " {{{
		call s:EasyMotion('\(\(^\|\s\)\@<=\S\|^$\)', a:direction, a:visualmode ? visualmode() : '', '')
	endfunction " }}}
	function! EasyMotion#E(visualmode, direction) " {{{
		call s:EasyMotion('\(.\>\|^$\)', a:direction, a:visualmode ? visualmode() : '', mode(1))
	endfunction " }}}
	function! EasyMotion#EW(visualmode, direction) " {{{
		call s:EasyMotion('\(\S\(\s\|$\)\|^$\)', a:direction, a:visualmode ? visualmode() : '', mode(1))
	endfunction " }}}
	" == JK Motion ===========================
	function! EasyMotion#JK(visualmode, direction) " {{{
		if g:EasyMotion_startofline
			call s:EasyMotion('^\(\w\|\s*\zs\|$\)', a:direction, a:visualmode ? visualmode() : '', '')
		else
			let prev_column = getpos('.')[2] - 1
			call s:EasyMotion('^.\{,' . prev_column . '}\zs\(.\|$\)', a:direction, a:visualmode ? visualmode() : '', '')
		endif
	endfunction " }}}
	" == Search Motion =======================
	function! EasyMotion#Search(visualmode, direction) " {{{
		call s:EasyMotion(@/, a:direction, a:visualmode ? visualmode() : '', '')
	endfunction " }}}
	" == JumpToAnywhere Motion ===============
	function! EasyMotion#JumpToAnywhere(visualmode, direction) " {{{
		if !exists('g:EasyMotion_re_anywhere')
			" Anywhere regular expression: {{{
			let re = '\v' .
				\	 '(<.|^$)' . '|' .
				\	 '(.>|^$)' . '|' .
				\	 '(\l)\zs(\u)' . '|' .
				\	 '(_\zs.)' . '|' .
				\	 '(#\zs.)'
			" 1. word
			" 2. end of word
			" 3. CamelCase
			" 4. after '_' hoge_foo
			" 5. after '#' hoge#foo
			"}}}
			let g:EasyMotion_re_anywhere = get(g:, 'EasyMotion_re_anywhere', re)
		endif
		"
		call s:EasyMotion( g:EasyMotion_re_anywhere, a:direction, a:visualmode ? visualmode() : '', '')
	endfunction " }}}

	function! EasyMotion#SelectLines() "{{{
		let orig_pos = [line('.'), col('.')]

		call s:EasyMotion('^\(\w\|\s*\zs\|$\)', 2, '', '', 0, 0, 1)
		if s:EasyMotion_cancelled
			keepjumps call cursor(orig_pos[0], orig_pos[1])
			return ''
		else
			let pos1 = [line('.'), col('.')]
			keepjumps call cursor(orig_pos[0], orig_pos[1])
			call s:EasyMotion('^\(\w\|\s*\zs\|$\)', 2, '', '', pos1[0], 1, 1)
			if s:EasyMotion_cancelled
				keepjumps call cursor(orig_pos[0], orig_pos[1])
				return ''
			else
				normal! V
				keepjumps call cursor(pos1[0], pos1[1])
				normal! o
				return 1
			endif
		endif
	endfunction "}}}
	function! EasyMotion#SelectLinesYank() "{{{
		let orig_pos = [line('.'), col('.')]
		call EasyMotion#SelectLines()
		normal! y
		keepjumps call cursor(orig_pos[0], orig_pos[1])
	endfunction "}}}
	function! EasyMotion#SelectLinesDelete() "{{{
		let orig_pos = [line('.'), col('.')]
		" if cancelled?
		if EasyMotion#SelectLines()
			" Prepare the number of lines "{{{
			let start_of_line = line("v")
			silent exec "normal!" "o"
			let end_of_line = line("v")
			"}}}
			normal! d
			if orig_pos[0] < max([start_of_line,end_of_line])
				keepjumps call cursor(orig_pos[0], orig_pos[1])
			else
				" if delete lines above cursor line
				keepjumps call cursor(orig_pos[0]-abs(end_of_line-start_of_line)-1, orig_pos[1])
			endif
		else
			keepjumps call cursor(orig_pos[0], orig_pos[1])
		endif
	endfunction "}}}

	function! EasyMotion#SelectPhrase() "{{{
		let chars = s:GetSearchChar2(0)
		if empty(chars)
			return
		endif

		let orig_pos = [line('.'), col('.')]

		if g:EasyMotion_smartcase && chars[0] =~# '\v\U' || chars[1] =~# '\v\U'
			let re = '\c'
		else
			let re = '\C'
		endif

		let re = re . escape(chars[0], '.$^~') . '\|' . escape(chars[1], '.$^~')
		call s:EasyMotion(re, 2, '', '', 0, 0, 0, 0)
		if s:EasyMotion_cancelled
			keepjumps call cursor(orig_pos[0], orig_pos[1])
			return ''
		else
			let pos1 = [line('.'), col('.')]
			keepjumps call cursor(orig_pos[0], orig_pos[1])
			call s:EasyMotion(re, 2, '', '', 0, 0, 0, pos1)
			if s:EasyMotion_cancelled
				keepjumps call cursor(orig_pos[0], orig_pos[1])
				return ''
			else
				normal! v
				keepjumps call cursor(pos1[0], pos1[1])
				normal! o
				return 1
			endif
		endif
	endfunction "}}}
	function! EasyMotion#SelectPhraseYank() "{{{
		let orig_pos = [line('.'), col('.')]

		call EasyMotion#SelectPhrase()
		normal! y
		keepjumps call cursor(orig_pos[0], orig_pos[1])
	endfunction "}}}
	function! EasyMotion#SelectPhraseDelete() "{{{
		let orig_pos = [line('.'), col('.')]

		" If cancelled?
		if EasyMotion#SelectPhrase()
			" Prepare the number of lines "{{{
			let start_of_line = line("v")
			silent exec "normal!" "o"
			let end_of_line = line("v")
			"}}}
			normal! d
			if orig_pos[0] < max([start_of_line,end_of_line])
				keepjumps call cursor(orig_pos[0], orig_pos[1])
			else
				" if you delete phrase above cursor line and phrase is over lines
				keepjumps call cursor(orig_pos[0]-abs(end_of_line-start_of_line), orig_pos[1])
			endif
		else
			keepjumps call cursor(orig_pos[0], orig_pos[1])
		endif
	endfunction "}}}
	" == User Motion =========================
	function! EasyMotion#User(pattern, visualmode, direction) " {{{
		let re = escape(a:pattern, '|')
		call s:EasyMotion(re, a:direction, a:visualmode ? visualmode() : '', mode(1))
	endfunction " }}}
	function! EasyMotion#UserMapping(re, mapping, direction) " {{{
		silent exec "nnoremap ".a:mapping." :call EasyMotion#User('".a:re."', 0, ".a:direction.")<CR>"
		silent exec "onoremap ".a:mapping." :call EasyMotion#User('".a:re."', 0, ".a:direction.")<CR>"
		silent exec "vnoremap ".a:mapping." :<C-u>call EasyMotion#User('".a:re."', 0,".a:direction.")<CR>"
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

		if a:0 == 0 && has_key(s:var_reset, a:var)
			" Reset var to original value
			call setbufvar("", a:var, s:var_reset[a:var])
		elseif a:0 == 1
			let new_value = a:0 == 1 ? a:1 : ''

			" Store original value
			let s:var_reset[a:var] = getbufvar("", a:var)

			" Set new var value
			call setbufvar("", a:var, new_value)
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
		" Break undo history
		let &undolevels = &undolevels
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

	function! s:GetSearchChar2(visualmode) " {{{

		let chars = []
		for i in [1, 2]
			redraw

			call s:Prompt('Search for character ' . i)
			let char = s:GetChar()

			" Check that we have an input char
			if empty(char)
				" Restore selection
				if ! empty(a:visualmode)
					silent exec 'normal! gv'
				endif

				return ''
			endif
			call add(chars, char)
		endfor

		return chars
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

function! s:load_migemo_dict() "{{{
    let enc = &l:encoding
    if enc ==# 'utf-8'
        return EasyMotion#migemo#utf8#load_dict()
    elseif enc ==# 'cp932'
        return EasyMotion#migemo#cp932#load_dict()
    elseif enc ==# 'euc-jp'
        return EasyMotion#migemo#eucjp#load_dict()
    else
        let g:EasyMotion_use_migemo = 0
        throw "Error: ".enc." is not supported. Migemo is made disabled."
    endif
endfunction "}}}

	function! s:findMotion(char) "{{{
		" Find Motion: S,F,T
		let re = escape(a:char, '.$^~\')

		if g:EasyMotion_use_migemo && a:char =~# '\a'
			let re = s:convertMigemo(re)
		endif

		if g:EasyMotion_smartcase
			let re = s:convertSmartcase(re, a:char)
		endif

		return re
	endfunction "}}}
	function! s:convertMigemo(re) "{{{
		let re = a:re
		if ! has_key(s:migemo_dicts, &l:encoding)
			let s:migemo_dicts[&l:encoding] = s:load_migemo_dict()
		endif
		if re =~# '^\a$'
			let re = s:migemo_dicts[&l:encoding][re]
		endif
		return re
	endfunction "}}}
	function! s:convertSmartcase(re, char) "{{{
		let re = a:re
		if a:char =~# '\U' "nonuppercase
			if s:useSmartsign()
				let re = s:convertSmartsign(a:re, a:char)
			endif

			return '\c' . re
		else "uppercase
			return '\C' . re
		endif
	endfunction "}}}
	function! s:convertSmartsign(re, char) "{{{
		let smart_dict = s:load_smart_dict()
		let upper_sign = escape(get(smart_dict, a:char, ''), '.$^~')
		if upper_sign ==# ''
			return a:re
		else
			let re = a:re . '\|' . upper_sign
			return re
		endif
	endfunction "}}}
	function! s:useSmartsign() "{{{
		if exists('g:EasyMotion_use_smartsign_us') ||
		\  exists('g:EasyMotion_use_smartsign_jp')
			return 1
		else
			return 0
		endif
	endfunction "}}}
	function! s:load_smart_dict() "{{{
		if exists('g:EasyMotion_use_smartsign_us')
			return g:EasyMotion#sticky_table#us
		elseif exists('g:EasyMotion_use_smartsign_jp')
			return g:EasyMotion#sticky_table#jp
		else
			return ''
		endif
	endfunction "}}}

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
			let sort_list = []
			let coord_keys = {}
			let group_key = a:0 == 1 ? a:1 : ''

			for [key, item] in items(a:groups)
				let key = group_key . key
				"let key = ( ! empty(group_key) ? group_key : key)

				if type(item) == 3 " List
					" Destination coords

					" The key needs to be zero-padded in order to
					" sort correctly
					let dict_key = printf('%05d,%05d', item[0], item[1])
					let coord_keys[dict_key] = key

					" We need a sorting list to loop correctly in
					" PromptUser, dicts are unsorted
					call add(sort_list, dict_key)
				else
					" Item is a dict (has children)
					let coord_key_dict = s:CreateCoordKeyDict(item, key)

					" Make sure to extend both the sort list and the
					" coord key dict
					call extend(sort_list, coord_key_dict[0])
					call extend(coord_keys, coord_key_dict[1])
				endif

				unlet item
			endfor

			return [sort_list, coord_keys]
		endfunction
	" }}}
" }}}
" Core functions {{{
	function! s:PromptUser(groups, allows_repeat, fixed_column) "{{{

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
		let hl2_first_coords = [] " Highlight for two characters
		let hl2_second_coords = [] " Highlight for two characters

		let coord_key_dict = s:CreateCoordKeyDict(a:groups)

		for dict_key in sort(coord_key_dict[0])
			let target_key = coord_key_dict[1][dict_key]
			let [line_num, col_num] = split(dict_key, ',')

			let line_num = str2nr(line_num)
			let col_num = str2nr(col_num)

			" Add original line and marker line
			if ! has_key(lines, line_num)
				let current_line = getline(line_num)

				let lines[line_num] = { 'orig': current_line, 'marker': current_line, 'mb_compensation': 0 }

			endif

			" Solve multibyte issues by matching the byte column
			" number instead of the visual column
			let col_num -= lines[line_num]['mb_compensation']

			" Compensate for byte difference between marker
			" character and target character
			"
			" This has to be done in order to match the correct
			" column; \%c matches the byte column and not display
			" column.
			let target_char_len = strdisplaywidth(matchstr(lines[line_num]['marker'], '\%' . col_num . 'c.'))
			let target_key_len = strdisplaywidth(target_key)


			let target_line_byte_len = strlen(lines[line_num]['marker'])

			let target_char_byte_len = strlen(matchstr(lines[line_num]['marker'], '\%' . col_num . 'c.'))

			if a:fixed_column
				let firstS = match(lines[line_num]['marker'], '\S')
				if firstS >= 4
					let leftText = strpart(lines[line_num]['marker'], 0, firstS - 3)
				else
					let leftText = ''
				endif

				if firstS >= 1
					let rightText = strpart(lines[line_num]['marker'], firstS - 1)
				elseif firstS == 0
					let rightText = ' ' . lines[line_num]['marker']
				else
					let rightText = ''
				endif

				if target_key_len < 2
					let text = ' ' . target_key
					call add(hl_coords, '\%' . line_num . 'l\%2c')
				else
					let text = target_key
					call add(hl2_first_coords, '\%' . line_num . 'l\%1c')
					call add(hl2_second_coords, '\%' . line_num . 'l\%2c')
				endif
				let lines[line_num]['marker'] = text . ' ' . lines[line_num]['marker']
			else
				if strlen(lines[line_num]['marker']) > 0
				" Substitute marker character if line length > 0

					let c = 0
					while c < target_key_len && c < 2
						if strlen(lines[line_num]['marker']) >= col_num + c
							" Substitute marker character if line length > 0
							if c == 0
								let lines[line_num]['marker'] = substitute(
									\ lines[line_num]['marker'],
									\ '\%' . (col_num + c) . 'c.',
									\ strpart(target_key, c, 1) . repeat(' ', target_char_len - 1),
									\ '')
							else
								let lines[line_num]['marker'] = substitute(
									\ lines[line_num]['marker'],
									\ '\%' . (col_num + c) . 'c.',
									\ strpart(target_key, c, 1),
									\ '')
							endif
						else
							let lines[line_num]['marker'] = lines[line_num]['marker'] . strpart(target_key, c, 1)
						endif
						let c += 1
					endwhile
				else
				" Set the line to the marker character if the line is empty
					let lines[line_num]['marker'] = target_key
				endif
			endif

			" Add highlighting coordinates

			if !a:fixed_column
				if target_key_len == 1
					call add(hl_coords, '\%' . line_num . 'l\%' . col_num . 'c')
				else
					call add(hl2_first_coords, '\%' . line_num . 'l\%' . (col_num) . 'c')
					call add(hl2_second_coords, '\%' . line_num . 'l\%' . (col_num + 1) . 'c')
				endif
			endif

			" Add marker/target length difference for multibyte
			" compensation
			let lines[line_num]['mb_compensation'] += (target_line_byte_len - strlen(lines[line_num]['marker']) )
		endfor

		let lines_items = items(lines)
		" }}}
		" Highlight targets {{{
			if len(hl_coords) > 0
				let target_hl_id = matchadd(g:EasyMotion_hl_group_target, join(hl_coords, '\|'), 1)
			endif
			if len(hl2_second_coords) > 0
				let target_hl2_second_id = matchadd(g:EasyMotion_hl2_second_group_target, join(hl2_second_coords, '\|'), 1)
			endif
			if len(hl2_first_coords) > 0
				let target_hl2_first_id = matchadd(g:EasyMotion_hl2_first_group_target, join(hl2_first_coords, '\|'), 1)
			endif

		" }}}
		try
			" Set lines with markers
			call s:SetLines(lines_items, 'marker')

			redraw

			" Get target character {{{
				call s:Prompt('Target key')

				let char = s:GetChar()
				if g:EasyMotion_use_upper == 1 && match(g:EasyMotion_keys, '\l') == -1
					let char = toupper(char)
				endif
			" }}}
		finally
			" Restore original lines
			call s:SetLines(lines_items, 'orig')

			" Un-highlight targets {{{
				if exists('target_hl_id')
					call matchdelete(target_hl_id)
				endif
				if exists('target_hl2_first_id')
					call matchdelete(target_hl2_first_id)
				endif
				if exists('target_hl2_second_id')
					call matchdelete(target_hl2_second_id)
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
		if a:allows_repeat && char == '.'
			return g:EasyMotion_old_target
		else
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
				return s:PromptUser(target, a:allows_repeat, a:fixed_column)
			endif
		endif
	endfunction "}}}

	function! s:EasyMotion(regexp, direction, visualmode, mode, ...) " {{{
		" For SelectLines(), to highlight previous selected line
		let hlcurrent = a:0 >= 1 ? a:1 : 0
		" For SelectLines(), to allows '.' to repeat the previously pressed
		" character
		let allows_repeat = a:0 >= 2 ? a:2 : 0
		" For SelectLines(), a flag to display character only at the beginning
		" of the line
		let fixed_column = a:0 >= 3 ? a:3 : 0

		let hlchar = a:0 >= 4 ? a:4 : 0

		let orig_pos = [line('.'), col('.')]
		let targets = []

		try
			" Reset properties {{{
				call s:VarReset('&scrolloff', 0)
				call s:VarReset('&modified', 0)
				call s:VarReset('&modifiable', 1)
				call s:VarReset('&readonly', 0)
				call s:VarReset('&spell', 0)
				call s:VarReset('&virtualedit', '')
                call s:VarReset('&foldmethod', 'manual')
			" }}}
			" Find motion targets {{{
				" Setup searchpos args {{{
				let search_direction = (a:direction >= 1 ? 'b' : '')
				let search_stopline = line(a:direction >= 1 ? 'w0' : 'w$')
				let search_at_cursor = fixed_column ? 'c' : ''
				"}}}

				" Handle visual mode {{{
				if ! empty(a:visualmode)
					" Decide at where visual mode start {{{
					normal! gv
					let c_pos   = [line("."),col(".")]
					let v_start = [line("'<"),col("'<")]
					let v_end   = [line("'>"),col("'>")]

					let vmode = mode(1)
					if match('Vv',vmode) < 0
						throw 'Unkown visual mode:'.vmode
					elseif vmode ==# 'V' "line-wise Visual
						" Line-wise Visual {{{
						if v_start[0] == v_end[0]
							if search_direction == ''
								let v_pos = v_start
							elseif search_direction == 'b'
								let v_pos = v_end
							else
								throw 'Unkown search_direction'
							endif
						else
							if c_pos[0] == v_start[0]
								let v_pos = v_end

							elseif c_pos[0] == v_end[0]
								let v_pos = v_start
							endif
						endif
						"}}}
					else
						" Character-wise or Block-wise Visual"{{{
						if c_pos == v_start
							let v_pos = v_end
						elseif c_pos == v_end
							let v_pos = v_start
						else
							throw 'Unkown c_pos'
						endif
						"}}}
					endif
					"}}}
					" Reselect visual text {{{
					keepjumps call cursor(v_pos)
					exec "normal! " . a:visualmode
					keepjumps call cursor(c_pos)
					"}}}
					" Update orig_pos {{{
					let orig_pos = v_pos
					" }}}
				endif
				" }}}

				" Construct match dict {{{
				while 1
					" Note: searchpos() has side effect which call jump cursor position.
					"		You can disable this side effect by add 'n' flags,
					"		but in this case, it's better to allows jump side effect.
					let pos = searchpos(a:regexp, search_direction . search_at_cursor, search_stopline)
					let search_at_cursor = ''

					" Reached end of search range
					if pos == [0, 0]
						break
					endif

					" Skip folded lines
					if foldclosed(pos[0]) != -1 && (g:EasyMotion_skipfoldedline == 1 || pos[0] != foldclosed(pos[0]))
						continue
					endif

					call add(targets, pos)
				endwhile
				"}}}

				" Handle direction == 2"{{{
				" Reconstruct match dict
				if a:direction == 2
					if ! empty(a:visualmode)
						keepjumps call cursor(c_pos[0], c_pos[1])
					else
						keepjumps call cursor(orig_pos[0], orig_pos[1])
					endif
					let targets2 = []
					while 1
						let pos = searchpos(a:regexp, '', line('w$'))
						if pos == [0, 0]
							break
						endif

						" Skip folded lines {{{
						if foldclosed(pos[0]) != -1 && (g:EasyMotion_skipfoldedline == 1 || pos[0] != foldclosed(pos[0]))
							continue
						endif
						"}}}

						call add(targets2, pos)
					endwhile
					" Merge match target dict"{{{
					let t1 = 0
					let t2 = 0
					let targets3 = []
					while t1 < len(targets) || t2 < len(targets2)
						if t1 < len(targets)
							call add(targets3, targets[t1])
							let t1 += 1
						endif
						if t2 < len(targets2)
							call add(targets3, targets2[t2])
							let t2 += 1
						endif
					endwhile
					let targets = targets3
					"}}}
				endif
				"}}}

				" Handle no match"{{{
				let targets_len = len(targets)
				if targets_len == 0
					throw 'No matches'
				endif
				"}}}
			" }}}

			let GroupingFn = function('s:GroupingAlgorithm' . s:grouping_algorithms[g:EasyMotion_grouping])
			let groups = GroupingFn(targets, split(g:EasyMotion_keys, '\zs'))

			" Shade inactive source {{{
				if g:EasyMotion_do_shade
					let shade_hl_pos = '\%' . orig_pos[0] . 'l\%'. orig_pos[1] .'c'

					if a:direction == 1
						" Backward
						let shade_hl_re = '\%'. line('w0') .'l\_.*' . shade_hl_pos
					elseif a:direction == 0
						" Forward
						let shade_hl_re = shade_hl_pos . '\_.*\%'. line('w$') .'l'
					elseif a:direction == 2
						" Both directions"
						let shade_hl_re = '\%'. line('w0') .'l\_.*\%'. line('w$') .'l'
					endif
					if !fixed_column
						let shade_hl_id = matchadd(g:EasyMotion_hl_group_shade, shade_hl_re, 0)
					endif
				endif
				if hlcurrent != 0
					let shade_hl_line_id = matchadd(g:EasyMotion_hl_line_group_shade, '\%'. hlcurrent .'l.*', 1)
				endif
				if !empty(hlchar)
					let shade_hl_line_id = matchadd(g:EasyMotion_hl_line_group_shade, '\%'. hlchar[0] .'l\%' . hlchar[1] .'c' , 2)
				endif
			" }}}

			" Prompt user for target group/character"{{{
			let coords = s:PromptUser(groups, allows_repeat, fixed_column)
			let g:EasyMotion_old_target = coords
			"}}}

			" Update selection {{{
				if ! empty(a:visualmode)
					keepjumps call cursor(orig_pos[0], orig_pos[1])

					exec 'normal! ' . a:visualmode
				endif
			" }}}
			" Handle operator-pending mode {{{
				if a:mode == 'no'
					" This mode requires that we eat one more
					" character to the right if we're using
					" a forward motion
					" TODO: support if a:direction == 2
					if a:direction != 1
						let coords[1] += 1
					endif
				endif
			" }}}

			" Update cursor position"{{{
			call cursor(orig_pos[0], orig_pos[1])
			let mark_save = getpos("'e")
			call setpos("'e", [bufnr('%'), coords[0], coords[1], 0])
			execute 'normal! `e'
			call setpos("'e", mark_save)

			call s:Message('Jumping to [' . coords[0] . ', ' . coords[1] . ']')
			let s:EasyMotion_cancelled = 0
			"}}}
		catch
			redraw

			" Show exception message
			call s:Message(v:exception)

			" Restore original cursor position/selection {{{
				if ! empty(a:visualmode)
					silent exec 'normal! gv'
					keepjumps call cursor(c_pos[0], c_pos[1])
				else
					keepjumps call cursor(orig_pos[0], orig_pos[1])
				endif
			" }}}
			let s:EasyMotion_cancelled = 1
		finally
			" Restore properties {{{
				call s:VarReset('&scrolloff')
				call s:VarReset('&modified')
				call s:VarReset('&modifiable')
				call s:VarReset('&readonly')
				call s:VarReset('&spell')
				call s:VarReset('&virtualedit')
                call s:VarReset('&foldmethod')
			" }}}
			" Remove shading {{{
				if g:EasyMotion_do_shade && exists('shade_hl_id') && (!fixed_column)
					call matchdelete(shade_hl_id)
				endif
				if (hlcurrent || !empty(hlchar)) && exists('shade_hl_line_id')
					call matchdelete(shade_hl_line_id)
				endif
			" }}}
		endtry
	endfunction " }}}
" }}}
" Call Reset {{{
call EasyMotion#reset()
"}}}
" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" vim: fdm=marker:noet:ts=4:sw=4:sts=4
