---
layout: code
title: "my-first-vimrc"
link: "my-first-vimrc"
last_version: "master"
---

Source code for [My first vimrc](https://arp242.net/my-first-vimrc), a vimrc
generator that doesn't add a world of complexity.

The concept is inspired by [vimconfig.com](http://vimconfig.com), but I wouldn't
recommend this site for various reasons (for a start it uses invalid syntax, and
some options it sets are inadvisable). I did like the idea though, hence this
project.

It is an alterantive to spf13, vim-bootstrap, and whatnot which give new users a
huge vimrc full of undocumented/unclear options.

Who not just use `:help`? Well:

	$ wc -l options.coffee /usr/share/vim/vim80/doc/options.txt
	 456 options.coffee
	9120 /usr/share/vim/vim80/doc/options.txt

Also, the help descriptions try to add a little bit more context/explanation
more aimed at new users, rather than being a reference manual like Vim's
`options.txt`.

Contributing
------------

- Thank you!

- This project's goal is *not* to list all possible options/snippets that you
  can stick in a vimrc. Only the most useful/common ones to give new users a
  good place to start from.

  Ideally, the list should fit on a single page of a 1920×1080 screen, and
  reading through it all shouldn't take more than about half an hour at the
  most.
