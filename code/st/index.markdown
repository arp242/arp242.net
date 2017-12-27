---
layout: code
title: "st"
link: "st"
last_version: "master"
---

This is my configuration of [`st`](https://st.suckless.org/). I did not write
most of this, this is simply a convenience repository to track my configuration
and patches.

Also see the
[original README](https://github.com/Carpetsmoker/st/blob/master/README)
and [FAQ](https://github.com/Carpetsmoker/st/blob/master/FAQ).

It it up-to-date with upstream commit
[`0ac685fc`](https://git.suckless.org/st/log/) (2017-10-10), which is the most
recent version as of December 2017. I will try to keep things up to date; feel
free to open an issue if it's not.

Changes
-------

It includes the following patches/modifications; see the commit descriptions for
the full details:

- [`b1be4de`](https://github.com/Carpetsmoker/st/commit/b1be4de) –
  Add [hidecursor](https://st.suckless.org/patches/hidecursor/) patch.

- [`cd17e79`](https://github.com/Carpetsmoker/st/commit/cd17e79) – Add
  [externalpipe](https://st.suckless.org/patches/externalpipe/) patch.

- Add my `config.h`, which you may or may not like. The defaults more closely
  resemble `xterm`'s defaults, which is what I am used to.
  If you don't like it then simply `rm config.h` and `make config.h` to
  re-generate it using `st`'s defaults.
