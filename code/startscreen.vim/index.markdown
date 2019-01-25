---
layout: code
title: "startscreen.vim"
link: "startscreen.vim"
last_version: "version-1.0"
redirect: "https://github.com/Carpetsmoker/startscreen.vim"
---

[![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)

Customize Vim's start screen.

This is a much simpler version of [vim-startify](https://github.com/mhinz/vim-startify).

By default it displays a random `fortune(6)`, but this can be configured. Many
Linux systems don't ship with `fortune(6)` by default any more (shame on them!)
so you may get errors if you don't have it installed.

Set `g:Startscreen_function` to your prefered function to run on startup.

See `:help startscreen` for the full documentation.
