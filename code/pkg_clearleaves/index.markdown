---
layout: code
title: "pkg_clearleaves"
link: "pkg_clearleaves"
last_version: "master"
pre1: "Project status: experimental"

---

For FreeBSD there's a tool called [`pkg_cutleaves`][cl], which is a *very* handy
tool to quickly remove unneeded packages.

None of the Linux systems that I've worked with (Arch, Ubuntu, CentOS) come with
such a tool, nor have I been able to find one that works as well as
`pkg_cutleaves`.

So here it is! It's cross-platform, and should work on:

- FreeBSD with the new `pkg` system.
- `pacman` (Arch Linux).
- `rpm` (Red Hat, CentOS, Fedora, SUSE, many more).
- `dpkg` (Debian, Ubuntu, many more).

This only implements the visual mode, and not the interactive mode, as I find
that to be much more useful. Note that the flags are *not* compatible with
`pkg_cutleaves`.

[cl]: http://www.freshports.org/ports-mgmt/pkg_cutleaves/
