" guard from multiple inclusion
if exists('b:did_ftplugin') | finish | endif
let b:did_ftplugin = 1
let b:undo_ftplugin = ''

" storing options to restore later
let s:cpo_save = &cpo
set cpo&vim

" block comments with #| |#
" line comments with #
let &l:comments = 's1:#|,mb:|,ex:|#,:#,n:>,fb:-'
let b:undo_ftplugin .= ' | setlocal comments<'

" match block comment markers for jumping via %
if exists("loaded_matchit")
  let b:match_words = '^#|:^\s*|#'
  let b:undo_ftplugin .= ' | unlet b:match_words'

  let b:match_skip = 's:comment\|string\|character\|special'
  let b:undo_ftplugin .= ' | unlet b:match_skip'
endif

setlocal foldmarker={,}
let b:undo_ftplugin .= ' | setlocal foldmarker<'

" folded lines appear as # <first line of fold>
let &l:commentstring = '#%s'
let b:undo_ftplugin .= ' | setlocal commentstring<'

" handling file inclusion
let &l:include='^\s*\(using\|import\)\>'
let b:undo_ftplugin .= ' | setlocal include<'

" adds .jam suffix to searched files
setlocal suffixesadd=.jam
let b:undo_ftplugin .= ' | setlocal suffixesadd<'

" partial handling of varible and rule definition search
let &l:define='^\s*\(rule\|local\(\s\+rule\)\?\)\>'
let b:undo_ftplugin .= ' | setlocal define<'

" update path to include all directories used by b2
call b2#updatePath()
let b:undo_ftplugin .= ' | setlocal path<'

" opening a help window for some standard b2 modules and rules (b2 --help)
setlocal keywordprg=:B2Help
let b:undo_ftplugin .= ' | setlocal keywordprg<'
command! -bar -range=0 -buffer -nargs=*
      \ B2Help call b2#help(v:count, v:count1, <q-mods>, <f-args>)
" -complete=customlist,man#complete
let b:undo_ftplugin .= ' | delcommand B2Help'

" add some characters to the list of characters available in identifiers
setlocal iskeyword=@,48-57,_,192-255,-,\,,@-@
let b:undo_ftplugin .= ' | setlocal iskeyword<'

" formatting options
setlocal formatoptions+=qron1j

" restoring options
let &cpo = s:cpo_save
unlet s:cpo_save
