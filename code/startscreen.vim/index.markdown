---
layout: code
title: startscreen.vim
link: startscreen.vim
extra_links: "[This plugin at www.vim.org](http://www.vim.org/scripts/script.php?script_id=5338)"
---



Introduction
============
Customize Vim's start screen.

This is a much simpler version of vim-startify (which has a lot more
features): https://github.com/mhinz/vim-startify

By default it displays a random fortune(6), but this can be configured. Many
Linux systems don't ship with fortune(6) by default any more (shame on them!)
so you may get errors if you don't have it installed.

Options
=======
`g:Startscreen_function`                (Funcref, default: `startscreen#fortune`)

The function to run; this expects a `Funcref`. Note the capital S!

Example:

    function! T()
    " Read on our TODO file
    read ~/TODO

    " Some margin for readability
    :silent %>>

    " Go to line 1
    :1
    endfun
    let g:Startscreen_function = function('T')
