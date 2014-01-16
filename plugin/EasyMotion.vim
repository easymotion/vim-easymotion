" EasyMotion - Vim motions on speed!
"
" Author: Kim Silkebækken <kim.silkebaekken+vim@gmail.com>
" Maintainer: haya14busa <hayabusa1419@gmail.com>
" Source: https://github.com/haya14busa/vim-easymotion
" Original: https://github.com/Lokaltog/vim-easymotion

" == Script initialization {{{
if exists('g:EasyMotion_loaded') || &compatible || version < 702
    finish
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
    \ 'EasyMotion_keys', 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
let g:EasyMotion_do_mapping         = get(g: , 'EasyMotion_do_mapping'         , 1)
let g:EasyMotion_do_special_mapping = get(g: , 'EasyMotion_do_special_mapping' , 0)
let g:EasyMotion_do_shade           = get(g: , 'EasyMotion_do_shade'           , 1)
let g:EasyMotion_grouping           = get(g: , 'EasyMotion_grouping'           , 1)
let g:EasyMotion_startofline        = get(g: , 'EasyMotion_startofline'        , 1)
let g:EasyMotion_smartcase          = get(g: , 'EasyMotion_smartcase'          , 0)
let g:EasyMotion_skipfoldedline     = get(g: , 'EasyMotion_skipfoldedline'     , 1)
let g:EasyMotion_use_migemo         = get(g: , 'EasyMotion_use_migemo'         , 0)
let g:EasyMotion_use_upper          = get(g: , 'EasyMotion_use_upper'          , 0)
let g:EasyMotion_enter_jump_first   = get(g: , 'EasyMotion_enter_jump_first'   , 0)
let g:EasyMotion_show_prompt        = get(g: , 'EasyMotion_show_prompt'        , 1)
let g:EasyMotion_prompt             = get(g: , 'EasyMotion_prompt' , '> ')
let g:EasyMotion_command_line_key_mappings =
    \ get(g: , 'EasyMotion_command_line_key_mappings' , {})

"}}}

" -- Default highlighting ---------------- {{{
let g:EasyMotion_hl_group_target         = get(g:,
    \ 'EasyMotion_hl_group_target', 'EasyMotionTarget')
let g:EasyMotion_hl2_first_group_target  = get(g:,
    \ 'EasyMotion_hl2_first_group_target', 'EasyMotionTarget2First')
let g:EasyMotion_hl2_second_group_target = get(g:,
    \ 'EasyMotion_hl2_second_group_target', 'EasyMotionTarget2Second')
let g:EasyMotion_hl_group_shade          = get(g:,
    \ 'EasyMotion_hl_group_shade', 'EasyMotionShade')
let g:EasyMotion_hl_line_group_shade     = get(g:,
    \ 'EasyMotion_hl_line_group_shade', 'EasyMotionShadeLine')

let s:target_hl_defaults = {
    \   'gui'     : ['NONE', '#ff0000' , 'bold']
    \ , 'cterm256': ['NONE', '196'     , 'bold']
    \ , 'cterm'   : ['NONE', 'red'     , 'bold']
    \ }

let s:target_hl2_first_defaults = {
	\   'gui'     : ['NONE', '#ffb400' , 'bold']
	\ , 'cterm256': ['NONE', '11'      , 'bold']
	\ , 'cterm'   : ['NONE', 'yellow'  , 'bold']
	\ }

let s:target_hl2_second_defaults = {
	\   'gui'     : ['NONE', '#b98300' , 'bold']
	\ , 'cterm256': ['NONE', '3'       , 'bold']
	\ , 'cterm'   : ['NONE', 'yellow'  , 'bold']
	\ }

let s:shade_hl_defaults = {
    \   'gui'     : ['NONE', '#777777' , 'NONE']
    \ , 'cterm256': ['NONE', '242'     , 'NONE']
    \ , 'cterm'   : ['NONE', 'grey'    , 'NONE']
    \ }

let s:shade_hl_line_defaults = {
    \   'gui'     : ['red' , '#FFFFFF' , 'NONE']
    \ , 'cterm256': ['red' , '242'     , 'NONE']
    \ , 'cterm'   : ['red' , 'grey'    , 'NONE']
    \ }

call EasyMotion#init#InitHL(g:EasyMotion_hl_group_target, s:target_hl_defaults)
call EasyMotion#init#InitHL(g:EasyMotion_hl2_first_group_target, s:target_hl2_first_defaults)
call EasyMotion#init#InitHL(g:EasyMotion_hl2_second_group_target, s:target_hl2_second_defaults)
call EasyMotion#init#InitHL(g:EasyMotion_hl_group_shade,  s:shade_hl_defaults)
call EasyMotion#init#InitHL(g:EasyMotion_hl_line_group_shade,  s:shade_hl_line_defaults)

" Reset highlighting after loading a new color scheme {{{
augroup EasyMotionInitHL
    autocmd!

    autocmd ColorScheme * call EasyMotion#init#InitHL(g:EasyMotion_hl_group_target, s:target_hl_defaults)
    autocmd ColorScheme * call EasyMotion#init#InitHL(g:EasyMotion_hl2_first_group_target, s:target_hl2_first_defaults)
    autocmd ColorScheme * call EasyMotion#init#InitHL(g:EasyMotion_hl2_second_group_target, s:target_hl2_second_defaults)
    autocmd ColorScheme * call EasyMotion#init#InitHL(g:EasyMotion_hl_group_shade,  s:shade_hl_defaults)
    autocmd ColorScheme * call EasyMotion#init#InitHL(g:EasyMotion_hl_line_group_shade,  s:shade_hl_line_defaults)
augroup end
" }}}
" }}}
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
    " noremap  <silent><Plug>(easymotion-f2) <Esc>:<C-u>call EasyMotion#S(2,1,0)<CR>
    " xnoremap <silent><Plug>(easymotion-f2) <Esc>:<C-u>call EasyMotion#S(2,1,0)<CR>
    endfor
endfunction "}}}
" Find Motion: {{{
call s:find_motion_map_helper({
    \ 'f'   : {'fnc': 'S' , 'cnt': 1, 'direction': 0},
    \ 'F'   : {'fnc': 'S' , 'cnt': 1, 'direction': 1},
    \ 's'   : {'fnc': 'S' , 'cnt': 1, 'direction': 2},
    \ 't'   : {'fnc': 'T' , 'cnt': 1, 'direction': 0},
    \ 'T'   : {'fnc': 'T' , 'cnt': 1, 'direction': 1},
    \ 'fl'  : {'fnc': 'SL', 'cnt': 1, 'direction': 0},
    \ 'Fl'  : {'fnc': 'SL', 'cnt': 1, 'direction': 1},
    \ 'sl'  : {'fnc': 'SL', 'cnt': 1, 'direction': 2},
    \ 'tl'  : {'fnc': 'TL', 'cnt': 1, 'direction': 0},
    \ 'Tl'  : {'fnc': 'TL', 'cnt': 1, 'direction': 1},
    \
    \ 'f2'  : {'fnc': 'S' , 'cnt': 2, 'direction': 0},
    \ 'F2'  : {'fnc': 'S' , 'cnt': 2, 'direction': 1},
    \ 's2'  : {'fnc': 'S' , 'cnt': 2, 'direction': 2},
    \ 't2'  : {'fnc': 'T' , 'cnt': 2, 'direction': 0},
    \ 'T2'  : {'fnc': 'T' , 'cnt': 2, 'direction': 1},
    \ 'fl2' : {'fnc': 'SL', 'cnt': 2, 'direction': 0},
    \ 'Fl2' : {'fnc': 'SL', 'cnt': 2, 'direction': 1},
    \ 'sl2' : {'fnc': 'SL', 'cnt': 2, 'direction': 2},
    \ 'tl2' : {'fnc': 'TL', 'cnt': 2, 'direction': 0},
    \ 'Tl2' : {'fnc': 'TL', 'cnt': 2, 'direction': 1},
    \
    \ 'fn'  : {'fnc': 'S' , 'cnt': 50, 'direction': 0},
    \ 'Fn'  : {'fnc': 'S' , 'cnt': 50, 'direction': 1},
    \ 'sn'  : {'fnc': 'S' , 'cnt': 50, 'direction': 2},
    \ 'tn'  : {'fnc': 'T' , 'cnt': 50, 'direction': 0},
    \ 'Tn'  : {'fnc': 'T' , 'cnt': 50, 'direction': 1},
    \ 'fln' : {'fnc': 'SL', 'cnt': 50, 'direction': 0},
    \ 'Fln' : {'fnc': 'SL', 'cnt': 50, 'direction': 1},
    \ 'sln' : {'fnc': 'SL', 'cnt': 50, 'direction': 2},
    \ 'tln' : {'fnc': 'TL', 'cnt': 50, 'direction': 0},
    \ 'Tln' : {'fnc': 'TL', 'cnt': 50, 'direction': 1},
    \ })
"}}}

" -- Word Motion {{{
" Word: {{{
noremap  <silent><Plug>(easymotion-w)      :<C-u>call EasyMotion#WB(0,0)<CR>
xnoremap <silent><Plug>(easymotion-w) <Esc>:<C-u>call EasyMotion#WB(1,0)<CR>
noremap  <silent><Plug>(easymotion-b)      :<C-u>call EasyMotion#WB(0,1)<CR>
xnoremap <silent><Plug>(easymotion-b) <Esc>:<C-u>call EasyMotion#WB(1,1)<CR>

" backward compatibility
noremap  <silent><Plug>(easymotion-S)         :<C-u>call EasyMotion#WB(0,2)<CR>
xnoremap <silent><Plug>(easymotion-S)    <Esc>:<C-u>call EasyMotion#WB(1,2)<CR>
noremap  <silent><Plug>(easymotion-bd-w)      :<C-u>call EasyMotion#WB(0,2)<CR>
xnoremap <silent><Plug>(easymotion-bd-w) <Esc>:<C-u>call EasyMotion#WB(1,2)<CR>
"}}}

" WORD: {{{
noremap  <silent><Plug>(easymotion-w)         :<C-u>call EasyMotion#WBW(0,0)<CR>
xnoremap <silent><Plug>(easymotion-w)    <Esc>:<C-u>call EasyMotion#WBW(1,0)<CR>
noremap  <silent><Plug>(easymotion-B)         :<C-u>call EasyMotion#WBW(0,1)<CR>
xnoremap <silent><Plug>(easymotion-B)    <Esc>:<C-u>call EasyMotion#WBW(1,1)<CR>
noremap  <silent><Plug>(easymotion-bd-W)      :<C-u>call EasyMotion#WBW(0,2)<CR>
xnoremap <silent><Plug>(easymotion-bd-W) <Esc>:<C-u>call EasyMotion#WBW(1,2)<CR>
"}}}

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
noremap  <silent><Plug>(easymotion-sol-bd-Jk)      :<C-u>call EasyMotion#Sol(0,2)<CR>
xnoremap <silent><Plug>(easymotion-sol-bd-Jk) <Esc>:<C-u>call EasyMotion#Sol(1,2)<CR>
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
noremap  <silent><Plug>(easymotion-n)         :<C-u>call EasyMotion#Search(0,0)<CR>
xnoremap <silent><Plug>(easymotion-n)    <Esc>:<C-u>call EasyMotion#Search(1,0)<CR>
noremap  <silent><Plug>(easymotion-N)         :<C-u>call EasyMotion#Search(0,1)<CR>
xnoremap <silent><Plug>(easymotion-N)    <Esc>:<C-u>call EasyMotion#Search(1,1)<CR>
noremap  <silent><Plug>(easymotion-bd-n)      :<C-u>call EasyMotion#Search(0,2)<CR>
xnoremap <silent><Plug>(easymotion-bd-n) <Esc>:<C-u>call EasyMotion#Search(1,2)<CR>
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
    \      :<C-u>call EasyMotion#DotRepeat(0)<CR>
xnoremap <silent><Plug>(easymotion-dotrepeat)
    \ <Esc>:<C-u>call EasyMotion#DotRepeat(1)<CR>
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

" -- Special Motion {{{
onoremap <silent> <Plug>(easymotion-special-l)       :<C-u>call EasyMotion#SelectLines()<CR>
xnoremap <silent> <Plug>(easymotion-special-l)  <Esc>:<C-u>call EasyMotion#SelectLines()<CR>

onoremap <silent> <Plug>(easymotion-special-p)       :<C-u>call EasyMotion#SelectPhrase()<CR>
xnoremap <silent> <Plug>(easymotion-special-p)  <Esc>:<C-u>call EasyMotion#SelectPhrase()<CR>

nnoremap <silent> <Plug>(easymotion-special-ly)      :<C-u>call EasyMotion#SelectLinesYank()<CR>
nnoremap <silent> <Plug>(easymotion-special-ld)      :<C-u>call EasyMotion#SelectLinesDelete()<CR>
nnoremap <silent> <Plug>(easymotion-special-py)      :<C-u>call EasyMotion#SelectPhraseYank()<CR>
nnoremap <silent> <Plug>(easymotion-special-pd)      :<C-u>call EasyMotion#SelectPhraseDelete()<CR>
"}}}

" }}}

" == Default key mapping {{{
if g:EasyMotion_do_mapping == 1 || g:EasyMotion_do_special_mapping == 1
    " Prepare Prefix: {{{
    if exists('g:EasyMotion_leader_key')
        exec 'map ' . g:EasyMotion_leader_key . ' <Plug>(easymotion-prefix)'
    else
        if !hasmapto('<Plug>(easymotion-prefix)')
            map <Leader><Leader> <Plug>(easymotion-prefix)
        endif
    endif
    "}}}

    " Default Mapping:
    call EasyMotion#init#InitMappings({
        \   'f' : { 'name': 'S'      , 'dir': 0 }
        \ , 'F' : { 'name': 'S'      , 'dir': 1 }
        \ , 's' : { 'name': 'S'      , 'dir': 2 }
        \ , 'S' : { 'name': 'WB'     , 'dir': 2 }
        \ , 't' : { 'name': 'T'      , 'dir': 0 }
        \ , 'T' : { 'name': 'T'      , 'dir': 1 }
        \ , 'w' : { 'name': 'WB'     , 'dir': 0 }
        \ , 'W' : { 'name': 'WBW'    , 'dir': 0 }
        \ , 'b' : { 'name': 'WB'     , 'dir': 1 }
        \ , 'B' : { 'name': 'WBW'    , 'dir': 1 }
        \ , 'e' : { 'name': 'E'      , 'dir': 0 }
        \ , 'E' : { 'name': 'EW'     , 'dir': 0 }
        \ , 'ge': { 'name': 'E'      , 'dir': 1 }
        \ , 'gE': { 'name': 'EW'     , 'dir': 1 }
        \ , 'j' : { 'name': 'JK'     , 'dir': 0 }
        \ , 'k' : { 'name': 'JK'     , 'dir': 1 }
        \ , 'n' : { 'name': 'Search' , 'dir': 0 }
        \ , 'N' : { 'name': 'Search' , 'dir': 1 }
        \ }, g:EasyMotion_do_mapping)

    " Special Mapping For Default: {{{
    call EasyMotion#init#InitSpecialMappings({
        \   'l' : { 'name': 'SelectLines'}
        \ , 'p' : { 'name': 'SelectPhrase'}
        \ }, g:EasyMotion_do_special_mapping)
    " }}}
endif "}}}

" == Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" vim: fdm=marker:et:ts=4:sw=4:sts=4
