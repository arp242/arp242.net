---
layout: code
title: "aurgit"
link: "aurgit"
last_version: "v1.0"
redirect: "https://github.com/Carpetsmoker/aurgit"
---

A simple script to manage AUR packages. Yes ... another one, because it's
exactly what the world needed!

I've been dealing with AUR packages like this for ages:

- Find a package on the website.
- git clone it to ~/aur/pkg
- less PKGBUILD
- makepkg -si
- `rm -r src *.tar *.gz *.zip` and whatever else looks like a large file.

I felt things could be a bit smoother than manually doing that; I tried a bunch
of the existing AUR manage scripts and found all of them far too complex. I just
want to `git clone && less PKGBUILD && makepkg -si`; I don't need integration
with standard Arch Linux packages or decorating my terminal like a Christmas
tree, or anything else.

---

The only dependencies are Python 3.5 or newer and git. You probably already
have them installed. There is an AUR package of course:
https://aur.archlinux.org/packages/aurgit

Usage info:

    Usage: ./aurgit [ sync | search | update | foreign ]

    Manage AUR packages. A local "database" of AUR packages in stored in PKGDIR.
    Use the foreign command to populate it if you're using this for the first time.

    Commands:
      sync [pkg]        Get or update a package.
      search [query]    Search AUR packages; the output is sorted by vote count,
                        which is displayed after the version in {}.
      update [-n]       Update all packages in the package dir. Run git pull first
                        unless -n is given.
      foreign           Try to clone all installed foreign packages to PKGDIR.

    Environment:
      AURGIT_PKGDIR     Dir to store git repos; default is $XDG_DATA_HOME/aur
                        (~/.local/aur for most people).
      AURGIT_PAGER      Pager to use; defaults to ${PAGER:-less}. Set to empty
                        string to not page anything.

A lot of these commands are pretty simple wrappers around the basic shell
commands; `sync` is `git {clone,pull} && makepkg -si`, `update` is a for loop
with `git pull && makepkg -si`.

This is conceptually very similar to my [packman][packman] script to manage Vim
packages. It started life as a modification of that, but doing the search in
shell scripting was too ugly so I rewrote it to Python. I should have [heeded my
own advice][shell]. Perhaps I'll write a generic "manage a bunch of git repos"
script some day.

---

Protip: stick this in your ~/.config/pacman/makepkg.conf to prevent it from
compressing packages. You're just doing to uncompress/install it a few seconds
later anyway. This can save a minute or more on some larger packages.

	# Don't compress files; it's just a waste of time/CPU cycles.
	PKGEXT='.tar'

[shell]: https://arp242.net/weblog/shell-scripting-trap.html
[packman]: https://github.com/Carpetsmoker/packman.vim
