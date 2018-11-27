if exists("b:current_syntax")
  finish
endif

sy clear
sy case match
setlocal iskeyword+=-
setlocal iskeyword+=,

" Comments
sy keyword bjamTodo TODO FIXME XXX contained
sy match bjamLineComment '#.*' contains=@Spell,bjamTodo
sy match bjamCommentSkip '^\s*|\($\|\s\+\)'
sy region bjamComment start='#|' end='|#' contains=@Spell,bjamTodo
sy sync ccomment bjamComment

" Strings
sy region bjamString matchgroup=bjamStringSpecial start='"' end='"' skip='\\"' contains=@bjamStringElement
sy cluster bjamStringElement contains=bjamStringSpecial,bjamVariable
sy match bjamStringSpecial '\\.' contained

sy match bjamRuleDefintion 'rule' nextgroup=bjamRuleName skipwhite
sy match bjamRuleName '\S\+' contained nextgroup=bjamArgStart skipwhite
sy match bjamArgStart "(" contained nextgroup=bjamArgName skipwhite
sy match bjamArgName '\S\+' contained nextgroup=bjamArgSep
sy match bjamArgSep '\:+' contained nextgroup=bjamArgSep

" sy keyword bjamKeyword include rule actions bind updated together ignore
" sy keyword bjamKeyword quietly piecemeal existing
"
" sy keyword bjamConditional if else switch
"
" sy keyword bjamLabel case
"
" sy keyword bjamRepeat while for
"
" sy keyword bjamOperator in on new
"
" sy keyword bjamStatement return break continue default
"
" sy keyword bjamLocal local
"
" sy keyword bjamScope module class
"
" sy keyword bjamBuiltin Always ALWAYS Depends DEPENDS echo Echo exit EXIT Glob
" sy keyword bjamBuiltin GLOB GLOB-RECURSIVELY Includes INCLUDES REBUILDS
" sy keyword bjamBuiltin SPLIT_BY_CHARACTERS NoCare NOTIME NotFile NOTFILE
" sy keyword bjamBuiltin NoUpdate NOUPDATE Temporary TEMPORARY ISFILE HdrMacro
" sy keyword bjamBuiltin HDRMACRO FAIL_EXPECTED RMOLD UPDATE subst SUBST
" sy keyword bjamBuiltin RULENAMES VARNAMES DELETE_MODULE IMPORT EXPORT
" sy keyword bjamBuiltin CALLER_MODULE BACKTRACE PWD IMPORT_MODULE
" sy keyword bjamBuiltin IMPORTED_MODULES INSTANCE SORT NORMALIZE_PATH CALC
" sy keyword bjamBuiltin NATIVE_RULE W32_GETREG W32_GETREGNAMES SHELL COMMAND
" sy keyword bjamBuiltin MD5 FILE_OPEN PAD PRECIOUS SELF_PATH MAKEDIR READLINK
" sy keyword bjamBuiltin GLOB_ARCHIVE import using peek poke record-binding
" sy keyword bjamBuiltin project use-project build-project explicit
" sy keyword bjamBuiltin check-target-builds glob glob-tree always constant
" sy keyword bjamBuiltin path-constant
"
" sy keyword bjamMainTarget exe lib alias obj explicit install make notfile
" sy keyword bjamMainTarget unit-test compile compile-fail link link-fail run
" sy keyword bjamMainTarget run-fail
"
" sy match bjamModifier ":" contained
" sy region bjamVariable start='\$(' end=')' contains=bjamVariable,bjamModifier
" sy match bjamGrist '<[^>]*>'
"
" " " Errors
" " " semicolons can't be preceded or followed by anything but whitespace
" " sy match jamSemiError "[^ \t];"hs=s+1
" " sy match jamSemiError ";[^ \t]"he=e-1
" " " colons must either have whitespace on both sides (separating clauses of
" " " rules) or on neither side (e.g. <variant>release:<define>NDEBUG)
" " sy match jamColonError "[^ \t]:[ \t]"hs=s+2
" " sy match jamColonError "[ \t]:[^ \t]"he=e-2
" "
" sy region bjamBracedFold start="{" end="}" transparent fold
" " sy region bjamCommentFold start="#|" end="|#" transparent fold
" sy sync fromstart
"
"
" "   hi link jamSemiError jamError
" "   hi link jamColonError jamError

hi def link bjamComment Comment
hi def link bjamLineComment Comment
hi def link bjamTodo Todo
hi def link bjamString String
hi def link bjamStringSpecial Special
hi def link bjamRuleDefintion Statement
hi def link bjamRuleName Function
" hi def link bjamKeyword Keyword
" hi def link bjamConditional Conditional
" hi def link bjamLabel Label
" hi def link bjamRepeat Repeat
" hi def link bjamBuiltin Function
" hi def link bjamMainTarget Type
" hi def link bjamOperator Operator
" hi def link bjamStatement Statement
" hi def link bjamVariable Identifier
" hi def link bjamGrist Identifier
" hi def link bjamLocal StorageClass
" hi def link bjamScope Structure
" hi def link bjamModifier Delimiter
"   hi link jamRule Keyword
"   hi link jamPseudo Keyword
"
"   hi link jamError Error
" endif

let b:current_syntax = "bjam"

" *Constant	any constant
"  Function	function name (also: methods for classes)
"  Exception	try, catch, throw
"  Include	preprocessor #include
"  Define		preprocessor #define
"  Macro		same as Define
"  PreCondit	preprocessor #if, #else, #endif, etc.
"  Typedef	A typedef
" *Special	any special symbol
"  SpecialChar	special character in a constant
"  Tag		you can use CTRL-] on this
"  Delimiter	character that needs attention
"  SpecialComment	special things inside a comment
"  Debug		debugging statements
" *Underlined	text that stands out, HTML links
" *Ignore		left blank, hidden  |hl-Ignore|
" *Error		any erroneous construct
" 		keywords TODO FIXME and XXX
