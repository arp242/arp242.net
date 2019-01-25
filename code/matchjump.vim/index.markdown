---
layout: code
title: "matchjump.vim"
link: "matchjump.vim"
last_version: "master"
redirect: "https://github.com/Carpetsmoker/matchjump.vim"
---

Jump to next/previous matches added with `matchaddpos()`.

It just defines one function: `MatchJump(group, dir)`. You're expected to
map that yourself. For example to a command:

    command! GoNextId :call MatchJump('goSameId', 'next')
    command! GoPrevId :call MatchJump('goSameId', 'prev')

Or key:

    nnoremap <Leader>n :call MatchJump('goSameId', 'next')<CR>
    nnoremap <Leader>N :call MatchJump('goSameId', 'prev')<CR>
