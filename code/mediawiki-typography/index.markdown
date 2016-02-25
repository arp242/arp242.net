---
layout: code
title: MediaWiki-Typography
link: mediawiki-typography
---

Automatically replace "quotes" with “smart” quotes. Also replaces - with an em
dash (—) and ... with an ellipsis (…).

Add `__NOTYPO__` to disable it.

Limitations:

- It uses `DOMDocument()` to parse the HTML, but only looks inside every tag. So
  `"some <strong>strange</strong> stuff!"` won't work, as it sees `"some`,
  `strange`, and `stuff"`. This can (and should) be improved on at some point.
