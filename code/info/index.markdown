---
layout: code
title: "info"
link: "info"
last_version: "master"
redirect: "https://github.com/Carpetsmoker/info"
---

[![This project is considered experimental](https://img.shields.io/badge/Status-experimental-red.svg)](https://arp242.net/status/experimental)

A simple GNU `info` replacement which isn't terrible.

You can install it with `go get arp242.net/info`, which will put the binary at
`~/go/bin/info`.

This program displays the info pages with various formatting and free software
propaganda removed (some pages contain more license text than actual useful
content).

If the output is a terminal device the output will be piped to `MANPAGER` or
`PAGER` if set. The default is to use `more -s`.

`INFOPATH` is respected.

There are no commandline options at this point.

A Texinfo rant
--------------

I have been using several different variants of Unix for almost 20 years. Yet I
still cannot navigate GNU's Texinfo.

- Maybe the key bindings make sense from an Emacs perspective, but most of us
  aren't Emacs users. There is no way to make it behave like the more standard
  "vi-ish" key bindings as far as I can find. I need to learn an entire new set
  of key bindings. From the perspective of the majority of users the key
  bindings are just nonsensical.

  If you're thinking "just read the manual you doofus": buzz off. Do you think I
  have nothing better to do than learn how to use some obscure and shitty piece
  of software just to read some fucking text? I've got about 80 years on this
  planet, and this is *not* how I want to spend it.

  And should the entire industry deal with this crap? How many man-hours will be
  wasted? Far too many. The only reason I sat down and wrote this in a bout of
  anger-driven development is the hope that it'll save myself and a bunch of
  other people some time and frustration.

- I don't like tech docs split over loads of very small pages; only makes it
  harder to read or search for things.

  I discovered that you can use `info --subnodes page | less` after I wrote this
  tool to output to a single page. I originally tried this, but it doesn't
  work unless you pipe it; just `info --subnodes` behaves as usual and the
  option is ignored 🤦

  It won't strip all the crap though (like now-useless navigation).

- There is no longer a single source for documentation; do I look at the info
  page or man page? Some tools have both, but one is more comprehensive than the
  other (sometimes info, sometimes man).

  Fragmentation and inconsistency has long been considered one of Unix's weak
  points, and rightfully so. GNU info only makes this worse. Then again, "GNU's
  not Unix" 🤷

- Every page comes with an inordinate amount of free software advocacy. I want
  to read a bloody manual, not a political statement. I know where the websites
  of the FSF and GNU are if I'm interested.

  Example: tar page minus crap is reduced from 91k words to 73k, grep from 7.5k
  to 14.5k. That's right, over half of the grep info page is Free Software
  wankery  ✊🍆 💦

- Some pages include images, which don't work inside a terminal (all of the
  images in the info pages on my system could be easily represented with a
  simple ASCII diagram, so why use images? Because you can I guess.)

There are exactly two good points:

- It's not widely used outside of GNU.

- The source format is fairly readable, so it's not too hard to write an
  alternative reader for it.

The entire Texinfo project is a failure. A more reasonable person would have
moved on from it a decade ago.

None of this means that man pages couldn't do with some enhancement – better
referencing probably being the most prominent – but GNU info isn't the answer.

---

Is this too complex? You can approximate it with something like:

	info() {
		zcat "/usr/share/info/$1.info.gz" |
			sed -Ee "/\x1f/d; /^File: $1.info,/d; /^(Node|Ref): .*/d" |
			cat -s |
			less
	}

This was the original version; but it was too hard to handle stuff like info
pages split over several files (which this snippet won't handle).

There's also [info2man](https://cskk.ezoshosting.com/cs/css/info2pod.html). I
needed to make some changes to get it to work, and the output didn't look too
great. This tool goes back to [at least
2004](https://web.archive.org/web/20040625210730/https://cskk.ezoshosting.com/cs/css/info2pod.html).
These criticism of Texinfo are hardly new, and the GNU folk's imperviousness to
it isn't, either.
