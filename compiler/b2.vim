if exists('current_compiler') | finish | endif
let current_compiler = 'b2'

let s:cpo_save = &cpo
set cpo&vim

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet errorformat&

if exists('g:b2_makeprg_args')
  execute 'CompilerSet makeprg=b2\ '.escape(g:b2_makeprg_params, ' \|"').'\ $*'
else
  CompilerSet makeprg=b2\ $*
endif

let &cpo = s:cpo_save
unlet s:cpo_save
