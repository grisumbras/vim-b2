" storing options to restore later
let s:cpo_save = &cpo
set cpo&vim


" Take all directories of the BOOST_BUILD_PATH environment variable
" and add them to the path option.
function b2#updatePath()
  let sep = (has("win32") || has("win64")) ? ';' : ':'
  let dirs = []

  if exists('$BOOST_ROOT')
    let dirs += $BOOST_ROOT
  endif

  let rel_location = fnamemodify(system('which b2'), ':p:h:h')
  if len(rel_location)
    let dirs += globpath(rel_location, 'share/boost-build', 0, 1)
  endif

  let dirs += split($BOOST_BUILD_PATH, sep)

  let merged_dirs = join(dirs, ',')
  let init_modules = globpath(merged_dirs, 'boost-build.jam', 0, 1)
  if len(init_modules)
    let init_dir = globpath(fnamemodify(init_modules[0], ':p:h'), 'src')
    if len(init_dir)
      let dirs += globpath(init_dir, 'build', 0, 1)
      let dirs += globpath(init_dir, 'contrib', 0, 1)
      let dirs += globpath(init_dir, 'kernel', 0, 1)
      let dirs += globpath(init_dir, 'options', 0, 1)
      let dirs += globpath(init_dir, 'tools', 0, 1)
      let dirs += globpath(init_dir, 'util', 0, 1)
    endif
  endif

  execute "setlocal path+=" . join(dirs, ',')
endfunction

function b2#help(count, count1, mods, ...) abort
  if a:0 > 2
    call s:error('too many arguments')
    return
  elseif a:0 == 0
    let ref = expand('<cWORD>')
    if empty(ref)
      call s:error('no identifier under cursor')
      return
    endif
    let fullref = ref
  else
    let ref = a:1
    let fullref = expand('<cWORD>')
  endif

  let index = match(fullref, ref)
  if index > 0
    let ref = fullref[0: index + len(ref)]
  endif

  if exists('b:b2_help_context')
    let ref = b:b2_help_context.'.'.ref
  endif

  let bufname = 'b2 --help '.ref

  try
    set eventignore+=BufReadCmd
    if a:mods !~# 'tab' && s:find_b2help()
      execute 'silent edit' fnameescape(bufname)
    else
      execute 'silent' a:mods 'split' fnameescape(bufname)
    endif
  finally
    set eventignore-=BufReadCmd
  endtry

  try
    let page = s:get_page(ref)
  catch
    " a new window was opened
    if a:mods =~# 'tab' || !s:find_b2help() | close | endif
    call s:error(v:exception)
    return
  endtry

  call s:put_page(page, ref)
endfunction


function! s:error(msg) abort
  redraw
  echohl ErrorMsg
  echon 'b2.vim: ' a:msg
  echohl None
endfunction


function! s:get_page(ref) abort
  return s:system(['b2', '--help', a:ref])
endfunction


function! s:put_page(page, ref) abort
  setlocal modifiable
  setlocal readonly
  silent keepjumps %delete _
  silent put =a:page
  " Remove all backspaced/escape characters.
  execute 'silent keeppatterns keepjumps %substitute,.\b\|\e\[\d\+m,,e'.
    \ (&gdefault?'':'g')
  while getline(1) =~# '^\s*$'
    silent keepjumps 1delete _
  endwhile
  setlocal filetype=b2help
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal nomodified
  setlocal bufhidden=hide
  setlocal nonumber
  setlocal norelativenumber
  setlocal foldcolumn=0
  setlocal colorcolumn=0
  setlocal nolist
  setlocal keywordprg=:B2Help
  command! -bar -range=0 -buffer -nargs=* B2Help
    \ call b2#help(v:count, v:count1, <q-mods>, <f-args>)
  let b:b2_help_context = a:ref

  setlocal nomodifiable
endfunction


" Run a system command and timeout after 30 seconds.
function! s:system(cmd, ...) abort
  let opts = {
        \ 'stdout': '',
        \ 'stderr': '',
        \ 'exit_code': 0,
        \ 'on_stdout': function('s:system_handler'),
        \ 'on_stderr': function('s:system_handler'),
        \ 'on_exit': function('s:system_handler'),
        \ }
  let jobid = jobstart(a:cmd, opts)

  if jobid < 1
    throw printf('command error %d: %s', jobid, join(a:cmd))
  endif

  let res = jobwait([jobid], 30000)
  if res[0] == -1
    try
      call jobstop(jobid)
      throw printf('command timed out: %s', join(a:cmd))
    catch /^Vim(call):E900:/
    endtry
  elseif res[0] == -2
    throw printf('command interrupted: %s', join(a:cmd))
  endif
  if opts.exit_code != 0
    throw printf("command error (%d) %s: %s", jobid, join(a:cmd),
      \ substitute(opts.stderr, '\_s\+$', '', &gdefault ? '' : 'g'))
  endif

  return opts.stdout
endfunction


" Handler for s:system() function.
function! s:system_handler(jobid, data, event) dict abort
  if a:event is# 'stdout' || a:event is# 'stderr'
    let self[a:event] .= join(a:data, "\n")
  else
    let self.exit_code = a:data
  endif
endfunction


function! s:find_b2help() abort
  if &filetype ==# 'b2help'
    return 1
  elseif winnr('$') ==# 1
    return 0
  endif
  let thiswin = winnr()
  while 1
    wincmd w
    if &filetype ==# 'b2help'
      return 1
    elseif thiswin ==# winnr()
      return 0
    endif
  endwhile
endfunction


" restoring options
let &cpo = s:cpo_save
unlet s:cpo_save
