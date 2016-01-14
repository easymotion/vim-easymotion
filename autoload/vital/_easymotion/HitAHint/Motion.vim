function! s:_vital_loaded(V) abort
  let s:Hint = a:V.import('HitAHint.Hint')
  let s:PHighlight = a:V.import('Palette.Highlight')
  let s:Buffer = a:V.import('Vim.Buffer')
  let s:Prelude = a:V.import('Prelude')
  let s:Set = a:V.import('Data.Set')
endfunction

function! s:_vital_depends() abort
  return [
  \   'HitAHint.Hint',
  \   'Palette.Highlight',
  \   'Vim.Buffer',
  \   'Prelude',
  \   'Data.Set',
  \ ]
endfunction

let s:TRUE = !0
let s:FALSE = 0
let s:DIRECTION = {'forward': 0, 'backward': 1}

" s:move() moves cursor over/accross window with Hit-A-Hint feature like
" vim-easymotion
" @param {dict} config
function! s:move(pattern, ...) abort
  let o = s:new_overwin(get(a:, 1, {}))
  return o.pattern(a:pattern)
endfunction

function! s:move_f(...) abort
  echo 'Target: '
  let c = s:getchar()
  return s:move(c, get(a:, 1, {}))
endfunction

function! s:move_f2() abort
  echo 'Target: '
  let c = s:getchar()
  redraw
  echo 'Target: ' . c
  let c2 = s:getchar()
  return s:move(s:Prelude.escape_pattern(c . c2), get(a:, 1, {}))
endfunction


let s:overwin = {
\   'config': {
\     'keys': 'asdghklqwertyuiopzxcvbnmfj;',
\     'user_upper': s:FALSE,
\     'highlight': {
\       'shade': 'HitAHintShade',
\       'target': 'HitAHintTarget',
\     },
\   }
\ }

function! s:_init_hl() abort
  highlight HitAHintShade ctermfg=242 guifg=#777777
  " highlight HitAHintTarget cterm=bold ctermfg=196 gui=bold guifg=#ff0000
  " highlight HitAHintTarget term=standout ctermfg=81 gui=bold guifg=#66D9EF
  highlight HitAHintTarget ctermfg=81 gui=bold guifg=#66D9EF
endfunction

call s:_init_hl()

augroup vital-hit-a-hint-motion-default-highlight
  autocmd!
  autocmd ColorScheme * call s:_init_hl()
augroup END


function! s:new_overwin(...) abort
  let o = deepcopy(s:overwin)
  call s:deepextend(o.config, get(a:, 1, {}))
  return o
endfunction

function! s:overwin.pattern(pattern) abort
  let winpos = self.select_winpos(self.gather_poses_overwin(a:pattern), self.config.keys)
  if winpos is# -1
  else
    let [winnr_str, pos] = winpos
    let winnr = str2nr(winnr_str)
    if winnr is# winnr()
      normal! m`
    else
      call s:move_to_win(winnr)
    endif
    call cursor(pos)
  endif
endfunction

function! s:overwin.select_winpos(winnr2poses, keys) abort
  return self.choose_prompt(s:create_hint_dict(a:winnr2poses, a:keys))
endfunction

function! s:create_hint_dict(winnr2poses, keys) abort
  let wposes = s:winnr2poses_to_list(a:winnr2poses)
  let hint_dict = s:Hint.create(wposes, a:keys)
  return hint_dict
endfunction

" s:wpos_to_hint() returns dict whose key is position with window and whose
" value is the hints.
" @param Tree{string: ((winnr, (number,number))|Tree)} hint_dict
" @return {{winnr: {string: list<char>}}} poskey to hint for each window
" e.g.
" {
"   '1': {
"     '00168:00004': ['b', 'c', 'b'],
"     '00174:00001': ['b', 'c', 'a'],
"     '00188:00004': ['b', 'b'],
"     '00190:00001': ['b', 'a'],
"     '00191:00016': ['a', 'c'],
"     '00192:00004': ['a', 'b'],
"     '00195:00035': ['a', 'a']
"   },
"   '3': {
"     '00168:00004': ['c', 'c', 'c'],
"     '00174:00001': ['c', 'c', 'b'],
"     '00188:00004': ['c', 'c', 'a'],
"     '00190:00001': ['c', 'b'],
"     '00191:00016': ['c', 'a'],
"     '00192:00004': ['b', 'c', 'c']
"   }
" }
function! s:create_win2pos2hint(hint_dict) abort
  return s:_create_win2pos2hint({}, a:hint_dict)
endfunction

function! s:_create_win2pos2hint(dict, hint_dict, ...) abort
  let prefix = get(a:, 1, [])
  for [hint, v] in items(a:hint_dict)
    if type(v) is# type({})
      call s:_create_win2pos2hint(a:dict, v, prefix + [hint])
    else
      let [winnr, pos] = v
      let a:dict[winnr] = get(a:dict, winnr, {})
      let a:dict[winnr][s:pos2poskey(pos)] = prefix + [hint]
    endif
    unlet v
  endfor
  return a:dict
endfunction

" s:pos2poskey() convertes pos to poskey to use pos as dictionary keys and
" sort pos correctly.
" @param {(number,number)} pos
" @return string
" e.g. [1, 1] -> '00001:00001'
function! s:pos2poskey(pos) abort
  return join(map(copy(a:pos), "printf('%05d', v:val)"), ':')
endfunction

" s:poskey2pos() convertes poskey to pos.
" @param {string} poskey e.g. '00001:00001'
" @return {(number,number)}
" e.g. '00001:00001' -> [1, 1]
function! s:poskey2pos(poskey) abort
  return map(split(a:poskey, ':'), 'str2nr(v:val)')
endfunction

function! s:overwin.choose_prompt(hint_dict) abort
  if empty(a:hint_dict)
    redraw
    echo 'No target'
    return -1
  endif
  let hinter = s:Hinter.new(a:hint_dict, self.config)
  try
    call hinter.before()
    call hinter.show_hint()
    redraw
    echo 'Target key: '
    let c = s:getchar()
    if self.config.user_upper
      let c = toupper(c)
    endif
  finally
    call hinter.after()
  endtry

  if has_key(a:hint_dict, c)
    let target = a:hint_dict[c]
    return type(target) is# type({}) ? self.choose_prompt(target) : target
  else
    redraw
    echo 'Invalid target: ' . c
    return -1
  endif
endfunction

" Hinter show hints accross window.
" save_lines: {{winnr: {lnum: string}}}
" w2l2c2h: winnr to lnum to col num to hints. col2hints is tuple because we
" need sorted col to hints pair.
" save_syntax: {{winnr: &syntax}}
"   {{winnr: {lnum: list<(cnum, list<char>)>}}}
let s:Hinter = {
\   'save_lines': {},
\   'w2l2c2h': {},
\   'winnrs': [],
\   'save_syntax': {},
\   'save_conceallevel': {},
\   'save_concealcursor': {},
\   'save_modified': {},
\   'save_modifiable': {},
\   'save_readonly': {},
\   'highlight_ids': {},
\ }

" @param {{winnr: {string: list<char>}}}
" function! s:Hinter.new(win2pos2hint) abort
function! s:Hinter.new(hint_dict, config) abort
  let s = deepcopy(self)
  let s.config = a:config
  let win2pos2hint = s:create_win2pos2hint(a:hint_dict)
  let s.winnrs = map(keys(win2pos2hint), 'str2nr(v:val)')
  let s.win2pos2hint = win2pos2hint
  let s.w2l2c2h = s:win2pos2hint_to_w2l2c2h(win2pos2hint)
  call s._save_lines()
  return s
endfunction

function! s:Hinter.before() abort
  call self.modify_env()
  call self.disable_conceal_in_other_win()
endfunction

function! s:Hinter.after() abort
  call self.restore_env()
  call self.restore_conceal_in_other_win()
  call self.restore_lines()
endfunction

function! s:Hinter._save_lines() abort
  let nr = winnr()
  try
    for [winnr, pos2hint] in items(self.win2pos2hint)
      call s:move_to_win(winnr)
      let lnums = map(copy(keys(pos2hint)), 's:poskey2pos(v:val)[0]')
      let self.save_lines[winnr] = get(self.save_lines, winnr, {})
      for lnum in lnums
        let self.save_lines[winnr][lnum] = getline(lnum)
      endfor
    endfor
  finally
    call s:move_to_win(nr)
  endtry
endfunction

function! s:Hinter.restore_lines() abort
  let nr = winnr()
  try
    for [winnr, lnum2line] in items(self.save_lines)
      call s:move_to_win(winnr)
      for [lnum, line] in items(lnum2line)
        if line isnot# getline(lnum)
          call setline(lnum, line)
        endif
      endfor
    endfor
  finally
    call s:move_to_win(nr)
  endtry
endfunction

function! s:Hinter.modify_env() abort
  let nr = winnr()
  try
    let self.highlight_id_cursor = matchadd('Cursor', '\%#', 1000001)
    for winnr in self.winnrs
      call s:move_to_win(winnr)
      let self.save_syntax[winnr] = &syntax
      let self.save_conceallevel[winnr] = &l:conceallevel
      let self.save_concealcursor[winnr] = &l:concealcursor
      let self.save_modified[winnr] = &l:modified
      let self.save_modifiable[winnr] = &l:modifiable
      let self.save_readonly[winnr] = &l:readonly

      setlocal modifiable
      setlocal noreadonly

      let self.save_conceal = s:PHighlight.get('Conceal')

      ownsyntax overwin
      syntax clear
      setlocal conceallevel=2
      setlocal concealcursor=ncv
      execute 'highlight! link Conceal' self.config.highlight.target

      let self.highlight_ids[winnr] = get(self.highlight_ids, winnr, [])
      let self.highlight_ids[winnr] += [matchadd(self.config.highlight.shade, '\_.*', 100)]
    endfor
  finally
    call s:move_to_win(nr)
  endtry
endfunction

function! s:Hinter.restore_env() abort
  let nr = winnr()
  try
    call matchdelete(self.highlight_id_cursor)
    for winnr in self.winnrs
      call s:move_to_win(winnr)
      let &syntax = self.save_syntax[winnr]
      call s:PHighlight.set('Conceal', self.save_conceal)
      let &l:conceallevel = self.save_conceallevel[winnr]
      let &l:concealcursor = self.save_concealcursor[winnr]

      " Turn off &l:modified before restoring thie value so that restore undo
      " state. It's important to turn off this option after manipulating
      " buffer text.
      let &l:modified = 0
      let &l:modified = self.save_modified[winnr]
      let &l:modifiable = self.save_modifiable[winnr]
      let &l:readonly = self.save_readonly[winnr]

      for id in self.highlight_ids[winnr]
        call matchdelete(id)
      endfor
    endfor
  finally
    call s:move_to_win(nr)
  endtry
endfunction

function! s:Hinter.disable_conceal_in_other_win() abort
  let allwinnrs = s:Set.set(range(1, winnr('$')))
  let other_winnrs = allwinnrs.sub(self.winnrs).to_list()
  for w in other_winnrs
    if 'help' !=# getwinvar(w, '&buftype')
      call setwinvar(w, 'overwin_save_conceallevel', getwinvar(w, '&conceallevel'))
      call setwinvar(w, '&conceallevel', 0)
    endif
  endfor
endfunction

function! s:Hinter.restore_conceal_in_other_win() abort
  let allwinnrs = s:Set.set(range(1, winnr('$')))
  let other_winnrs = allwinnrs.sub(self.winnrs).to_list()
  for w in other_winnrs
    if 'help' !=# getwinvar(w, '&buftype')
      call setwinvar(w, '&conceallevel', getwinvar(w, 'overwin_save_conceallevel'))
    endif
  endfor
endfunction

" ._pos2hint_to_line2col2hint() converts pos2hint to line2col2hint dict whose
" key is line number and whose value is list of tuple of col number to hint.
" line2col2hint is for show hint with replacing line by line.
" col should be sorted.
" @param {{string: list<char>}} pos2hint
" @return {number: [(number, list<char>)]}
function! s:Hinter._pos2hint_to_line2col2hint(pos2hint) abort
  let line2col2hint = {}
  let poskeys = sort(keys(a:pos2hint))
  for poskey in poskeys
    let [lnum, cnum] = s:poskey2pos(poskey)
    let line2col2hint[lnum] = get(line2col2hint, lnum, [])
    let line2col2hint[lnum] += [[cnum, a:pos2hint[poskey]]]
  endfor
  return line2col2hint
endfunction

function! s:Hinter.show_hint() abort
  let nr = winnr()
  try
    for winnr in self.winnrs
      call s:move_to_win(winnr)
      call self._show_hint_for_win(winnr)
    endfor
  finally
    call s:move_to_win(nr)
  endtry
endfunction

function! s:Hinter._show_hint_for_win(winnr) abort
  for [lnum, col2hint] in items(self.w2l2c2h[a:winnr])
    call self._show_hint_for_line(a:winnr, lnum, col2hint)
  endfor
endfunction

function! s:Hinter._show_hint_for_line(winnr, lnum, col2hint) abort
  let line = self.save_lines[a:winnr][a:lnum]
  let col_offset = 0
  let prev_cnum = -1
  let next_offset = 0
  for [cnum, hint] in a:col2hint
    let col_num = cnum + col_offset

    let is_consecutive = cnum is# prev_cnum + 1
    " if cnum isnot# prev_cnum + 1
    if !is_consecutive
      let col_num += next_offset
    else
      let save_next_offset = next_offset
    endif

    let [line, offset, next_offset] = self._replace_line_for_hint(a:lnum, col_num, line, hint)

    if is_consecutive
      let col_offset += save_next_offset
    endif
    let col_offset += offset

    call s:show_hint_pos(a:lnum, col_num, hint[0])
    if len(hint) > 1
      call s:show_hint_pos(a:lnum, col_num + 1, hint[1])
    endif

    let prev_cnum = cnum
  endfor
endfunction

" ._replace_line_for_hint() replaces line to show hints.
" - It appends space if the line is empty
" - It replaces <Tab> to space if the target character is <Tab>
" - It replaces next target character if it's <Tab> and len(hint) > 1
" Replacing line changes col number, so it returns offset of col number.
" As for replaceing next target character, the timing to calculate offset
" depends on the col number of next hint in the same line, so it returns
" `next_offset` instead of returning offset all at once.
" @return {(string, number, number)} (line, offset, next_offset)
function! s:Hinter._replace_line_for_hint(lnum, col_num, line, hint) abort
  let line = a:line
  let col_num = a:col_num
  let target = matchstr(line, '\%' . col_num .'c.')
  " Append one space for empty line or match at end of line
  if target is# ''
    let hintwidth = strdisplaywidth(join(a:hint[:1], ''))
    let line .= repeat(' ', hintwidth)
    call setline(a:lnum, line)
    return [line, hintwidth, 0]
  endif

  let offset = 0
  if target is# "\t"
    let [line, offset] = self._replace_tab_target(a:lnum, col_num, line)
  elseif strdisplaywidth(target) > 1
    let line = self._replace_text_to_space(line, a:lnum, col_num, strdisplaywidth(target))
    let offset = strdisplaywidth(target) - len(target)
  endif

  let next_offset = 0
  if len(a:hint) > 1
    " pass [] as hint to stop recursion.
    let [line, next_offset, _] = self._replace_line_for_hint(a:lnum, col_num + offset + 1, line, [])
  endif
  return [line, offset, next_offset]
endfunction

" @return {(line, offset)}
function! s:Hinter._replace_tab_target(lnum, col_num, line) abort
  let space_len = s:tab2spacelen(a:line, a:col_num)
  let line = self._replace_text_to_space(a:line, a:lnum, a:col_num, space_len)
  return [line, space_len - 1]
endfunction

function! s:Hinter._replace_text_to_space(line, lnum, col_num, len) abort
  let target = printf('\%%%dc.', a:col_num)
  let line = substitute(a:line, target, repeat(' ', a:len), '')
  call setline(a:lnum, line)
  return line
endfunction

" @param {number} col_num col_num is 1 origin like col()
function! s:tab2spacelen(line, col_num) abort
  let before_line = a:col_num > 2 ? a:line[: a:col_num - 2]
  \   : a:col_num is# 2 ? a:line[0]
  \   : ''
  let vcol_num = 1
  for c in split(before_line, '\zs')
    let vcol_num += c is# "\t" ? s:_virtual_tab2spacelen(vcol_num) : len(c)
  endfor
  return s:_virtual_tab2spacelen(vcol_num)
endfunction

function! s:_virtual_tab2spacelen(col_num) abort
  return &tabstop - ((a:col_num - 1) % &tabstop)
endfunction

function! s:win2pos2hint_to_w2l2c2h(win2pos2hint) abort
  let w2l2c2h = {}
  for [winnr, pos2hint] in items(a:win2pos2hint)
    let w2l2c2h[winnr] = s:pos2hint_to_line2col2hint(pos2hint)
  endfor
  return w2l2c2h
endfunction

" s:pos2hint_to_line2col2hint() converts pos2hint to line2col2hint dict whose
" key is line number and whose value is list of tuple of col number to hint.
" line2col2hint is for show hint with replacing line by line.
" col should be sorted.
" @param {{string: list<char>}} pos2hint
" @return {number: [(number, list<char>)]}
function! s:pos2hint_to_line2col2hint(pos2hint) abort
  let line2col2hint = {}
  let poskeys = sort(keys(a:pos2hint))
  for poskey in poskeys
    let [lnum, cnum] = s:poskey2pos(poskey)
    let line2col2hint[lnum] = get(line2col2hint, lnum, [])
    let line2col2hint[lnum] += [[cnum, a:pos2hint[poskey]]]
  endfor
  return line2col2hint
endfunction

" @param {number} winnr
function! s:move_to_win(winnr) abort
  if a:winnr !=# winnr()
    execute a:winnr . 'wincmd w'
  endif
endfunction

" @param {regex} pattern
" @return {{winnr: list<list<(number,number))>}}
function! s:overwin.gather_poses_overwin(pattern) abort
  return s:wincall(function('s:gather_poses'), [a:pattern])
endfunction

" s:gather_poses() aggregates patterm matched positions in visible current
" window for both direction excluding poses in fold.
" @return {{list<list<(number,number))>}}
function! s:gather_poses(pattern) abort
  let f = s:gather_visible_matched_poses(a:pattern, s:DIRECTION.forward, s:TRUE)
  let b = s:gather_visible_matched_poses(a:pattern, s:DIRECTION.backward, s:FALSE)
  return filter(f + b, '!s:is_in_fold(v:val[0])')
endfunction

" s:gather_visible_matched_poses() aggregates pattern matched positions in visible current
" window.
" @param {regex} pattern
" @param {enum<DIRECTION>} direction see s:DIRECTION
" @param {bool} allow_cursor_pos_match
" @return {list<list<(number,number)>>} positions
function! s:gather_visible_matched_poses(pattern, direction, allow_cursor_pos_match) abort
  let stop_line = line(a:direction is# s:DIRECTION.forward ? 'w$' : 'w0')
  let search_flag = (a:direction is# s:DIRECTION.forward ? '' : 'b')
  let c_flag = a:allow_cursor_pos_match ? 'c' : ''
  let view = winsaveview()
  let poses = []
  keepjumps let pos = searchpos(a:pattern, c_flag . search_flag, stop_line)
  while pos != [0, 0]
    let poses += [pos]
    keepjumps let pos = searchpos(a:pattern, search_flag, stop_line)
  endwhile
  call winrestview(view)
  return poses
endfunction

" @param {{winnr: list<list<(number,number))>}} winnr2poses
" @param {number?} first_winnr the top winnr poses in returned list
" @return {list<{list<(winnr, (number,number))}>}
function! s:winnr2poses_to_list(winnr2poses, ...) abort
  let first_winnr = get(a:, 1, winnr())
  let first_winnr_poses = []
  let other_poses = []
  for [winnr_str, poses] in items(a:winnr2poses)
    let winnr = str2nr(winnr_str)
    if winnr is# first_winnr
      let first_winnr_poses = map(copy(poses), '[winnr, v:val]')
    else
      let other_poses += map(copy(poses), '[winnr, v:val]')
    endif
  endfor
  return first_winnr_poses + other_poses
endfunction

" @param {number} lnum line number
function! s:is_in_fold(lnum) abort
  return foldclosed(a:lnum) != -1
endfunction

function! s:getchar(...)
  let mode = get(a:, 1, 0)
  while 1
    let char = call('getchar', a:000)
    " Workaround for the <expr> mappings
    if string(char) !~# "\x80\xfd`"
      return mode == 1 ? !!char
      \   : type(char) == type(0) ? nr2char(char) : char
    endif
  endwhile
endfunction

" @param {funcref} func
" @param {arglist} list<S>
" @param {dict?} dict for :h call()
" @return {{winnr: <T>}}
function! s:wincall(func, arglist, ...) abort
  let dict = get(a:, 1, {})
  let r = {}
  let start_winnr = winnr()
  let r[start_winnr] = call(a:func, a:arglist, dict)
  if s:Buffer.is_cmdwin()
    return r
  endif
  noautocmd wincmd w
  while winnr() isnot# start_winnr
    let r[winnr()] = call(a:func, a:arglist, dict)
    noautocmd wincmd w
  endwhile
  return r
endfunction

function! s:show_hint_pos(lnum, cnum, char) abort
  let p = '\%'. a:lnum . 'l\%'. a:cnum . 'c.'
  exec "syntax match HitAHintTarget '". p . "' conceal cchar=". a:char
endfunction

" deepextend (nest: 1)
function! s:deepextend(expr1, expr2) abort
  let expr2 = copy(a:expr2)
  for [k, V] in items(a:expr1)
    if (type(V) is type({}) || type(V) is type([])) && has_key(expr2, k)
      let a:expr1[k] = extend(a:expr1[k], expr2[k])
      unlet expr2[k]
    endif
    unlet V
  endfor
  return extend(a:expr1, expr2)
endfunction
