"=============================================================================
" FILE: autoload/EasyMotion/helper.vim
" AUTHOR: haya14busa
" Last Change: 25 Jan 2014.
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

function! EasyMotion#helper#mode(flag) "{{{
    return mode(a:flag) == "\<C-v>" ? "C-v" : mode(a:flag)
endfunction "}}}

function! EasyMotion#helper#is_greater_coords(coords1, coords2) "{{{
    " [line_num, col_num] < [line_num, col_num]
    "
    " coords1 < coords2  : return 1
    " coords1 > coords2  : return -1
    " coords1 == coords2 : return 0
    if a:coords1 == a:coords2 | return 0 | endif

    if a:coords1[0] < a:coords2[0]
        return 1
    elseif a:coords1[0] > a:coords2[0]
        return -1
    endif

    " Same line
    if a:coords1[1] < a:coords2[1]
        return 1
    elseif a:coords1[1] > a:coords2[1]
        return -1
    endif
endfunction "}}}

function! EasyMotion#helper#is_folded(line) "{{{
    " Return false if g:EasyMotion_skipfoldedline == 1
    " and line is start of folded lines
    return foldclosed(a:line) != -1 &&
        \ (g:EasyMotion_skipfoldedline == 1 ||
        \  a:line != foldclosed(a:line))
endfunction "}}}
function! EasyMotion#helper#should_use_smartcase(input) "{{{
    if g:EasyMotion_smartcase == 0
        return 0
    endif
    " return 1 if input didn't match uppercase letter
    return match(a:input, '\u') == -1
endfunction "}}}

" Migemo {{{
function! EasyMotion#helper#load_migemo_dict() "{{{
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

" EasyMotion#helper#strchars() {{{
if exists('*strchars')
    function! EasyMotion#helper#strchars(str)
        return strchars(a:str)
    endfunction
else
    function! EasyMotion#helper#strchars(str)
        return strlen(substitute(str, ".", "x", "g"))
    endfunction
endif "}}}
function! EasyMotion#helper#include_multibyte_char(str) "{{{
    return strlen(a:str) != EasyMotion#helper#strchars(a:str)
endfunction "}}}
"}}}

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" vim: fdm=marker:et:ts=4:sw=4:sts=4
