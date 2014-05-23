let s:self_version = expand('<sfile>:t:r')

" Note: The extra argument to globpath() was added in Patch 7.2.051.
let s:globpath_third_arg = v:version > 702 || v:version == 702 && has('patch51')

let s:loaded = {}

function! s:import(name, ...)
  let target = {}
  let functions = []
  for a in a:000
    if type(a) == type({})
      let target = a
    elseif type(a) == type([])
      let functions = a
    endif
    unlet a
  endfor
  let module = s:_import(a:name)
  if empty(functions)
    call extend(target, module, 'keep')
  else
    for f in functions
      if has_key(module, f) && !has_key(target, f)
        let target[f] = module[f]
      endif
    endfor
  endif
  return target
endfunction

function! s:load(...) dict
  for arg in a:000
    let [name; as] = type(arg) == type([]) ? arg[: 1] : [arg, arg]
    let target = split(join(as, ''), '\W\+')
    let dict = self
    while 1 <= len(target)
      let ns = remove(target, 0)
      if !has_key(dict, ns)
        let dict[ns] = {}
      endif
      if type(dict[ns]) == type({})
        let dict = dict[ns]
      else
        unlet dict
        break
      endif
    endwhile

    if exists('dict')
      call extend(dict, s:_import(name))
    endif
    unlet arg
  endfor
  return self
endfunction

function! s:unload()
  let s:loaded = {}
endfunction

function! s:exists(name)
  return s:_get_module_path(a:name) !=# ''
endfunction

function! s:search(pattern)
  let target = substitute(a:pattern, '\.', '/', 'g')
  let tailpath = printf('autoload/vital/%s/%s.vim', s:self_version, target)

  let paths = s:_runtime_files(tailpath)
  let modules = sort(map(paths, 's:_file2module(v:val)'))
  return s:_uniq(modules)
endfunction

function! s:_import(name)
  if type(a:name) == type(0)
    return s:_build_module(a:name)
  endif
  let path = s:_get_module_path(a:name)
  if path ==# ''
    throw 'vital: module not found: ' . a:name
  endif
  let sid = get(s:_scripts(), path, 0)
  if !sid
    try
      execute 'source' fnameescape(path)
    catch /^Vim\%((\a\+)\)\?:E484/
      throw 'vital: module not found: ' . a:name
    catch /^Vim\%((\a\+)\)\?:E127/
      " Ignore.
    endtry

    let sid = s:_scripts()[path]
  endif
  return s:_build_module(sid)
endfunction

function! s:_get_module_path(name)
  if s:_is_absolute_path(a:name) && filereadable(a:name)
    return s:_unify_path(a:name)
  endif
  if a:name ==# ''
    let tailpath = printf('autoload/vital/%s.vim', s:self_version)
  elseif a:name =~# '\v^\u\w*%(\.\u\w*)*$'
    let target = substitute(a:name, '\W\+', '/', 'g')
    let tailpath = printf('autoload/vital/%s/%s.vim', s:self_version, target)
  else
    throw 'vital: Invalid module name: ' . a:name
  endif

  let paths = s:_runtime_files(tailpath)
  call filter(paths, 'filereadable(v:val)')
  let path = get(paths, 0, '')
  return path !=# '' ? s:_unify_path(path) : ''
endfunction

function! s:_scripts()
  let scripts = {}
  for line in filter(split(s:_redir('scriptnames'), "\n"),
  \                  'stridx(v:val, s:self_version) > 0')
    let list = matchlist(line, '^\s*\(\d\+\):\s\+\(.\+\)\s*$')
    if !empty(list)
      let scripts[s:_unify_path(list[2])] = list[1] - 0
    endif
  endfor
  return scripts
endfunction

function! s:_file2module(file)
  let filename = s:_unify_path(a:file)
  let tail = matchstr(filename, 'autoload/vital/_\w\+/\zs.*\ze\.vim$')
  return join(split(tail, '[\\/]\+'), '.')
endfunction

if filereadable(expand('<sfile>:r') . '.VIM')
  function! s:_unify_path(path)
    " Note: On windows, vim can't expand path names from 8.3 formats.
    " So if getting full path via <sfile> and $HOME was set as 8.3 format,
    " vital load duplicated scripts. Below's :~ avoid this issue.
    return tolower(fnamemodify(resolve(fnamemodify(
    \              a:path, ':p:gs?[\\/]\+?/?')), ':~'))
  endfunction
else
  function! s:_unify_path(path)
    return resolve(fnamemodify(a:path, ':p:gs?[\\/]\+?/?'))
  endfunction
endif

if s:globpath_third_arg
  function! s:_runtime_files(path)
    return split(globpath(&runtimepath, a:path, 1), "\n")
  endfunction
else
  function! s:_runtime_files(path)
    return split(globpath(&runtimepath, a:path), "\n")
  endfunction
endif

" Copy from System.Filepath
if has('win16') || has('win32') || has('win64')
  function! s:_is_absolute_path(path)
    return a:path =~? '^[a-z]:[/\\]'
  endfunction
else
  function! s:_is_absolute_path(path)
    return a:path[0] ==# '/'
  endfunction
endif

function! s:_build_module(sid)
  if has_key(s:loaded, a:sid)
    return copy(s:loaded[a:sid])
  endif
  let functions = s:_get_functions(a:sid)

  let prefix = '<SNR>' . a:sid . '_'
  let module = {}
  for func in functions
    let module[func] = function(prefix . func)
  endfor
  if has_key(module, '_vital_loaded')
    let V = vital#{s:self_version}#new()
    if has_key(module, '_vital_depends')
      call call(V.load, module._vital_depends(), V)
    endif
    try
      call module._vital_loaded(V)
    catch
      " FIXME: Show an error message for debug.
    endtry
  endif
  if !get(g:, 'vital_debug', 0)
    call filter(module, 'v:key =~# "^\\a"')
  endif
  let s:loaded[a:sid] = module
  return copy(module)
endfunction

if exists('+regexpengine')
  function! s:_get_functions(sid)
    let funcs = s:_redir(printf("function /\\%%#=2^\<SNR>%d_", a:sid))
    let map_pat = '<SNR>' . a:sid . '_\zs\w\+'
    return map(split(funcs, "\n"), 'matchstr(v:val, map_pat)')
  endfunction
else
  function! s:_get_functions(sid)
    let prefix = '<SNR>' . a:sid . '_'
    let funcs = s:_redir('function')
    let filter_pat = '^\s*function ' . prefix
    let map_pat = prefix . '\zs\w\+'
    return map(filter(split(funcs, "\n"),
    \          'stridx(v:val, prefix) > 0 && v:val =~# filter_pat'),
    \          'matchstr(v:val, map_pat)')
  endfunction
endif

if exists('*uniq')
  function! s:_uniq(list)
    return uniq(a:list)
  endfunction
else
  function! s:_uniq(list)
    let i = len(a:list) - 1
    while 0 < i
      if a:list[i] ==# a:list[i - 1]
        call remove(a:list, i)
        let i -= 2
      else
        let i -= 1
      endif
    endwhile
    return a:list
  endfunction
endif

function! s:_redir(cmd)
  let [save_verbose, save_verbosefile] = [&verbose, &verbosefile]
  set verbose=0 verbosefile=
  redir => res
    silent! execute a:cmd
  redir END
  let [&verbose, &verbosefile] = [save_verbose, save_verbosefile]
  return res
endfunction

function! vital#{s:self_version}#new()
  return s:_import('')
endfunction
