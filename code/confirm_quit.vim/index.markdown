---
layout: code
title: "confirm_quit.vim"
link: "confirm_quit.vim"
last_version: "version-1.0"

---

[![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)

Ask for confirmation before quitting Vim.

I originally wrote this as [an answer on vi Stack
Exchange](http://vi.stackexchange.com/a/3712/51).

The idea is based on the ["ConfirmQuit"
script](http://www.vim.org/scripts/script.php?script_id=1072).

To use it you'll need to remap keys that "quit" Vim as there's no other way to
prevent Vim from quitting. This plugin comes with the following mappings by
default:

    cnoremap <silent> q<CR>  :call confirm_quit#confirm(0, 'last')<CR>
    cnoremap <silent> wq<CR> :call confirm_quit#confirm(1, 'last')<CR>
    cnoremap <silent> x<CR>  :call confirm_quit#confirm(1, 'last')<CR>
    nnoremap <silent> ZZ     :call confirm_quit#confirm(1, 'last')<CR>

See `:help confirm-quit` for the full documentation.

