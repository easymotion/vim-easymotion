"=============================================================================
" FILE: autoload/EasyMotion/command_line.vim
" AUTHOR: haya14busa
" Reference: https://github.com/osyo-manga/vim-over
" Last Change: 04 Feb 2014.
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

" CommandLine:
let s:cmdline = vital#of("easymotion").import("Over.Commandline")
let s:search = s:cmdline.make_plain("/")
let s:search.highlights.prompt = "Question"

" Add Module: {{{
call s:search.connect(s:cmdline.module_delete())
call s:search.connect(s:cmdline.module_cursor_move())
call s:search.connect(s:cmdline.module_paste())
call s:search.connect(s:cmdline.module_buffer_complete())
call s:search.connect(s:cmdline.module_history("/"))
call s:search.connect(s:cmdline.module_no_insert_special_chars())

let s:module = {
\   "name" : "EasyMotion",
\}
function! s:module.on_char_pre(cmdline)
    if a:cmdline.is_input("<Over>(em-scroll-f)")
        call s:scroll(0)
        call a:cmdline.setchar('')
    elseif a:cmdline.is_input("<Over>(em-scroll-b)")
        call s:scroll(1)
        call a:cmdline.setchar('')
    elseif a:cmdline.is_input("<Over>(em-jumpback)")
        keepjumps call setpos('.', s:save_orig_pos)
        let s:orig_pos = s:save_orig_pos
        let s:orig_line_start = getpos('w0')
        let s:orig_line_end = getpos('w$')
        let s:direction = s:save_direction
        call a:cmdline.setchar('')
    elseif a:cmdline.is_input("<Over>(em-openallfold)")
        " TODO: better solution
        normal! zR
        call a:cmdline.setchar('')
    endif
endfunction
call s:search.connect(s:module)
"}}}

" CommandLine Keymap: {{{
let s:default_key_mapping = {
\   "\<C-d>"   : "<Over>(buffer-complete)",
\   "\<Tab>"   : "<Over>(em-scroll-f)",
\   "\<S-Tab>" : "<Over>(em-scroll-b)",
\   "\<C-o>"   : "<Over>(em-jumpback)",
\   "\<C-z>"   : "<Over>(em-openallfold)",
\}
function! EasyMotion#command_line#keymaps() "{{{
    return extend(deepcopy(s:default_key_mapping),
                \ g:EasyMotion_command_line_key_mappings)
endfunction "}}}
function! s:search.keymappings() "{{{
    return EasyMotion#command_line#keymaps()
endfunction "}}}
"}}}

" Event: {{{
function! s:search.on_enter() "{{{
    if s:num_strokes == -1
        call EasyMotion#highlight#delete_highlight()
        call EasyMotion#highlight#add_highlight('\_.*',
                                              \ g:EasyMotion_hl_group_shade)
        call EasyMotion#highlight#add_highlight('\%#',
                                              \ g:EasyMotion_hl_inc_cursor)
    endif
endfunction "}}}
function! s:search.on_leave() "{{{
    call EasyMotion#highlight#delete_highlight(g:EasyMotion_hl_inc_search)
endfunction "}}}
function! s:search.on_char() "{{{
    if s:num_strokes == -1
        let re = s:search.getline()
        if g:EasyMotion_inc_highlight
            let case_flag = EasyMotion#helper#should_use_smartcase(re) ?
                            \ '\c' : '\C'
            let re .= case_flag
            call s:inc_highlight(re)
        endif
        if g:EasyMotion_off_screen_search
            call s:off_screen_search(re)
        endif
    elseif s:search.line.length() >=  s:num_strokes
        call s:search.exit()
    endif
endfunction "}}}
function! s:search.on_cancel() "{{{
    call s:Cancell()
    call s:search.setline('')
endfunction "}}}
"}}}

" Main:
function! EasyMotion#command_line#GetInput(num_strokes, prev, direction) "{{{
    let s:num_strokes = a:num_strokes

    let s:search.prompt = s:getPromptMessage(a:num_strokes)

    " Screen: cursor position, first and last line
    let s:orig_pos = getpos('.')
    let s:orig_line_start = getpos('w0')
    let s:orig_line_end = getpos('w$')
    let s:save_orig_pos = deepcopy(s:orig_pos)

    " Direction:
    let s:direction = a:direction == 1 ? 'b' : ''
    let s:save_direction = deepcopy(s:direction)

    let input = s:search.get()
    if input == '' && ! s:search.exit_code()
        return a:prev
    else
        return input
    endif
endfunction "}}}

" Helper:
function! s:Cancell() " {{{
    call EasyMotion#highlight#delete_highlight()
    keepjumps call setpos('.', s:save_orig_pos)
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
    " Error occur when '\zs' without '!'
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
function! s:inc_highlight(re) "{{{
    call EasyMotion#highlight#delete_highlight(g:EasyMotion_hl_inc_search)
    if s:search.line.length() > 0
        " Error occur when '\zs' without '!'
        silent! call EasyMotion#highlight#add_highlight(a:re, g:EasyMotion_hl_inc_search)
    endif
endfunction "}}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" vim: fdm=marker:et:ts=4:sw=4:sts=4
