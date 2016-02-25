---
layout: code
title: undofile_warn.vim
link: undofile_warn.vim
extra_links: <li><a href="http://www.vim.org/scripts/script.php?script_id=5207">This plugin at www.vim.org</a></li>
---


Introduction
============
The 'undofile' is a great feature, and I use it a lot. However, one annoyance
is that it's very easy to accidentally undo changes that I did the last time I
opened the file; which may be 2 minutes ago, an hour ago, last week, or a
year ago.
So what would happen is that sometimes I would accidentally undo changes from
ages ago.

This plugin fixes that by showing a warning.

I originally posted this as an answer on vi StackExchange, which also has some
other solutions to the same problem:
http://vi.stackexchange.com/q/2115/51


Mappings
========
This plugin overwrites the `u` and `CTRL-R` mappings:

    nmap u     <Plug>(undofile-warn-undo)
    nmap <C-r> <Plug>(undofile-warn-redo)

You can prevent this by setting `g:undofile_warn_no_map` to 1.

Options
=======
`g:undofile_warn_prevent`                                (Boolean, default: 1)

Prevent the `u` from actually undoing when we warm; if set to 0, we
will warn _and_ undo.
