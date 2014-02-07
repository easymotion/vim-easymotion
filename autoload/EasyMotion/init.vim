" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}

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
