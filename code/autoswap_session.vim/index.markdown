---
layout: code
title: autoswap_session.vim
link: autoswap_session.vim
---

----------------

Just do the sane thing if we detect an existing swap file instead of asking the
user.

As the name implies, it uses Vim's `clientserver` feature. For gVim, the
`remote_foreground()` function is used, which should work on most platforms.
We need some (platform-dependent) mucking about with shell tools for Vim
inside a terminal.

We take the following actions:

1. If an existing Vim session which has the file in a loaded buffer, we try to
   bring it to the foreground. If we fail to do so, show an error.
   Commands specified on the commandline with `-c` or `+` will be executed in
   Vim session that's editing the file.

2. If the swapfile's mtime is older than the mtime of the file itself, the
   swapfile is just removed.

3. Otherwise open the file in readonly mode.

This plugin has no user-visible mappings or functions. It simply hooks into
the `SwapExists` `autocmd-event`.

See `:help autoswap_session` (or [the help file][help]) for more information.

[help]: http://code.arp242.net/autoswap_session.vim/raw/tip/doc/autoswap_session.txt
