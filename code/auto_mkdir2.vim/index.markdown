---
layout: code
title: "auto_mkdir2.vim"
link: "auto_mkdir2.vim"
last_version: "version-1.0"

---

[![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)

Automatically create direcories that don't exist yet when writing a file.

This allows you to do:

    vim ~/a/dir/tree/that/doesnt/exist/new-file.txt

and then just use `:w` (or `ZZ`, or `:up`, etc.) to create the directory tree.

This is basically the same as the "auto_mkdir" plugin, although it was
developed independently. This version has the option to confirm directory
creation and includes a bugfix:
http://www.vim.org/scripts/script.php?script_id=3352

See [`:help auto_mkdir2`](https://github.com/Carpetsmoker/auto_mkdir2.vim/blob/master/doc/auto_mkdir2.txt)
for the full documentation.
