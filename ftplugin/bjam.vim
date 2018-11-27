if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let &l:comments = 's1:#|,mb:|,ex:|#,:#,n:>,fb:-'
let &l:commentstring = '#%s'
let b:match_words = '^#|:^\s*|#'
setlocal formatoptions+=ron1j
setlocal suffixesadd=.jam
compiler b2
