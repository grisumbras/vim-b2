if exists("b:current_syntax") | finish | endif

sy clear
sy case match
sy sync minlines=100

" various keywords
sy keyword bjamRepeat for while
sy keyword bjamConditional if switch else
sy keyword bjamStatement return include continue break
sy keyword bjamKeyword rule actions in on default case bind existsing ignore
sy keyword bjamKeyword piecemeal quietly together
sy keyword bjamStructure class module
sy keyword bjamScopeKeyword local

" mark trailing and starting colon, semicolon and square bracket as errors,
" since usually they indeed are
sy match bjamFrontError '\(^\|\s\)\zs[:;\[]\S'
sy match bjamBackError '\S[:;\]]\ze\($\|\s\)'

" include Asciidoc syntax as a cluster
syn include @bjamAsciidoc syntax/asciidoc.vim


" Variable expansion
" variable expansions are enclosed in $() and may contain other variable
" expansions and may contain a subscript modifier or a keyword modifier at the
" end
sy region bjamVariableExpansion start='\$(' end=')' keepend extend contains=bjamVariableExpansion,bjamModifier,bjamRangeStart

" keyword modifiers start with a colon and may contain variable expansions,
" single-character modifiers or a single assignment to a modifier
sy region bjamModifier matchgroup=bjamDelimiter start=':' end='\ze)' keepend extend contained contains=bjamVariableExpansion,bjamModifierMarker,bjamModifierAssignment
sy match bjamModifierMarker "[BSMDPGULTWREJ]" contained
" assignment part in particular may contain any list of strings
sy region bjamModifierAssignment matchgroup=Special start='=' end='\ze)' keepend contained contains=@bjamExpression


sy region bjamRangeStart contained keepend extend matchgroup=bjamDelimiter start='\[' end='\]\|\(\ze-\)' contains=bjamVariableExpansion,bjamNumber nextgroup=bjamRangeEnd
sy region bjamRangeEnd contained keepend extend matchgroup=bjamDelimiter start='-' end='\]' contains=bjamVariableExpansion,bjamNumber
sy match bjamNumber '\d\+' contained

" string grists are enclosed in angle brackets and allow escaped symbols and
" variable expansion
sy match bjamGrist '<[^>]\+>' contains=@bjamStringPart


" rule's parameter list is enclosed in parentheses
sy region bjamRuleParameters matchgroup=bjamDelimiter start='\(^\|\s\)\zs(\ze\($\|\s\)' end='\(^\|\s\)\zs)\ze\($\|\s\)' contains=bjamListSeparator,bjamArgumentQuantifier,@bjamExpression
sy match bjamArgumentQuantifier '\(^\|\s\)\zs[?*+]\ze\($\|\s\)'


" Rule expansion
" rule expansion is enclosed in square brackets
sy region bjamRuleExpansion keepend extend skipwhite matchgroup=bjamDelimiter start='\(^\|\s\)\[\ze\($\|\s\)' end='\(^\|\s\)\]\ze\($\|\s\)' contains=@bjamExpression,bjamListSeparator
sy match bjamListSeparator '\(^\|\s\)\zs:\ze\($\|\s\)'


" Strings
" highlight escaped characters
sy match bjamEscapedChar '\\.'
" strings are enclosed in double quotes and allow escaped characters and
" variable expansion inside; quotes themselves are highlighted the same as
" escaped characters; extend option is added in order to not preemptively
" enclosing regions
sy region bjamString extend matchgroup=bjamEscapedChar start='"' end='"' contains=@bjamStringPart


" Comments
sy keyword bjamTodo TODO FIXME XXX contained
sy match bjamLineComment '#.*' contains=@Spell,bjamTodo
sy region bjamBlockComment start='#|' end='|#' contains=@Spell,bjamTodo
" allow Asciidoc highlight inside documentation tags
sy region bjamDocComment start='#|\s*tag::doc\[\]' end='|#\s*#\s*end::doc\[\]' keepend contains=@Spell,@bjamAsciidoc


sy cluster bjamAnyComment contains=bjamLineComment,bjamBlockComment,bjamDocComment
sy cluster bjamStringPart contains=bjamVariableExpansion,bjamEscapedChar
sy cluster bjamExpression contains=bjamString,bjamRuleExpansion,bjamGrist,@bjamStringPart,@bjamAnyComment

hi def link bjamDelimiter Delimiter
hi def link bjamListSeparator Delimiter
hi def link bjamArgumentQuantifier Delimiter
hi def link bjamEscapedChar Special

hi def link bjamRepeat Repeat
hi def link bjamConditional Conditional
hi def link bjamKeyword Keyword
hi def link bjamStructure Structure
hi def link bjamStatement Statement
hi def link bjamScopeKeyword StorageClass

hi def link bjamVariableExpansion Identifier

hi def link bjamGrist Type

hi def link bjamRuleRef Function
hi def link bjamActionName Function

hi def link bjamModifierMarker Constant
hi def link bjamNumber Number
hi def link bjamModifier Error
hi def link bjamRangeStart Error
hi def link bjamRangeEnd Error

hi def link bjamInclude Include

hi def link bjamString String

hi def link bjamLineComment Comment
hi def link bjamBlockComment Comment
hi def link bjamDocComment Comment
hi def link bjamTodo Todo

hi def link bjamFrontError Error
hi def link bjamBackError Error
hi def link bjamJump Error

sy region bjamBracedFold start='{' end='}' transparent fold


let b:current_syntax = "bjam"
