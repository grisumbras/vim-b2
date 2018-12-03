" Only load this indent file when no other was loaded.
if exists("b:did_indent") | finish | endif
let b:did_indent = 1

setlocal nolisp
let b:undo_indent = ' | setlocal lisp<'

setlocal smartindent
let b:undo_indent = ' | setlocal smartindent<'

setlocal nocindent
let b:undo_indent = ' | setlocal cindent<'
