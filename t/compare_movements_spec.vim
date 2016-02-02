"=============================================================================
" FILE: t/compare_movements_spec.vim
" AUTHOR: YggdrasiI
" Test: https://github.com/kana/vim-vspec
" Description: EasyMotion keyword movement test with vim-vspec
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

" Setup {{{
let s:root_dir = matchstr(system('git rev-parse --show-cdup'), '[^\n]\+')
execute 'set' 'rtp +=./'.s:root_dir
runtime! plugin/EasyMotion.vim
" }}}

" Functions for Test {{{
function! AddLine(str)
    put! =a:str
endfunction

function! CursorPos()
    return [line('.'), col('.'), getline('.')[col('.')-1]]
endfunction

" Nested normal to avoid throwing readonly errors. They abort the testing.
function TryNormal(str)
    try
        exec 'normal ' . a:str
    catch /^Vim\%((\a\+)\)\=:E21/
    endtry
endfunction

let s:to_cursor = {}
function! s:to_cursor.match(actual, expected)
    return a:actual == a:expected
endfunction

" Add metadata about failure.
function! s:to_cursor.failure_message_for_should(actual, expected)
    return ''
    Expect a:actual[0] > 0
    Expect a:expected[0] > 0
    Expect a:actual[0] <= getpos('$')[1]
    Expect a:expected[0] <= getpos('$')[1]
    Expect a:actual[1] > 0
    Expect a:expected[1] > 0

    let l:line1 = getline(a:actual[0])
    let l:line2 = getline(a:expected[0])
    " Change char on cursor to '█'. 
    let l:line1 = strpart(l:line1, 0, a:actual[1]-1)
                \ . '█'
                \ . strpart(l:line1, a:actual[1])
    let line2 = strpart(l:line2, 0, a:expected[1]-1)
                \ . '█'
                \ . strpart(l:line2, a:expected[1])
    let l:msg = 'Line ' . string(a:actual[0]) . ": '" . l:line1
                \ . "', Line " . string(a:expected[0]) . ": '" . l:line2 . "'"
    return l:msg
endfunction

function! CompareMovements(movement1, movement2, backward)
    let l:jumpmarks = [
                \ [a:movement1, []],
                \ [a:movement2, []],
                \ ]

    " Loop through current buffer in both variants {{
    for [l:handler, l:list] in l:jumpmarks
        if a:backward == 1
            call cursor(getpos('$')[1:2])
        else
            call cursor([1,1])
        endif

        let l:lastpos = [0,0]

        call TryNormal(l:handler)
        let l:curpos = getpos(".")[1:2]

        while l:lastpos != l:curpos 
            let l:list += [l:curpos]
            let l:lastpos = l:curpos
            call TryNormal(l:handler)
            let l:curpos = getpos(".")[1:2]
        endwhile
    endfor
    " }}

    " The resulting lists are stored in l:jumpmarks[*][1], now.
    let [l:cursor_positions1, l:cursor_positions2] = [ l:jumpmarks[0][1], l:jumpmarks[1][1] ]

    " Debug output for this script
    let g:dbg_msg = printf("(CompareMovements) '%s' vs '%s'\<CR>Length of both lists: %d, %d\r Content of lists:\r%s\r\r%s",
                \ string(l:jumpmarks[0][0]),
                \ string(l:jumpmarks[1][0]),
                \ len(l:cursor_positions1), len(l:cursor_positions2),
                \ string(l:cursor_positions1),
                \ string(l:cursor_positions2))
    Expect g:dbg_msg == v:errmsg

    if l:cursor_positions1 == l:cursor_positions2
        return 0
    endif

    " Search for first unmatching position. {{
    let l:index = 0
    let l:len = min([len(l:cursor_positions2), len(l:cursor_positions1)]) 
    while l:index < l:len
        Expect l:cursor_positions2[l:index] to_cursor l:cursor_positions1[l:index]
        let l:index += 1
    endwhile

    " Collision with begin or end of file 
    if a:backward == 1
        Expect join(['File begin reached after ', len(l:cursor_positions2), ' steps.'])
                    \ == join(['File begin reached after ', len(l:cursor_positions1), ' steps.'])
    else
        Expect join(['File end reached after ', len(l:cursor_positions2), ' steps.'])
                    \ == join(['File end reached after ', len(l:cursor_positions1), ' steps.'])
    endif
    " }}

    return -1
endfunction
"}}}

"Keyword word motion {{{
describe 'Keyword word motion'
    before
        new
        nmap a <Nop>
        let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
        nmap <Leader>w <Plug>(easymotion-iskeyword-w)
        nmap <Leader>b <Plug>(easymotion-iskeyword-b)
        call EasyMotion#init()

        call vspec#customize_matcher('to_cursor', s:to_cursor)
    end

    after
        close!
    end

    it 'Simple test to check setup of this test'
        call AddLine('word')
        Expect CompareMovements('w', '\wa', 0) == 0
        "Expect CompareMovements('b', '\ba', 1) == 0
    end

    "it 'Loop through hand crafted text with rare cases'
    "    " Hand crafted text with rare cases
    "    call AddLine('scriptencoding utf-8')
    "    call AddLine('Test case [ ')
    "    call AddLine('<!{}>s!  ')
    "    Expect CompareMovements('w', '\wa', 0) == 0
    "    Expect CompareMovements('b', '\ba', 1) == 0
    "end

    "it 'Loop through Vim help buffer and compare movements'
    "    help motion.txt
    "    Expect expand('%:t') ==# 'motion.txt'
    "    "Expect CompareMovements('w', '\wa', 0) == 0
    "    "Expect CompareMovements('b', '\ba', 1) == 0
    "end

end
"}}}

" __END__  {{{
" vim: fdm=marker:et:ts=4:sw=4:sts=4
" }}}
