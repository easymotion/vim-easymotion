"=============================================================================
" FILE: autoload/EasyMotion/command_line.vim
" AUTHOR: haya14busa
" Reference: https://github.com/osyo-manga/vim-over
" Last Change: 26 Jan 2014.
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================
scriptencoding utf-8
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" Autocmd: {{{
augroup plugin-easymotion-dummy
    autocmd!
augroup END

let s:cache_command = {}
function! s:doautocmd_user(command) "{{{
    if !has_key(s:cache_command, a:command)
        execute "autocmd plugin-easymotion-dummy"
\           . " User " . a:command." silent! execute ''"

        if v:version > 703 || v:version == 703 && has("patch438")
            " :helpgrep 7.4.438
            let s:cache_command[a:command] = "doautocmd <nomodeline> User " . a:command
        else
            let s:cache_command[a:command] = "doautocmd User " . a:command
        endif
    endif

    execute s:cache_command[a:command]
endfunction "}}}

augroup easymotion-cmdline
    autocmd!
    autocmd User EasyMotionCmdLineEnter call s:init()
    autocmd User EasyMotionCmdLineLeave call s:finish()
augroup END
"}}}

" Activate:
function! s:init() "{{{
    " Cursor
    let hl_cursor = EasyMotion#command_line#hl_cursor_off()
    if !hlexists("EasyMotionCommandLineCursor")
        execute "highlight EasyMotionCommandLineCursor " . hl_cursor . " term=underline gui=underline"
    endif
    " Save cursor visible
    let s:old_t_ve = &t_ve
    set t_ve=
endfunction "}}}
function! s:finish() "{{{
    " Cursor
    call EasyMotion#command_line#hl_cursor_on()
    let &t_ve = s:old_t_ve
endfunction "}}}

function! EasyMotion#command_line#hl_cursor_off() "{{{
    if exists("s:old_hi_cursor")
        return s:old_hi_cursor
    endif
    let s:old_hi_cursor = 'cterm=reverse'
    if hlexists('Cursor')
        redir => cursor
        silent highlight Cursor
        redir END
        let hl = substitute(matchstr(cursor, 'xxx \zs.*'), '[ \t\n]\+\|cleared', ' ', 'g')
        if mode(1) == 'ce'
            " TODO: this section exists only for vim-vspec test...
            let hl = substitute(hl, '\sLast\sset\sfrom.*', '', '')
        endif
        if !empty(substitute(hl, '\s', '', 'g'))
            let s:old_hi_cursor = hl
        endif
        highlight Cursor NONE
    endif
    return s:old_hi_cursor
endfunction "}}}
function! EasyMotion#command_line#hl_cursor_on() "{{{
    if exists('s:old_hi_cursor')
        silent execute 'highlight Cursor ' . s:old_hi_cursor
        unlet s:old_hi_cursor
    endif
endfunction "}}}

function! s:before_input(num_strokes) "{{{
    if a:num_strokes == -1 && g:EasyMotion_inc_highlight
        call EasyMotion#highlight#delete_highlight()
        let shade_hl_re = '\_.*'
        call EasyMotion#highlight#add_highlight(shade_hl_re, g:EasyMotion_hl_group_shade)
        call EasyMotion#highlight#add_highlight('\%#', g:EasyMotion_hl_inc_cursor)
    endif
endfunction "}}}
function! s:after_input() "{{{
    call EasyMotion#highlight#delete_highlight()
endfunction "}}}

" Main:
function! EasyMotion#command_line#GetInput(num_strokes, prev, direction) "{{{
    call s:doautocmd_user("EasyMotionCmdLineEnter")
    let previous_input = a:prev
    let s:save_direction = a:direction == 1 ? 'b' : ''
    let s:direction = s:save_direction

    " CommandLine: Input string and cursor position
    let s:command_line = s:string_with_pos('')
    let prompt = s:getPromptMessage(a:num_strokes)

    " Screen: cursor position, first and last line
    let s:orig_pos = getpos('.')
    let s:orig_line_start = getpos('w0')
    let s:orig_line_end = getpos('w$')
    let s:save_orig_pos = deepcopy(s:orig_pos)

    call s:before_input(a:num_strokes)

    let s:search_hist = []
    let s:search_cnt = 0

    try
        while s:command_line.length() < a:num_strokes ||
                \ a:num_strokes == -1
            if g:EasyMotion_show_prompt
                call s:echo_cmdline(prompt, s:command_line)
            endif

            let c = getchar()
            let s:char = type(c) == type(0) ? nr2char(c) : c

            if EasyMotion#command_line#is_input("\<Esc>") ||
                    \ EasyMotion#command_line#is_input("\<C-c>")
                " Cancel if Escape key pressed
                call s:Cancell()
                call s:command_line.set('')
                break
            elseif EasyMotion#command_line#is_input("\<CR>")
                if s:command_line.length() == 0 
                    call s:command_line.set(previous_input)
                    break
                endif
                break
            elseif EasyMotion#command_line#is_input("\<C-j>")
                break
            elseif EasyMotion#command_line#is_input("\<C-h>")
                " Delete one character
                if s:command_line.length() == 0 
                    call s:Cancell() | break
                endif
                call s:command_line.remove_prev()
            elseif EasyMotion#command_line#is_input("\<C-d>")
                " Delete one character
                if s:command_line.length() == 0 
                    call s:Cancell() | break
                endif
                call s:command_line.remove_pos()
            elseif EasyMotion#command_line#is_input("\<C-u>")
                " Delete all
                if s:command_line.length() == 0
                    call s:Cancell() | break
                endif
                call s:command_line.set(s:command_line.pos_word() .
                                      \ s:command_line.forward()) "string
                call s:command_line.set(0) " cursor
            elseif EasyMotion#command_line#is_input("\<C-w>")
                " Delete word
                let backward = matchstr(s:command_line.backward(),
                                      \ '\v^\zs.\{-}\ze((\w*)|(.))$')
                call s:command_line.set(backward . s:command_line.pos_word() . s:command_line.forward())
                call s:command_line.set(strchars(backward))
            elseif EasyMotion#command_line#is_input("\<C-p>") ||
                    \ EasyMotion#command_line#is_input("\<C-n>")
                " History
                if s:search_cnt == 0 && empty(s:search_hist)
                    let cmdline = '^' . EasyMotion#command_line#getline()
                    let s:search_hist = filter(s:search_histories(), 'v:val =~ cmdline')
                endif
                if EasyMotion#command_line#is_input("\<C-n>")
                    let s:search_cnt = max([s:search_cnt - 1, 0])
                endif
                if EasyMotion#command_line#is_input("\<C-p>")
                    let s:search_cnt = min([s:search_cnt + 1, len(s:search_hist)])
                endif
                call EasyMotion#command_line#setline(
                    \ get(s:search_hist, s:search_cnt,
                    \     EasyMotion#command_line#getline()))
            elseif EasyMotion#command_line#is_input("\<Tab>")
                call s:scroll(0)
            elseif EasyMotion#command_line#is_input("\<S-Tab>")
                call s:scroll(1)
            elseif EasyMotion#command_line#is_input("\<C-o>")
                keepjumps call setpos('.', s:save_orig_pos)
                let s:orig_pos = s:save_orig_pos
                let s:orig_line_start = getpos('w0')
                let s:orig_line_end = getpos('w$')
                let s:direction = s:save_direction
            elseif EasyMotion#command_line#is_input("\<C-z>")
                " TODO: better solution
                normal! zR
            elseif EasyMotion#command_line#is_input("\<C-f>")
                call s:command_line.next()
            elseif EasyMotion#command_line#is_input("\<C-b>")
                call s:command_line.prev()
            elseif EasyMotion#command_line#is_input("\<C-a>")
                call s:command_line.set(0)
            elseif EasyMotion#command_line#is_input("\<C-e>")
                call s:command_line.set(s:command_line.length())
            elseif char2nr(s:char) == 128 || char2nr(s:char) < 27
                " Do nothing for special key
                continue
            else
                call s:command_line.input(s:char)
            endif

            " Incremental routine {{{
            if a:num_strokes == -1
                let re = s:command_line.str()
                let case_flag = EasyMotion#helper#should_use_smartcase(re) ?
                              \ '\c' : '\C'
                let re .= case_flag
                if g:EasyMotion_inc_highlight "{{{
                    call s:inc_highlight(re)
                endif "}}}
                if g:EasyMotion_off_screen_search "{{{
                    call s:off_screen_search(re)
                endif "}}}
            endif
            "}}}
        endwhile
    finally
        call s:after_input()
        call s:doautocmd_user("EasyMotionCmdLineLeave")
    endtry
    return s:command_line.str()
endfunction "}}}
function! EasyMotion#command_line#char() "{{{
    return s:char
endfunction "}}}
function! EasyMotion#command_line#is_input(key) "{{{
    return EasyMotion#command_line#keymap(EasyMotion#command_line#char()) == a:key
endfunction "}}}
function! EasyMotion#command_line#keymap(key) "{{{
    return get(extend(deepcopy(s:default_key_mapping), g:EasyMotion_command_line_key_mappings), a:key, a:key)
endfunction "}}}
" Default_key_mapping: {{{
let s:default_key_mapping = {
\   "\<Right>" : "\<C-f>",
\   "\<Left>"  : "\<C-b>",
\   "\<Up>"    : "\<C-p>",
\   "\<Down>"  : "\<C-n>",
\   "\<BS>"    : "\<C-h>",
\   "\<Del>"   : "\<C-d>",
\   "\<Home>"  : "\<C-a>",
\   "\<End>"   : "\<C-e>",
\}
"}}}

" CommandLine:
function! s:echo_cmdline(prompt, pstr) "{{{
    " pstr -> cursor pos & string
    redraw
    echohl Question | echon a:prompt | echohl NONE
    echon a:pstr.backward()

    echohl EasyMotionCommandLineCursor
    if empty(a:pstr.pos_word())
        echon  ' '
    else
        echon a:pstr.pos_word()
    endif
    echohl NONE

    echon a:pstr.forward()
endfunction "}}}
function! s:string_with_pos(...) "{{{
    " string with cursor position
    " emulate cursor using list

    let default = get(a:, 1, '') " placeholder
    let self = {}                " OOP

    " NOTE: {{{
    " 'V!m!s{cursor}hment'
    " self.list = ['V', '!', 'm', '!', 's', 'h', 'm', 'e', 'n', 't']
    "               0 ,  1 ,  2 ,  3 ,  4 ,  5 ,  6 ,  7 ,  8 ,  9
    " self.col = 5 -> cursor
    " self.length() = 10
    " self.backward() = 'V!m!s'
    " self.pos_word() = 'h'
    " self.forward()  = 'ment'
    " self.str()      = 'V!m!s{cursor}hment'
    "}}}

    " Set: {{{
    function! self.set(item)
        return type(a:item) == type('') ? self.set_str(a:item)
\            : type(a:item) == type(0)  ? self.set_pos(a:item)
\            : self
    endfunction

    function! self.set_str(str)
        " set string
        let self.list = split(a:str, '\zs')
        let self.col  = EasyMotion#helper#strchars(a:str)
        return self
    endfunction

    function! self.set_pos(pos)
        " set cursor position
        let self.col = s:clamp(a:pos, 0, self.length())
        return self
    endfunction
    "}}}

    " Get Input: {{{
    function! self.str()
        " to string
        return join(self.list, '')
    endfunction

    function! self.backward()
        " get string backward from cursor pos
        return self.col > 0 ? join(self.list[ : self.col-1], '') : ''
    endfunction

    function! self.forward()
        " get string forward from cursor pos
        return join(self.list[self.col+1 : ], '')
    endfunction

    function! self.pos_word()
        " get cursor position character (word)
        return get(self.list, self.col, '')
    endfunction
    "}}}

    " Input: {{{
    function! self.input(str)
        call extend(self.list, split(a:str, '\zs'), self.col)
        let self.col += len(split(a:str, '\zs'))
        return self
    endfunction
    "}}}

    " Move Cursor: {{{
    function! self.next()
        return self.set_pos(self.col + 1)
    endfunction

    function! self.prev()
        return self.set_pos(self.col - 1)
    endfunction
    "}}}

    " Remove: {{{
    function! self.remove(index)
        " Remove character
        if a:index < 0 || self.length() <= a:index
            return self
        endif
        unlet self.list[a:index]
        if a:index < self.col
            call self.set(self.col - 1)
        endif
        return self
    endfunction

    function! self.remove_pos()
        return self.remove(self.col)
    endfunction

    function! self.remove_prev()
        return self.remove(self.col - 1)
    endfunction

    function! self.remove_next()
        return self.remove(self.col + 1)
    endfunction
    "}}}

    " Helper: {{{
    function! self.pos()
        " describe cursor position as column number
        return self.col
    endfunction

    function! self.length()
        return len(self.list)
    endfunction
    "}}}

    call self.set(default)
    return self
endfunction "}}}
function! s:clamp(value, min, max) "{{{
    return min([max([a:value, a:min]), a:max])
endfunction "}}}
function! EasyMotion#command_line#getline() "{{{
    return s:command_line.str()
endfunction "}}}
function! EasyMotion#command_line#setline(line) "{{{
    call s:command_line.set(a:line)
endfunction "}}}

" Helper:
function! s:InputPrompt(message, input) "{{{
    redraw
    echohl Question | echon a:message | echohl None
    echon a:input
endfunction "}}}
function! s:Cancell() " {{{
    call s:after_input()
    keepjumps call setpos('.', s:save_orig_pos)
    redraw
    echo 'EasyMotion: Cancelled'
    return ''
endfunction " }}}
function! s:getPromptMessage(num_strokes) "{{{
    if a:num_strokes == 1
        let prompt = substitute(
            \ substitute(g:EasyMotion_prompt,'{n}', a:num_strokes, 'g'),
            \ '(s)', '', 'g')
    elseif a:num_strokes == -1
        let prompt = substitute(
            \ substitute(g:EasyMotion_prompt, '{n}\s\{0,1}', '', 'g'),
            \ '(s)', 's', 'g')
    else
        let prompt = substitute(
            \ substitute(g:EasyMotion_prompt,'{n}', a:num_strokes, 'g'),
            \ '(s)', 's', 'g')
    endif
    return prompt
endfunction "}}}

function! s:off_screen_search(re) "{{{
    " First: search within visible screen range
    call s:adjust_screen()
    silent! let pos = searchpos(a:re, s:direction . 'n', s:orig_line_end[1])
    if pos != [0, 0]
        " Restore cursor posision
        keepjumps call setpos('.', s:orig_pos)
    else
        " Second: if there were no much, search off screen
        silent! let pos = searchpos(a:re, s:direction)
        if pos != [0, 0]
            " Match
            keepjumps call setpos('.', pos)
            " Move cursor
            if s:save_direction != 'b'
                normal! zzH0
            else
                normal! zzL0
            endif
        else
            " No much
            call s:adjust_screen()
            keepjumps call setpos('.', s:orig_pos)
        endif
    endif
endfunction "}}}
function! s:adjust_screen() "{{{
    if s:save_direction != 'b'
        " Forward
        keepjumps call setpos('.', s:orig_line_start)
        normal! zt
    else
        " Backward
        keepjumps call setpos('.', s:orig_line_end)
        normal! zb
    endif
endfunction "}}}
function! s:scroll(direction) "{{{
    " direction: 0 -> forward, 1 -> backward
    exec a:direction == 0 ? "normal! \<C-f>" : "normal! \<C-b>"
    let s:orig_pos = getpos('.')
    let s:orig_line_start = getpos('w0')
    let s:orig_line_end = getpos('w$')
    let s:direction = a:direction == 0 ? '' : 'b'
endfunction "}}}
function! s:search_histories() "{{{
    return map(range(&history), 'histget("search", v:val * -1)')
endfunction "}}}
function! s:inc_highlight(re) "{{{
    call EasyMotion#highlight#delete_highlight('EasyMotionIncSearch')
    if s:command_line.length() > 0
        silent! call EasyMotion#highlight#add_highlight(a:re, g:EasyMotion_hl_inc_search)
    endif
endfunction "}}}



" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" vim: fdm=marker:et:ts=4:sw=4:sts=4
