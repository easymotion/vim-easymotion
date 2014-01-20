"=============================================================================
" FILE: autoload/EasyMotion/command_line.vim
" AUTHOR: haya14busa
" Reference: https://github.com/osyo-manga/vim-over
" Last Change: 20 Jan 2014.
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

function! s:InputPrompt(message, input) "{{{
    redraw
    echohl Question | echon a:message | echohl None
    echon a:input
endfunction "}}}
function! s:Cancell() " {{{
    call EasyMotion#highlight#delete_highlight()
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
function! s:before_input(num_strokes) "{{{
    if a:num_strokes == -1 && g:EasyMotion_inc_highlight
        call EasyMotion#highlight#delete_highlight()
        let shade_hl_re = '.*'
        call EasyMotion#highlight#add_highlight(shade_hl_re, g:EasyMotion_hl_group_shade)
        let cursor_hl_re = '\%'. line('.') .'l\%'. col('.') .'c'
        call EasyMotion#highlight#add_highlight(cursor_hl_re, g:EasyMotion_hl_inc_cursor)
    endif
endfunction "}}}
function! s:after_input(num_strokes) "{{{
    call EasyMotion#highlight#delete_highlight()
endfunction "}}}
function! s:should_use_smartcase(input) "{{{
    if g:EasyMotion_smartcase == 0
        return 0
    endif
    " return 1 if input didn't match upporcase letter
    return match(a:input, '\u') == -1
endfunction "}}}
function! EasyMotion#command_line#GetInput(num_strokes, ...) "{{{
    let previous_input = a:0 == 1 ? a:1 : ''
    let input = ''
    let prompt = s:getPromptMessage(a:num_strokes)

    call s:before_input(a:num_strokes)

    while EasyMotion#helper#strchars(input) < a:num_strokes ||
            \ a:num_strokes == -1
        if g:EasyMotion_show_prompt
            call s:InputPrompt(prompt, input)
        endif
        let c = getchar()
        let s:char = type(c) == type(0) ? nr2char(c) : c
        if EasyMotion#command_line#is_input("\<Esc>")
            " Cancel if Escape key pressed
            call s:Cancell() | let input = '' | break
        elseif EasyMotion#command_line#is_input("\<C-c>")
            " Cancel
            call s:Cancell() | let input = '' | break
        elseif EasyMotion#command_line#is_input("\<C-h>")
            " Delete one character
            if len(input) == 0 
                call s:Cancell() | let input = '' | break
            endif
            let input = substitute(input, '.$', '', '')
        elseif EasyMotion#command_line#is_input("\<C-d>")
            " Delete one character
            if len(input) == 0 
                call s:Cancell() | let input = '' | break
            endif
            let input = substitute(input, '.$', '', '')
        elseif EasyMotion#command_line#is_input("\<C-u>")
            " Delete all
            if len(input) == 0
                call s:Cancell() | let input = '' | break
            endif
            let input = ''
        elseif EasyMotion#command_line#is_input("\<C-w>")
            " Delete word
            let input = matchstr(input, '^\zs.\{-}\ze\(\(\w*\)\|\(.\)\)$')
        elseif EasyMotion#command_line#is_input("\<C-p>")
            let input = previous_input
        elseif EasyMotion#command_line#is_input("\<C-n>")
            let input = ''
        elseif EasyMotion#command_line#is_input("\<CR>")
            if len(input) == 0 
                let input = previous_input | break
            endif
            break
        elseif EasyMotion#command_line#is_input("\<C-j>")
            break
        elseif char2nr(s:char) == 128 || char2nr(s:char) < 27
            " Do nothing for special key
            continue
        else
            let input .= s:char
        endif
        if g:EasyMotion_inc_highlight
            call EasyMotion#highlight#delete_highlight('EasyMotionIncSearch')
            if a:num_strokes == -1 && len(input) > 0
                let re = input
                let case_flag = s:should_use_smartcase(input) ? '\c' : '\C'
                let re .= case_flag
                call EasyMotion#highlight#add_highlight(re, g:EasyMotion_hl_inc_search)
            endif
        endif
    endwhile
    call s:after_input(a:num_strokes)
    return input
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

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" vim: fdm=marker:et:ts=4:sw=4:sts=4
