---
layout: code
title: "pkg_sanity"
link: "pkg_sanity"
last_version: "tip"
pre1: "Project status: Stable"

---


Performs some basic sanity checks for FreeBSD packages.

It can:

- Check for binaries which belong to a different FreeBSD version.
- Check for binaries or libraries with references to non-existing libraries.
- List files in `LOCALBASE`  that aren't installed by a package.

Also see `pkg_sanity(1)`.
