---
layout: code
title: "auto_autoread.vim"
link: "auto_autoread.vim"
last_version: "version-1.0"

---

- [This plugin at www.vim.org](http://www.vim.org/scripts/script.php?script_id=5206)
- [GitHub mirror](https://github.com/vim-scripts/auto_autoread.vim)
- [Full documentation](doc/auto_autoread.txt) (`:help auto-autoread.txt`)

-----------------------------------------------------------------------------

Automatically read files when they've changed, This does what 'autoread'
promises to do but doesn't do. This plugin requires `+python` or `+python3`.

The `'autoread'` setting _only_ checks if the file is changed when certain
events happen (buffer is entered, focus changed, etc.). If you're not
triggering those events, the buffer won't be updated. To be more precise,
this is when:

    - `:checktime` is used;
    - a buffer is entered;
    - `:diffupdate` is used;
    - `:e` is issued for a file that already has a buffer;
    - executing an external command with `!`;
    - returning to the foreground (^Z, fg, only if the shell has job control).

And for gVim, this is also done when:

    - closing the "right-click" menu (either by selecting something, or just
      by closing it);
    - focus is changed (this is what you already noticed);
    - closing the file browsers dialog that pops up if you use "file -> open",
      "file -> save as" from the menu (as well as some other places).

As you can see, this set is very limited. If you're running Vim in another
window while you're doing something else somewhere else, the buffer never gets
updated.

There are some other scripts/tips which promise to fix this, but all of those
that I tried simply extend the list of events with `CursorMoved`,
`CursorHold`, etc.

This plugin will periodically check if the file on the disk has changed with
`:checktime`, It will do this even if you're not interacting with Vim at all.
