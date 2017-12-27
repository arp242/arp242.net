---
layout: code
title: "dwm"
link: "dwm"
last_version: "master"
---

This is my configuration of [`dwm`](https://dwm.suckless.org/). I did not write
most of this, this is simply a convenience repository to track my configuration
and patches.

Also see the
[original README](https://github.com/Carpetsmoker/dwm/blob/master/README)
and [FAQ](https://github.com/Carpetsmoker/dwm/blob/master/FAQ).

It it up-to-date with upstream commit
[`3756f7f`](https://git.suckless.org/dwm/log/) (2017-10-03), which is the most
recent version as of December 2017. I will try to keep things up to date; feel
free to open an issue if it's not.

Changes
-------

It includes the following patches/modifications; see the commit descriptions for
the full details:

- Add my `config.h`. If you don't like it then simply `rm config.h` and `make
  config.h` to re-generate it using `dwm`'s defaults.

- [`763de90`](https://github.com/Carpetsmoker/dwm/commit/763de90) – Add
  [selfrestart](https://dwm.suckless.org/patches/selfrestart/) patch, with
  modifications.

- [`ae3e657`](https://github.com/Carpetsmoker/dwm/commit/ae3e657) – Add
  [save_floats](https://dwm.suckless.org/patches/save_floats/) patch.

- [`36ab0e9`](https://github.com/Carpetsmoker/dwm/commit/36ab0e9) – Add
  edgemove to move floating windows to the edge of the screen.

- [`76bdf31`](https://github.com/Carpetsmoker/dwm/commit/76bdf31) – Add
  [scratchpad](https://dwm.suckless.org/patches/scratchpad/) patch.

- [`9cb2baf`](https://github.com/Carpetsmoker/dwm/commit/9cb2baf) – Add
  [singular borders](https://dwm.suckless.org/patches/singularborders/) patch.
