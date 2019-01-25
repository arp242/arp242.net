---
layout: code
title: "pkg_sanity"
link: "pkg_sanity"
last_version: "master"
redirect: "https://github.com/Carpetsmoker/pkg_sanity"
---

[![This project is archived](https://img.shields.io/badge/Status-archived-red.svg)](https://arp242.net/status/archived)

Performs some basic sanity checks for FreeBSD packages.

It can:

- Check for binaries which belong to a different FreeBSD version.
- Check for binaries or libraries with references to non-existing libraries.
- List files in `LOCALBASE`  that aren't installed by a package.

Also see `pkg_sanity(1)`.
