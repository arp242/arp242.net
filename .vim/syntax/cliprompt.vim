if exists('b:current_syntax') | finish | endif
let s:cpo_save = &cpo
set cpo&vim

" Only highlight if followed by output, so not this:
"
"     % foo
"     % foo
"
" But do deal with line continuations:
"
"     % GOOS=linux GOARCH=arm CGO_ENABLED=1 CC=armv7l-linux-musleabihf-gcc \
"         go build -ldflags='-extldflags=-static' -o test.arm ./test.go
"
" syn match cliCommand  /^\s*[$%] .*\ze\n[^$%]/
" syn match cliCommand  /^\s*[$%] \%(.* \\\n\)\+.*$/
syn match cliPrompt  nextgroup=cliInput contains=cliComment /\v^(\w+)?\% / 
syn match cliInput   contained          contains=cliComment /.*$/          
syn match cliComment                                        / #.*/

hi def link cliPrompt ModeMsg
hi def link cliInput  Question

hi def link cliComment Comment


" TODO: the third one here still gets highlighted:
"
"     $ file test.dynamic | tr , '\n'
"     $ file test.dynamic | tr , '\n'
"     $ file test.dynamic | tr , '\n' \
"       asd
"     $ file test.dynamic | tr , '\n'

hi def link cliCommand ModeMsg

let b:current_syntax = 'cliprompt'
let &cpo = s:cpo_save
unlet s:cpo_save

