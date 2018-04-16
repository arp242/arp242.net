---
layout: code
title: "helplink.vim"
link: "helplink.vim"
last_version: "version-1.1"
---

[![This project is considered finished](https://img.shields.io/badge/Status-finished-green.svg)](https://arp242.net/status/finished) 

Link to Vim help pages with ease.

There are several sites which host the Vim help pages in formatted HTML. It's
often quite useful to link to this when explaining something.

With this plugin you can make a link to the help section you're viewing. Just
use `:Helplink`.

[I originally wrote this here](http://meta.vi.stackexchange.com/a/1250/51).

There is just one command: `:Helplink`, which will attempt to find the tags for
the current section and copies that to the clipboard as Markdown.

Prefer HTML? No worries! Just use `:Helplink html`.

See `:help helplink` for the full documentation.
