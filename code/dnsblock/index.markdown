---
layout: code
title: "dnsblock"
link: "dnsblock"
last_version: "tip"
pre1: "Experimental"

---

DNS proxy which can spoof responses to block ads and malicious websites.

It's a browser-independent alternative to solutions such as Ghostery, AdBlock
Plus, etc.

It's inspired by [adsuck][adsuck], which unfortunately hasn't been updated in a
few years and is suffering from some problems. Many thanks to Miek Gieben for
his [DNS library][dns], which makes it ridiculously easy to do this sort of
stuff.

Getting started
===============
Dnsblock is written in Go, so you'll need that.

Install it:

	$ go get -u code.arp242.net/dnsblock

Setup user and chroot directory:

	$ sudo useradd _dnsblock -d /var/run/dnsblock -s /bin/false
	$ sudo mkdir /var/run/dnsblock
	$ sudo chown _dnsblock:_dnsblock /var/run/dnsblock/

Setup resolv.conf:

	$ sudo resolvconf --disable-updates

*Clear your browser cache*.

How it works
============
An address like:

	http://blocked.example.com/some_script.js

will be resolved to:

	http://127.0.0.53:80/some_script.js

dnsblock also runs a HTTP server at `127.0.0.53:80` which will:

- Serve some no-ops for some common scripts so webpages don't error out (Google
  Analytics, AddThis).
- Serve a simply 0-byte response with a guessed Content-Type

ChangeLog
=========
No release yet. This is experimental software.

TODO
====
- Figure out a better name
- Write proper installation instructions
- Cache some stuff
- Look at DNSSEC?
- Listen to signals to reload
- Measure some degree of performance

Similar:

- [adsuck][adsuck] (POSIX systems)
- [Little Snitch](https://www.obdev.at/products/littlesnitch/index.html) (OSX)


[adsuck]: https://github.com/conformal/adsuck
[dns]: https://godoc.org/github.com/miekg/dns
