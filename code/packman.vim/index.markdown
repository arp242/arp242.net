---
layout: code
title: "packman.vim"
link: "packman.vim"
last_version: "master"
---

[![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)

Packman.vim is my simple Vim plugin/package manager. The ".vim" part of the name
is a bit misleading, as it's really just a shell script.

Why not use one of the many existing plugin managers? Well, I don't like
stuffing my Vim full of things I rarely use and would prefer to use an external
tool.

As the name hints, it relies on Vim's
[`packages`](http://vimhelp.appspot.com/repeat.txt.html#packages) feature. At
the time of writing, this is a relatively new feature that may not be available
on your Vim. Use `:echo has('packages')` to find out. You can use
[pathogen](https://github.com/tpope/vim-pathogen) to simulate this feature if
your Vim is missing it.

-----------------------

Using packman is simple: define the plugins you want in `packman.conf` and run
it to install new plugins and update existing ones.. Packman will try to load
the configuration file from `~/.vim/packman.conf` or `packman.conf` in the the
current directory.

Here's what `./packman.sh -v` will tell you:

	./packman.sh [mode]

	mode can be:
		version    Show last commit for all installed plugins.
		install    Install new plugins; don't update existing.
		update     Update existing plugins; don't install new.
		orphans    Remove 'orphaned' packages no longer in the config.

	If no mode is given it will install new plugins and update existing plugins.

That's all.

-----------------------

I'll be honest: packman is not perfect: it's very simple and only does the bare
minimum, is probably not the fastest tool out there due to lack of
parallelisation, and doesn't support anything other than GitHub.

For most people, that's actually just fine. It is for me, anyway. I've never
checked out a specific tag of a plugin, and waiting an extra 30 seconds is
perfectly fine if that will save us a lot of complexity. I also can't remember
the last time I used a Vim plugin that's *not* on GitHub; [I dislike git, but
for better or worse, it's the de-facto
standard](https://arp242.net/weblog/i-dont-like-git-but-im-going-to-migrate-my-projects-to-it.html).
