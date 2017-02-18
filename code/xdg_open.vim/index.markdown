---
layout: code
title: "xdg_open.vim"
link: "xdg_open.vim"
last_version: "version-1.0"

---

[![This project is considered finished](https://img.shields.io/badge/Status-finished-green.svg)](https://arp242.net/status/finished)

Re-implements netrw's `gx` command with a call to `xdg-open` (or a similar
tool of your choosing).

This is especially useful if you're using dirvish or some other file-manager
other than netrw.

Is this fully compatible with netrw?
------------------------------------
It should be for most purposes, but feature-for-feature (or bug-for-bug)
compatibility was not a primary goal. Notable changes are:

- We just try to run `xdg-open`. No tricks and complicated fallbacks if that
  fails.

- The default is to get the `<cWORD>` instead of `<cfile>`. This works better
  with urls which have query parameters.

- The shell command is run in the background. This is much more sane.

Can I disable netrw completely?
-------------------------------

- To only disable gx-related functionality:

		let g:netrw_nogx = 1

- To disable all of netrw:

		let g:loaded_netrw = 1

- To disable the netrw doc files you need to remove the doc file at 
  `$VIMRUNTIME/doc/pi_netrw.txt` and rebuild the help tags with:

		:helptags $VIMRUNTIME/doc

  This has the advantage of not cluttering `:helpgrep` or tab completion.

  You will need write permissions here (e.g. run it as root). Unfortunately
  you will nee to re-run this after every upgrade.

See `:help xdg_open` for the full documentation.
