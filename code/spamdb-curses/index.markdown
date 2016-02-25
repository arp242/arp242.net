---
layout: code
title: spamdb-curses
link: spamdb-curses
---

Human friendly curses interface for `spamdb(8)` to manage addresses for the
whitelist/greylist.

Note: This is for OpenBSD's `spamd(8)`, which has absolutely nothing to do with
SpamAssasin's `spamd`.

It's simple, and "just works"™ ... What more is there to say?

ChangeLog
=========

Version 1.2 - 2012-11-01
------------------------
- Now works with both Python 2 & Python 3.

Version 1.1 - 2011-10-25
------------------------
- Handle reverse DNS lookups better.
- Don't crash if the detail window is too large to fit on the screen.

Version 1.0 - 2011-09-28
------------------------
- Hello, world.
