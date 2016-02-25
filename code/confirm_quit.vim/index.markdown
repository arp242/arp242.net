---
layout: code
title: confirm_quit.vim
link: confirm_quit.vim
extra_links: <li><a href="http://www.vim.org/scripts/script.php?script_id=5209">This plugin at www.vim.org</a></li>
---


Introduction
============
Ask for confirmation before quitting Vim.

I originally wrote this as an answer on vi Stack Exchange:
http://vi.stackexchange.com/a/3712/51

The idea is based on the "ConfirmQuit" script:
http://www.vim.org/scripts/script.php?script_id=1072

Mappings
========
This plugin comes with the following mappings by default:

    cnoremap <silent> q<CR>  :call confirm_quit#confirm(0, 'last')<CR>
    cnoremap <silent> wq<CR> :call confirm_quit#confirm(1, 'last')<CR>
    cnoremap <silent> x<CR>  :call confirm_quit#confirm(1, 'last')<CR>
    nnoremap <silent> ZZ     :call confirm_quit#confirm(1, 'last')<CR>

Set `g:confirm_quit_nomap` to 1 to disable this.

Options
=======
`g:confirm_quit_nomap`                 (Boolean, default: undefined)
Disable creating the default mappings.

Functions
=========
confirm_quit#confirm({writefile}, {when})             `confirm_quit#confirm()`

Ask for confirmation before quitting.

If {writefile} is 1, the buffer will be written to disk (like `:wq`).

With {when}, you can specify when to ask for confirmation. Possible
values are:
- {last}:    Last buffer (i.e. actually quitting).
- {always}:  Always, even when just closing a window.


confirm_quit#prevent({writefile}, {when})             `confirm_quit#prevent()`

Prevent quitting Vim altogether. The parameters work the same as
`confirm_quit#confirm()`.

confirm_quit#command({writefile}, {when}, {cmd})      `confirm_quit#command()`

Run an alternative command when quiting. The {writefile} and {when}
parameters work like `confirm_quit#confirm`, the {cmd} paramter is run
with `execute`.

An example:

    let g:confirm_quit_nomap = 1
    cnoremap <silent> x<CR>  :call confirm_quit#confirm(1, 'last')<CR>
    nnoremap <silent> ZZ     :call confirm_quit#confirm(1, 'last')<CR>
    cnoremap <silent> q<CR>  :call confirm_quit#command(0, 'last', 'Explore')<CR>
    cnoremap <silent> wq<CR> :call confirm_quit#command(1, 'last', 'Explore')<CR>

This will call `:Explore` when "quitting" Vim. In this example, we
only map `:q` and `:wq`, so the longer `:quit` will still work. `:wq`
doesn't have a longer version, but you can use `:x` or `:exit`.
