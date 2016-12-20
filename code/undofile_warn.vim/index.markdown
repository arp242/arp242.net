---
layout: code
title: "undofile_warn.vim"
link: "undofile_warn.vim"
last_version: "version-1.1"

---

[![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)

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
`g:undofile_warn_mode`                                   (Boolean, default: 1)

- `0`   Show a warning for a second but don't actually change behaviour.
- `1`   Show a warning and do nothing on the first `u` press, confirm with
        pressing `u` again.
- `2`   Ask for explicit confirmation
