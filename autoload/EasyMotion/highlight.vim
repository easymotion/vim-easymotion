"=============================================================================
" FILE: highlight.vim
" AUTHOR: haya14busa
" Reference: https://github.com/t9md/vim-smalls
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

" Init: {{{
let s:h = {}
let s:h.ids = {}
let s:priorities = {
    \  g:EasyMotion_hl_group_target : 1,
    \  g:EasyMotion_hl2_first_group_target : 1,
    \  g:EasyMotion_hl2_second_group_target : 1,
    \  g:EasyMotion_hl_group_shade : 0,
    \  g:EasyMotion_hl_inc_search : 1,
    \  g:EasyMotion_hl_inc_cursor : 2,
    \  g:EasyMotion_hl_move : 0,
    \ }
for group in keys(s:priorities)
    let s:h.ids[group] = []
endfor
"}}}

function! EasyMotion#highlight#delete_highlight(...) "{{{
    let groups = !empty(a:000) ? a:000 : keys(s:priorities)
    for group in groups
        for id in s:h.ids[group]
            silent! call matchdelete(id)
        endfor
        let s:h.ids[group] = []
    endfor
endfunction "}}}
function! EasyMotion#highlight#add_highlight(re, group) "{{{
    call add(s:h.ids[a:group], matchadd(a:group, a:re, s:priorities[a:group]))
endfunction "}}}
function! EasyMotion#highlight#attach_autocmd() "{{{
    " Reference: https://github.com/justinmk/vim-sneak
    augroup plugin-easymotion
        autocmd!
        autocmd InsertEnter,WinLeave,BufLeave <buffer>
            \ silent! call EasyMotion#highlight#delete_highlight()
            \  | autocmd! plugin-easymotion * <buffer>
        autocmd CursorMoved <buffer>
            \ autocmd plugin-easymotion CursorMoved <buffer>
            \ silent! call EasyMotion#highlight#delete_highlight()
            \  | autocmd! plugin-easymotion * <buffer>
    augroup END
endfunction "}}}
function! EasyMotion#highlight#add_color_group(new_groups) "{{{
    let s:priorities = extend(deepcopy(s:priorities), a:new_groups)
    for group in keys(a:new_groups)
        let s:h.ids[group] = []
    endfor
endfunction "}}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" __END__  {{{
" vim: expandtab softtabstop=4 shiftwidth=4
" vim: foldmethod=marker
" }}}
