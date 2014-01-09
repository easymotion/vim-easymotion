" EasyMotion - Vim motions on speed!
"
" Author: Kim Silkebækken <kim.silkebaekken+vim@gmail.com>
" Source repository: https://github.com/Lokaltog/vim-easymotion

" Script initialization {{{
	if exists('g:EasyMotion_loaded') || &compatible || version < 702
		finish
	endif

	let g:EasyMotion_loaded = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}
" Default configuration {{{
	" Default options {{{
		call EasyMotion#init#InitOptions({
		\   'leader_key'            : '<Leader><Leader>'
		\ , 'keys'                  : 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
		\ , 'do_shade'              : 1
		\ , 'do_mapping'            : 1
		\ , 'do_special_mapping'    : 0
		\ , 'grouping'              : 1
		\ , 'startofline'           : 1
		\ , 'smartcase'             : 0
		\ , 'skipfoldedline'        : 1
		\ , 'use_migemo'            : 0
		\ , 'use_upper'             : 0
		\
		\ , 'hl_group_target'         : 'EasyMotionTarget'
		\ , 'hl2_first_group_target'  : 'EasyMotionTarget2First'
		\ , 'hl2_second_group_target' : 'EasyMotionTarget2Second'
		\ , 'hl_group_shade'          : 'EasyMotionShade'
		\ , 'hl_line_group_shade'     : 'EasyMotionShadeLine'
		\ })
	" }}}
	" Default highlighting {{{
		let s:target_hl_defaults = {
		\   'gui'     : ['NONE', '#ff0000' , 'bold']
		\ , 'cterm256': ['NONE', '196'     , 'bold']
		\ , 'cterm'   : ['NONE', 'red'     , 'bold']
		\ }

		let s:target_hl2_first_defaults = {
		\   'gui'     : ['NONE', '#ffb400' , 'bold']
		\ , 'cterm256': ['NONE', '11'      , 'bold']
		\ , 'cterm'   : ['NONE', '11'      , 'bold']
		\ }

		let s:target_hl2_second_defaults = {
		\   'gui'     : ['NONE', '#b98300' , 'bold']
		\ , 'cterm256': ['NONE', '3'       , 'bold']
		\ , 'cterm'   : ['NONE', '3'       , 'bold']
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
	" Default key mapping {{{
		call EasyMotion#init#InitMappings({
		\   'f' : { 'name': 'F'  , 'dir': 0 }
		\ , 'F' : { 'name': 'F'  , 'dir': 1 }
		\ , 's' : { 'name': 'S'  , 'dir': 2 }
		\ , 'S' : { 'name': 'WB' , 'dir': 2 }
		\ , 't' : { 'name': 'T'  , 'dir': 0 }
		\ , 'T' : { 'name': 'T'  , 'dir': 1 }
		\ , 'w' : { 'name': 'WB' , 'dir': 0 }
		\ , 'W' : { 'name': 'WBW', 'dir': 0 }
		\ , 'b' : { 'name': 'WB' , 'dir': 1 }
		\ , 'B' : { 'name': 'WBW', 'dir': 1 }
		\ , 'e' : { 'name': 'E'  , 'dir': 0 }
		\ , 'E' : { 'name': 'EW' , 'dir': 0 }
		\ , 'ge': { 'name': 'E'  , 'dir': 1 }
		\ , 'gE': { 'name': 'EW' , 'dir': 1 }
		\ , 'j' : { 'name': 'JK' , 'dir': 0 }
		\ , 'k' : { 'name': 'JK' , 'dir': 1 }
		\ , 'n' : { 'name': 'Search' , 'dir': 0 }
		\ , 'N' : { 'name': 'Search' , 'dir': 1 }
		\ }, g:EasyMotion_do_mapping)
	" }}}
	" Special mapping for other functions {{{
		call EasyMotion#init#InitSpecialMappings({
		\   'l' : { 'name': 'SelectLines'}
		\ , 'p' : { 'name': 'SelectPhrase'}
		\ }, g:EasyMotion_do_special_mapping)
	" }}}
	" Prepare more key mapping {{{
		" Note: bd is short for bidirectional
		"       l is short for (within) line
		call EasyMotion#init#InitMappings({
		\   'bd-w' : { 'name': 'WB'  , 'dir': 2 }
		\ , 'bd-W' : { 'name': 'WBW'  , 'dir': 2 }
		\ , 'bd-e' : { 'name': 'E'  , 'dir': 2 }
		\ , 'bd-E' : { 'name': 'EW'  , 'dir': 2 }
		\ , 'bd-n' : { 'name': 'Search'  , 'dir': 2 }
		\ , 'bd-jk' : { 'name': 'JK'  , 'dir': 2 }
		\
		\ , 'jumptoanywhere' : { 'name': 'JumpToAnywhere'  , 'dir': 2 }
		\ , 'lineforward' : { 'name': 'LineAnywhere'  , 'dir': 0 }
		\ , 'linebackward' : { 'name': 'LineAnywhere'  , 'dir': 1 }
		\ , 'lineanywhere' : { 'name': 'LineAnywhere'  , 'dir': 2 }
		\
		\ , 'sl' : { 'name': 'SL'  , 'dir': 2 }
		\ , 'fl' : { 'name': 'SL'  , 'dir': 0 }
		\ , 'Fl' : { 'name': 'SL'  , 'dir': 1 }
		\ , 'tl' : { 'name': 'TL'  , 'dir': 0 }
		\ , 'Tl' : { 'name': 'TL'  , 'dir': 1 }
		\ , 'wl' : { 'name': 'WBL'  , 'dir': 0 }
		\ , 'bl' : { 'name': 'WBL'  , 'dir': 1 }
		\ , 'bd-wl' : { 'name': 'WBL'  , 'dir': 2 }
		\ , 'el' : { 'name': 'EL'  , 'dir': 0 }
		\ , 'gel' : { 'name': 'EL'  , 'dir': 1 }
		\ , 'bd-el' : { 'name': 'EL'  , 'dir': 2 }
		\
		\ , 'repeat' : { 'name': 'Repeat'  , 'dir': 0 }
		\ }, 0) " Prepare <Plug> but don't map by default.
	" }}}
" }}}
" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}

" vim: fdm=marker:noet:ts=4:sw=4:sts=4
