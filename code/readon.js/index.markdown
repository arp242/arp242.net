---
layout: code
title: "readon.js"
link: "readon.js"
last_version: "master"
redirect: "https://github.com/Carpetsmoker/readon.js"
---

[![This project is considered experimental](https://img.shields.io/badge/Status-experimental-red.svg)](https://arp242.net/status/experimental)

readon.js is a simple JavaScript library to allow people to continue reading
where they left last time they visited a page.

This is useful especially for longer pages. I wrote it for [The Art of Unix
Programming](https://arp242.net/the-art-of-unix-programming/), which also serves
as a demo.

Usage
-----

readon.js works by storing the nearest id in localStorage on scroll. It uses
IDs as this is the most reliable, pixel positions are dependent on window size,
zoom level, etc.

You can use the `autoID` option if your document doesn't have any id attributes,
or doesn't have enough to be accurate.

You need to call `readon.init()`, which optionally accepts various options in an
Object (see below). This should be called *after* you've done other DOM
modifications that may affect the positioning of elements.

### Options

- `autoID`; default: `false`<br>
  Automatically generate id attributes for all elements in `anchors`, minus the
  `[id]` selectors. If this value is a string then if will only search for the
  selectors in

- `anchors`; default: `'p[id], h1[id], h2[id], h3[id], h4[id], h5[id], h6[id]'`<br>
  Consider matching elements "anchors" to continue from. Things like footnote
  references, images, and layout content are generally not useful for this. Use
  `*[id]` to hook in to any element with an id attribute.

- `textNotify`; default: `'Loaded (approximate) position of last view.'`<br>
  Text of popup that the last position is loaded. Mainly for i18n.

- `textClose`; default: `'close'`<br>
  Text of close button in popup. Mainly for i18n.

### Classes

Reasonably sensible defaults will be used if the classes are not defined in any
style sheet. No styling at all will be added if they're defined.

- `.readon-remembered`<br>
  Class added to the remembered element on page load. Default is to give it a
  yellow background colour.

- `.readon-notify`<br>
  Popup notification informing the user that the page scrolled to where the user
  previously left off. Default is to place it as a fixed element at the bottom.
