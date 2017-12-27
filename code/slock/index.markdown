---
layout: code
title: "slock"
link: "slock"
last_version: "master"
---

This is my configuration of [`slock`](https://tools.suckless.org/slock/). I did
not write most of this, this is simply a convenience repository to track my
configuration and patches.

Also see the
[original README](https://github.com/Carpetsmoker/slock/blob/master/README).

It it up-to-date with upstream commit
[`35633d4`](https://git.suckless.org/slock/log/) (2017-03-25), which is the most
recent version as of December 2017. I will try to keep things up to date; feel
free to open an issue if it's not.

Changes
-------

It includes the following patches/modifications; see the commit descriptions for
the full details:

- Add my `config.h`. If you don't like it then simply `rm config.h` and `make
  config.h` to re-generate it using `slock`'s defaults.

- [`8c79364`](https://github.com/Carpetsmoker/slock/commit/8c79364) – Add
  [quickcancel](https://tools.suckless.org/slock/patches/quickcancel) patch.

- [`97b7d86`](https://github.com/Carpetsmoker/slock/commit/97b7d86) – Add
  [dpms](https://tools.suckless.org/slock/patches/dpms) patch.
