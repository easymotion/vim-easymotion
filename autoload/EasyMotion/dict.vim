
function! EasyMotion#dict#convert(input, dict)
    if a:dict =~ '^zh'
        let pat = join(map(split(a:input, '\zs'),
                    \ 'get(g:EasyMotion#dict#zh#utf8#' . split(a:dict, '-')[1] . ', v:val, v:val)'), '')
        if !empty(pat)
            return a:input . '\|' . pat
        endif
    endif

    return a:input
endfunction
