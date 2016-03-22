let s:vital_name = expand('<sfile>:t:r')
let s:base_dir = expand('<sfile>:h')
let s:loaded = {}

" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif

function! vital#{s:vital_name}#of() abort
  return s:new(s:vital_name)
endfunction

let s:Vital = {}

function! s:new(vital_name) abort
  let base = deepcopy(s:Vital)
  let base.vital_name = a:vital_name
  return base
endfunction

function! s:vital_files() abort dict
  if !exists('s:vital_files')
    let s:vital_files =
    \   map(s:_self_vital_files(), 'fnamemodify(v:val, ":p:gs?[\\\\/]?/?")')
  endif
  return copy(s:vital_files)
endfunction
let s:Vital.vital_files = s:_function('s:vital_files')

function! s:import(name, ...) abort dict
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
  let module = self._import(a:name)
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
let s:Vital.import = s:_function('s:import')

function! s:load(...) abort dict
  for arg in a:000
    let [name; as] = type(arg) == type([]) ? arg[: 1] : [arg, arg]
    let target = split(join(as, ''), '\W\+')
    let dict = self
    let dict_type = type({})
    while !empty(target)
      let ns = remove(target, 0)
      if !has_key(dict, ns)
        let dict[ns] = {}
      endif
      if type(dict[ns]) == dict_type
        let dict = dict[ns]
      else
        unlet dict
        break
      endif
    endwhile
    if exists('dict')
      call extend(dict, self._import(name))
    endif
    unlet arg
  endfor
  return self
endfunction
let s:Vital.load = s:_function('s:load')

function! s:unload() abort dict
  let s:loaded = {}
  unlet! s:vital_files
endfunction
let s:Vital.unload = s:_function('s:unload')

function! s:exists(name) abort dict
  return exists(printf('*vital#_%s#%s#import', self.vital_name, substitute(a:name, '\.', '#', 'g')))
endfunction
let s:Vital.exists = s:_function('s:exists')

function! s:search(pattern) abort dict
  let paths = s:_extract_files(a:pattern, s:vital_files())
  let modules = sort(map(paths, 's:_file2module(v:val)'))
  return s:_uniq(modules)
endfunction
let s:Vital.search = s:_function('s:search')

function! s:_self_vital_files() abort
  let base = s:base_dir . '/*/**/*.vim'
  return split(glob(base, 1), "\n")
endfunction

function! s:_extract_files(pattern, files) abort
  let tr = {'.': '/', '*': '[^/]*', '**': '.*'}
  let target = substitute(a:pattern, '\.\|\*\*\?', '\=tr[submatch(0)]', 'g')
  let regexp = printf('autoload/vital/[^/]\+/%s.vim$', target)
  return filter(a:files, 'v:val =~# regexp')
endfunction

function! s:_file2module(file) abort
  let filename = fnamemodify(a:file, ':p:gs?[\\/]?/?')
  let tail = matchstr(filename, 'autoload/vital/_\w\+/\zs.*\ze\.vim$')
  return join(split(tail, '[\\/]\+'), '.')
endfunction

" @param {string} name e.g. Data.List
function! s:_import(name) abort dict
  if has_key(s:loaded, a:name)
    return copy(s:loaded[a:name])
  endif
  try
    let module = vital#_{self.vital_name}#{substitute(a:name, '\.', '#', 'g')}#import()
  catch /E117: Unknown function:/
    throw 'vital: revitalizer: module not found: ' . a:name
  endtry
  if has_key(module, '_vital_created')
    call module._vital_created(module)
  endif
  let export_module = filter(copy(module), 'v:key =~# "^\\a"')
  " Cache module before calling module.vital_loaded() to avoid cyclic
  " dependences but remove the cache if module._vital_loaded() fails.
  let s:loaded[a:name] = export_module
  if has_key(module, '_vital_loaded')
    try
      call module._vital_loaded(self)
    catch
      unlet s:loaded[a:name]
      throw 'vital: fail to call ._vital_loaded(): ' . v:exception
    endtry
  endif
  return copy(s:loaded[a:name])
endfunction
let s:Vital._import = function('s:_import')

if exists('*uniq')
  function! s:_uniq(list) abort
    return uniq(a:list)
  endfunction
else
  function! s:_uniq(list) abort
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
