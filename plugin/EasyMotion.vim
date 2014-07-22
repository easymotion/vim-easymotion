" EasyMotion - Vim motions on speed!
"
" Author: Kim Silkebækken <kim.silkebaekken+vim@gmail.com>
"         haya14busa <hayabusa1419@gmail.com>
" Source: https://github.com/Lokaltog/vim-easymotion
" == Script initialization {{{
if expand("%:p") ==# expand("<sfile>:p")
  unlet! g:EasyMotion_loaded
endif
if exists('g:EasyMotion_loaded') || &compatible || version < 703
    finish
" elseif version < 703
"     echomsg "This version of EasyMotion requires Vim 7.3 or later"
"     finish
endif

let g:EasyMotion_loaded = 1
" }}}

" == Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

" == Default configuration {{{
" -- Option ------------------------------ {{{
let g:EasyMotion_keys               = get(g:,
    \ 'EasyMotion_keys', 'asdghklqwertyuiopzxcvbnmfj;')
    " \ 'EasyMotion_keys', 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
let g:EasyMotion_do_mapping         = get(g: , 'EasyMotion_do_mapping'         , 1)
let g:EasyMotion_do_shade           = get(g: , 'EasyMotion_do_shade'           , 1)
let g:EasyMotion_grouping           = get(g: , 'EasyMotion_grouping'           , 1)
let g:EasyMotion_startofline        = get(g: , 'EasyMotion_startofline'        , 1)
let g:EasyMotion_smartcase          = get(g: , 'EasyMotion_smartcase'          , 0)
let g:EasyMotion_skipfoldedline     = get(g: , 'EasyMotion_skipfoldedline'     , 1)
let g:EasyMotion_use_migemo         = get(g: , 'EasyMotion_use_migemo'         , 0)
let g:EasyMotion_use_upper          = get(g: , 'EasyMotion_use_upper'          , 0)
let g:EasyMotion_enter_jump_first   = get(g: , 'EasyMotion_enter_jump_first'   , 0)
let g:EasyMotion_space_jump_first   = get(g: , 'EasyMotion_space_jump_first'   , 0)
let g:EasyMotion_inc_highlight      = get(g: , 'EasyMotion_inc_highlight'      , 1)
let g:EasyMotion_move_highlight     = get(g: , 'EasyMotion_move_highlight'     , 1)
let g:EasyMotion_landing_highlight  = get(g: , 'EasyMotion_landing_highlight'  , 0)
let g:EasyMotion_cursor_highlight   = get(g: , 'EasyMotion_cursor_highlight'   , 1)
let g:EasyMotion_use_regexp         = get(g: , 'EasyMotion_use_regexp'         , 1)
let g:EasyMotion_add_search_history = get(g: , 'EasyMotion_add_search_history' , 1)
let g:EasyMotion_off_screen_search  = get(g: , 'EasyMotion_off_screen_search'  , 1)
let g:EasyMotion_force_csapprox     = get(g: , 'EasyMotion_force_csapprox'     , 0)
let g:EasyMotion_show_prompt        = get(g: , 'EasyMotion_show_prompt'        , 1)
let g:EasyMotion_prompt             =
    \ get(g: , 'EasyMotion_prompt' , 'Search for {n} character(s): ')
let g:EasyMotion_command_line_key_mappings =
    \ get(g: , 'EasyMotion_command_line_key_mappings' , {})
let g:EasyMotion_disable_two_key_combo     =
    \ get(g: , 'EasyMotion_disable_two_key_combo' , 0)

"}}}

" }}}

" == <Plug> Mapping {{{
" Note: bd is short for bidirectional
"       l is short for (within) line

function! s:find_motion_map_helper(motions) "{{{
    for [name, dict] in items(a:motions)
        silent exec 'noremap  <silent><Plug>(easymotion-'.name.')' .
            \ '      :<C-u>call EasyMotion#'. dict.fnc .'('. dict.cnt .',0,'. dict.direction .')<CR>'
        silent exec 'xnoremap <silent><Plug>(easymotion-'.name.')' .
            \ ' <Esc>:<C-u>call EasyMotion#'. dict.fnc .'('. dict.cnt .',1,'. dict.direction .')<CR>'
    " Example:
    " noremap  <silent><Plug>(easymotion-f2) :<C-u>call EasyMotion#S(2,1,0)<CR>
    " xnoremap <silent><Plug>(easymotion-f2) <Esc>:<C-u>call EasyMotion#S(2,1,0)<CR>
    endfor
endfunction "}}}
" Find Motion: {{{
call s:find_motion_map_helper({
    \ 'f'      : {'fnc' : 'S' , 'cnt' : 1, 'direction'  : 0},
    \ 'F'      : {'fnc' : 'S' , 'cnt' : 1, 'direction'  : 1},
    \ 's'      : {'fnc' : 'S' , 'cnt' : 1, 'direction'  : 2},
    \ 'bd-f'   : {'fnc' : 'S' , 'cnt' : 1, 'direction'  : 2},
    \ 't'      : {'fnc' : 'T' , 'cnt' : 1, 'direction'  : 0},
    \ 'T'      : {'fnc' : 'T' , 'cnt' : 1, 'direction'  : 1},
    \ 'bd-t'   : {'fnc' : 'T' , 'cnt' : 1, 'direction'  : 2},
    \ 'fl'     : {'fnc' : 'SL', 'cnt' : 1, 'direction'  : 0},
    \ 'Fl'     : {'fnc' : 'SL', 'cnt' : 1, 'direction'  : 1},
    \ 'sl'     : {'fnc' : 'SL', 'cnt' : 1, 'direction'  : 2},
    \ 'bd-fl'  : {'fnc' : 'SL', 'cnt' : 1, 'direction'  : 2},
    \ 'tl'     : {'fnc' : 'TL', 'cnt' : 1, 'direction'  : 0},
    \ 'Tl'     : {'fnc' : 'TL', 'cnt' : 1, 'direction'  : 1},
    \ 'bd-tl'  : {'fnc' : 'TL', 'cnt' : 1, 'direction'  : 2},
    \
    \ 'f2'     : {'fnc' : 'S' , 'cnt' : 2, 'direction'  : 0},
    \ 'F2'     : {'fnc' : 'S' , 'cnt' : 2, 'direction'  : 1},
    \ 's2'     : {'fnc' : 'S' , 'cnt' : 2, 'direction'  : 2},
    \ 'bd-f2'  : {'fnc' : 'S' , 'cnt' : 2, 'direction'  : 2},
    \ 't2'     : {'fnc' : 'T' , 'cnt' : 2, 'direction'  : 0},
    \ 'T2'     : {'fnc' : 'T' , 'cnt' : 2, 'direction'  : 1},
    \ 'bd-t2'  : {'fnc' : 'T' , 'cnt' : 2, 'direction'  : 2},
    \ 'fl2'    : {'fnc' : 'SL', 'cnt' : 2, 'direction'  : 0},
    \ 'Fl2'    : {'fnc' : 'SL', 'cnt' : 2, 'direction'  : 1},
    \ 'sl2'    : {'fnc' : 'SL', 'cnt' : 2, 'direction'  : 2},
    \ 'bd-fl2' : {'fnc' : 'SL', 'cnt' : 2, 'direction'  : 2},
    \ 'tl2'    : {'fnc' : 'TL', 'cnt' : 2, 'direction'  : 0},
    \ 'Tl2'    : {'fnc' : 'TL', 'cnt' : 2, 'direction'  : 1},
    \ 'bd-tl2' : {'fnc' : 'TL', 'cnt' : 2, 'direction'  : 2},
    \
    \ 'fn'     : {'fnc' : 'S' , 'cnt' : -1, 'direction' : 0},
    \ 'Fn'     : {'fnc' : 'S' , 'cnt' : -1, 'direction' : 1},
    \ 'sn'     : {'fnc' : 'S' , 'cnt' : -1, 'direction' : 2},
    \ 'bd-fn'  : {'fnc' : 'S' , 'cnt' : -1, 'direction' : 2},
    \ 'tn'     : {'fnc' : 'T' , 'cnt' : -1, 'direction' : 0},
    \ 'Tn'     : {'fnc' : 'T' , 'cnt' : -1, 'direction' : 1},
    \ 'bd-tn'  : {'fnc' : 'T' , 'cnt' : -1, 'direction' : 2},
    \ 'fln'    : {'fnc' : 'SL', 'cnt' : -1, 'direction' : 0},
    \ 'Fln'    : {'fnc' : 'SL', 'cnt' : -1, 'direction' : 1},
    \ 'sln'    : {'fnc' : 'SL', 'cnt' : -1, 'direction' : 2},
    \ 'bd-fln' : {'fnc' : 'SL', 'cnt' : -1, 'direction' : 2},
    \ 'tln'    : {'fnc' : 'TL', 'cnt' : -1, 'direction' : 0},
    \ 'Tln'    : {'fnc' : 'TL', 'cnt' : -1, 'direction' : 1},
    \ 'bd-tln' : {'fnc' : 'TL', 'cnt' : -1, 'direction' : 2},
    \ })
"}}}

" -- Word Motion {{{
" Word: {{{
noremap  <silent><Plug>(easymotion-w)          :<C-u>call EasyMotion#WB(0,0)<CR>
xnoremap <silent><Plug>(easymotion-w)     <Esc>:<C-u>call EasyMotion#WB(1,0)<CR>
noremap  <silent><Plug>(easymotion-b)          :<C-u>call EasyMotion#WB(0,1)<CR>
xnoremap <silent><Plug>(easymotion-b)     <Esc>:<C-u>call EasyMotion#WB(1,1)<CR>
noremap  <silent><Plug>(easymotion-bd-w)       :<C-u>call EasyMotion#WB(0,2)<CR>
xnoremap <silent><Plug>(easymotion-bd-w)  <Esc>:<C-u>call EasyMotion#WB(1,2)<CR>
"}}}

" WORD: {{{
noremap  <silent><Plug>(easymotion-W)         :<C-u>call EasyMotion#WBW(0,0)<CR>
xnoremap <silent><Plug>(easymotion-W)    <Esc>:<C-u>call EasyMotion#WBW(1,0)<CR>
noremap  <silent><Plug>(easymotion-B)         :<C-u>call EasyMotion#WBW(0,1)<CR>
xnoremap <silent><Plug>(easymotion-B)    <Esc>:<C-u>call EasyMotion#WBW(1,1)<CR>
noremap  <silent><Plug>(easymotion-bd-W)      :<C-u>call EasyMotion#WBW(0,2)<CR>
xnoremap <silent><Plug>(easymotion-bd-W) <Esc>:<C-u>call EasyMotion#WBW(1,2)<CR>
"}}}

" iskeyword {{{
noremap  <silent><Plug>(easymotion-iskeyword-w)         :<C-u>call EasyMotion#WBK(0,0)<CR>
xnoremap <silent><Plug>(easymotion-iskeyword-w)    <Esc>:<C-u>call EasyMotion#WBK(1,0)<CR>
noremap  <silent><Plug>(easymotion-iskeyword-b)         :<C-u>call EasyMotion#WBK(0,1)<CR>
xnoremap <silent><Plug>(easymotion-iskeyword-b)    <Esc>:<C-u>call EasyMotion#WBK(1,1)<CR>
noremap  <silent><Plug>(easymotion-iskeyword-bd-w)      :<C-u>call EasyMotion#WBK(0,2)<CR>
xnoremap <silent><Plug>(easymotion-iskeyword-bd-w) <Esc>:<C-u>call EasyMotion#WBK(1,2)<CR>
" }}}

" End Word: {{{
noremap  <silent><Plug>(easymotion-e)         :<C-u>call EasyMotion#E(0,0)<CR>
xnoremap <silent><Plug>(easymotion-e)    <Esc>:<C-u>call EasyMotion#E(1,0)<CR>
noremap  <silent><Plug>(easymotion-ge)        :<C-u>call EasyMotion#E(0,1)<CR>
xnoremap <silent><Plug>(easymotion-ge)   <Esc>:<C-u>call EasyMotion#E(1,1)<CR>
noremap  <silent><Plug>(easymotion-bd-e)      :<C-u>call EasyMotion#E(0,2)<CR>
xnoremap <silent><Plug>(easymotion-bd-e) <Esc>:<C-u>call EasyMotion#E(1,2)<CR>
"}}}

" END WORD: {{{
noremap  <silent><Plug>(easymotion-E)         :<C-u>call EasyMotion#EW(0,0)<CR>
xnoremap <silent><Plug>(easymotion-E)    <Esc>:<C-u>call EasyMotion#EW(1,0)<CR>
noremap  <silent><Plug>(easymotion-gE)        :<C-u>call EasyMotion#EW(0,1)<CR>
xnoremap <silent><Plug>(easymotion-gE)   <Esc>:<C-u>call EasyMotion#EW(1,1)<CR>
noremap  <silent><Plug>(easymotion-bd-E)      :<C-u>call EasyMotion#EW(0,2)<CR>
xnoremap <silent><Plug>(easymotion-bd-E) <Esc>:<C-u>call EasyMotion#EW(1,2)<CR>
"}}}

" iskeyword End: {{{
noremap  <silent><Plug>(easymotion-iskeyword-e)         :<C-u>call EasyMotion#EK(0,0)<CR>
xnoremap <silent><Plug>(easymotion-iskeyword-e)    <Esc>:<C-u>call EasyMotion#EK(1,0)<CR>
noremap  <silent><Plug>(easymotion-iskeyword-ge)        :<C-u>call EasyMotion#EK(0,1)<CR>
xnoremap <silent><Plug>(easymotion-iskeyword-ge)   <Esc>:<C-u>call EasyMotion#EK(1,1)<CR>
noremap  <silent><Plug>(easymotion-iskeyword-bd-e)      :<C-u>call EasyMotion#EK(0,2)<CR>
xnoremap <silent><Plug>(easymotion-iskeyword-bd-e) <Esc>:<C-u>call EasyMotion#EK(1,2)<CR>
"}}}
"}}}

" -- JK Motion {{{
noremap  <silent><Plug>(easymotion-j)          :<C-u>call EasyMotion#JK(0,0)<CR>
xnoremap <silent><Plug>(easymotion-j)     <Esc>:<C-u>call EasyMotion#JK(1,0)<CR>
noremap  <silent><Plug>(easymotion-k)          :<C-u>call EasyMotion#JK(0,1)<CR>
xnoremap <silent><Plug>(easymotion-k)     <Esc>:<C-u>call EasyMotion#JK(1,1)<CR>
noremap  <silent><Plug>(easymotion-bd-jk)      :<C-u>call EasyMotion#JK(0,2)<CR>
xnoremap <silent><Plug>(easymotion-bd-jk) <Esc>:<C-u>call EasyMotion#JK(1,2)<CR>

" Start of Line JK {{{
noremap  <silent><Plug>(easymotion-sol-j)          :<C-u>call EasyMotion#Sol(0,0)<CR>
xnoremap <silent><Plug>(easymotion-sol-j)     <Esc>:<C-u>call EasyMotion#Sol(1,0)<CR>
noremap  <silent><Plug>(easymotion-sol-k)          :<C-u>call EasyMotion#Sol(0,1)<CR>
xnoremap <silent><Plug>(easymotion-sol-k)     <Esc>:<C-u>call EasyMotion#Sol(1,1)<CR>
noremap  <silent><Plug>(easymotion-sol-bd-jk)      :<C-u>call EasyMotion#Sol(0,2)<CR>
xnoremap <silent><Plug>(easymotion-sol-bd-jk) <Esc>:<C-u>call EasyMotion#Sol(1,2)<CR>
"}}}

" End of Line JK {{{
noremap  <silent><Plug>(easymotion-eol-j)          :<C-u>call EasyMotion#Eol(0,0)<CR>
xnoremap <silent><Plug>(easymotion-eol-j)     <Esc>:<C-u>call EasyMotion#Eol(1,0)<CR>
noremap  <silent><Plug>(easymotion-eol-k)          :<C-u>call EasyMotion#Eol(0,1)<CR>
xnoremap <silent><Plug>(easymotion-eol-k)     <Esc>:<C-u>call EasyMotion#Eol(1,1)<CR>
noremap  <silent><Plug>(easymotion-eol-bd-jk)      :<C-u>call EasyMotion#Eol(0,2)<CR>
xnoremap <silent><Plug>(easymotion-eol-bd-jk) <Esc>:<C-u>call EasyMotion#Eol(1,2)<CR>
"}}}

"}}}

" -- Search Motion {{{
noremap  <silent><Plug>(easymotion-n)         :<C-u>call EasyMotion#Search(0,0,0)<CR>
xnoremap <silent><Plug>(easymotion-n)    <Esc>:<C-u>call EasyMotion#Search(1,0,0)<CR>
noremap  <silent><Plug>(easymotion-N)         :<C-u>call EasyMotion#Search(0,1,0)<CR>
xnoremap <silent><Plug>(easymotion-N)    <Esc>:<C-u>call EasyMotion#Search(1,1,0)<CR>

noremap  <silent><Plug>(easymotion-vim-n)      :<C-u>call EasyMotion#Search(0,0,1)<CR>
xnoremap <silent><Plug>(easymotion-vim-n) <Esc>:<C-u>call EasyMotion#Search(1,0,1)<CR>
noremap  <silent><Plug>(easymotion-vim-N)      :<C-u>call EasyMotion#Search(0,1,1)<CR>
xnoremap <silent><Plug>(easymotion-vim-N) <Esc>:<C-u>call EasyMotion#Search(1,1,1)<CR>

noremap  <silent><Plug>(easymotion-bd-n)      :<C-u>call EasyMotion#Search(0,2,0)<CR>
xnoremap <silent><Plug>(easymotion-bd-n) <Esc>:<C-u>call EasyMotion#Search(1,2,0)<CR>
"}}}

" -- Jump To Anywhere Motion {{{
noremap  <silent><Plug>(easymotion-jumptoanywhere)
    \      :<C-u>call EasyMotion#JumpToAnywhere(0,2)<CR>
xnoremap <silent><Plug>(easymotion-jumptoanywhere)
    \ <Esc>:<C-u>call EasyMotion#JumpToAnywhere(1,2)<CR>
"}}}

" -- Repeat Motion {{{
noremap  <silent><Plug>(easymotion-repeat)
    \      :<C-u>call EasyMotion#Repeat(0)<CR>
xnoremap <silent><Plug>(easymotion-repeat)
    \ <Esc>:<C-u>call EasyMotion#Repeat(1)<CR>

noremap  <silent><Plug>(easymotion-dotrepeat)
    \      :<C-u>call EasyMotion#DotRepeat()<CR>
"}}}

" -- Next,Previous Motion {{{
noremap  <silent><Plug>(easymotion-next)
    \      :<C-u>call EasyMotion#NextPrevious(0,0)<CR>
xnoremap <silent><Plug>(easymotion-next)
    \      :<C-u>call EasyMotion#NextPrevious(1,0)<CR>

noremap  <silent><Plug>(easymotion-prev)
    \      :<C-u>call EasyMotion#NextPrevious(0,1)<CR>
xnoremap <silent><Plug>(easymotion-prev)
    \      :<C-u>call EasyMotion#NextPrevious(1,1)<CR>
"}}}

" -- Line Motion {{{
" Word Line: {{{
noremap  <silent><Plug>(easymotion-wl)         :<C-u>call EasyMotion#WBL(0,0)<CR>
xnoremap <silent><Plug>(easymotion-wl)    <Esc>:<C-u>call EasyMotion#WBL(1,0)<CR>
noremap  <silent><Plug>(easymotion-bl)         :<C-u>call EasyMotion#WBL(0,1)<CR>
xnoremap <silent><Plug>(easymotion-bl)    <Esc>:<C-u>call EasyMotion#WBL(1,1)<CR>
noremap  <silent><Plug>(easymotion-bd-wl)      :<C-u>call EasyMotion#WBL(0,2)<CR>
xnoremap <silent><Plug>(easymotion-bd-wl) <Esc>:<C-u>call EasyMotion#WBL(1,2)<CR>
"}}}

" End Word Line: {{{
noremap  <silent><Plug>(easymotion-el)         :<C-u>call EasyMotion#EL(0,0)<CR>
xnoremap <silent><Plug>(easymotion-el)    <Esc>:<C-u>call EasyMotion#EL(1,0)<CR>
noremap  <silent><Plug>(easymotion-gel)        :<C-u>call EasyMotion#EL(0,1)<CR>
xnoremap <silent><Plug>(easymotion-gel)   <Esc>:<C-u>call EasyMotion#EL(1,1)<CR>
noremap  <silent><Plug>(easymotion-bd-el)      :<C-u>call EasyMotion#EL(0,2)<CR>
xnoremap <silent><Plug>(easymotion-bd-el) <Esc>:<C-u>call EasyMotion#EL(1,2)<CR>
"}}}

" LineAnywhere Line: {{{
noremap  <silent><Plug>(easymotion-lineforward)
    \      :<C-u>call EasyMotion#LineAnywhere(0,0)<CR>
xnoremap <silent><Plug>(easymotion-lineforward)
    \ <Esc>:<C-u>call EasyMotion#LineAnywhere(1,0)<CR>

noremap  <silent><Plug>(easymotion-linebackward)
    \      :<C-u>call EasyMotion#LineAnywhere(0,1)<CR>
xnoremap <silent><Plug>(easymotion-linebackward)
    \ <Esc>:<C-u>call EasyMotion#LineAnywhere(1,1)<CR>

noremap  <silent><Plug>(easymotion-lineanywhere)
    \      :<C-u>call EasyMotion#LineAnywhere(0,2)<CR>
xnoremap <silent><Plug>(easymotion-lineanywhere)
    \ <Esc>:<C-u>call EasyMotion#LineAnywhere(1,2)<CR>

"}}}
"}}}

noremap  <silent><Plug>(easymotion-activate) :<C-u>call EasyMotion#activate(0)<CR>
xnoremap <silent><Plug>(easymotion-activate) :<C-u>call EasyMotion#activate(1)<CR>

" }}}

" == Default key mapping {{{
if g:EasyMotion_do_mapping == 1
    " Prepare Prefix: {{{
    if exists('g:EasyMotion_leader_key')
        exec 'map ' . g:EasyMotion_leader_key . ' <Plug>(easymotion-prefix)'
    else
        if !hasmapto('<Plug>(easymotion-prefix)')
            map <Leader><Leader> <Plug>(easymotion-prefix)
        endif
    endif
    "}}}

    function! s:default_mapping(motions, do_mapping) "{{{
        for motion in a:motions
            " Mapping {{{
            if exists('g:EasyMotion_mapping_' . motion)
                " Backward compatible mapping [deprecated]
                silent exec 'map <silent> ' .
                    \ eval('g:EasyMotion_mapping_' . motion) . ' <Plug>(easymotion-' . motion . ')'
            elseif a:do_mapping
                    \ && !hasmapto('<Plug>(easymotion-' . motion . ')')
                    \ && empty(maparg('<Plug>(easymotion-prefix)' . motion, 'nov'))

                " Do mapping
                silent exec 'map <silent> ' .
                    \'<Plug>(easymotion-prefix)' . motion . ' <Plug>(easymotion-' . motion . ')'
            endif "}}}
        endfor
    endfunction "}}}

    " Default Mapping:
    call s:default_mapping(
        \ ['f', 'F', 's', 't', 'T',
        \  'w', 'W', 'b', 'B', 'e', 'E', 'ge', 'gE',
        \  'j', 'k', 'n', 'N'], g:EasyMotion_do_mapping)
endif "}}}

" == CommandLine Mapping {{{
command! -nargs=*
\   EMCommandLineNoreMap
\   call EasyMotion#command_line#cnoremap([<f-args>])
command! -nargs=*
\   EMCommandLineMap
\   call EasyMotion#command_line#cmap([<f-args>])
command! -nargs=1
\   EMCommandLineUnMap
\   call EasyMotion#command_line#cunmap(<f-args>)
"}}}

" == Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" vim: fdm=marker:et:ts=4:sw=4:sts=4
