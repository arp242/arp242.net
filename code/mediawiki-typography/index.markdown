---
layout: code
title: "MediaWiki-Typography"
link: "MediaWiki-Typography"
last_version: "master"
---

Project status: archived (I no longer work on this, as I don't have a MediaWiki
install to administer any more. It's still usable, though, and I'll still
fix bugs when reported; contact me if you want to take over maintainership).

-----------------------------------------

Automatically replace "quotes" with “smart” quotes. Also replaces - with an em
dash (—) and ... with an ellipsis (…).

Add `__NOTYPO__` to disable it.

Limitations:

- It uses `DOMDocument()` to parse the HTML, but only looks inside every tag. So
  `"some <strong>strange</strong> stuff!"` won't work, as it sees `"some`,
  `strange`, and `stuff"`. This can (and should) be improved on at some point.
