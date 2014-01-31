" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

function! EasyMotion#init#InitHL(group, colors) " {{{
    let group_default = a:group . 'Default'

    " Prepare highlighting variables
    let guihl = printf('guibg=%s guifg=%s gui=%s', a:colors.gui[0], a:colors.gui[1], a:colors.gui[2])
    if !exists('g:CSApprox_loaded')
        let ctermhl = &t_Co == 256
            \ ? printf('ctermbg=%s ctermfg=%s cterm=%s', a:colors.cterm256[0], a:colors.cterm256[1], a:colors.cterm256[2])
            \ : printf('ctermbg=%s ctermfg=%s cterm=%s', a:colors.cterm[0], a:colors.cterm[1], a:colors.cterm[2])
    else
        let ctermhl = ''
    endif

    " Create default highlighting group
    execute printf('hi default %s %s %s', group_default, guihl, ctermhl)

    " Check if the hl group exists
    if hlexists(a:group)
        redir => hlstatus | exec 'silent hi ' . a:group | redir END

        " Return if the group isn't cleared
        if hlstatus !~ 'cleared'
            return
        endif
    endif

    " No colors are defined for this group, link to defaults
    execute printf('hi default link %s %s', a:group, group_default)
endfunction " }}}

function! EasyMotion#init#InitMappings(motions, do_mapping) "{{{
    for [motion, fn] in items(a:motions)
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

" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" vim: fdm=marker:et:ts=4:sw=4:sts=4
