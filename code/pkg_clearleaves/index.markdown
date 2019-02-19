---
layout: code
title: "pkg_clearleaves"
link: "pkg_clearleaves"
last_version: "master"
redirect: "https://github.com/Carpetsmoker/pkg_clearleaves"
---

[![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)

For FreeBSD there's a tool called [`pkg_cutleaves`][1], which is a *very* handy
tool to quickly remove unneeded packages; you get a list of all packages that
can be removed without breaking other packages in EDITOR and you remove the
lines of packages you want removed in your editor. Save, quit, confirm, and the
packages will be removed.

None of the Linux systems that I've worked with (Arch, Ubuntu, CentOS) come with
such a tool, nor have I been able to find one that works as well as
`pkg_cutleaves`.

So here it is!

This only implements the visual mode (as described in the opening paragraph),
and not the interactive mode, as I find that to be much more useful. Note that
the flags are *not* compatible with `pkg_cutleaves`.

It currently only works for Arch Linux (pacman), but its design should make it
easier to add other platforms as well. In fact, rpm, dpkg, and FreeBSD were
supported in earlier versions, but I added them with little testing four years
ago, and wasn't confident they're correct, so I commented them out again.

Feel free to test, develop, and open a PR!

[1]: http://www.freshports.org/ports-mgmt/pkg_cutleaves/
