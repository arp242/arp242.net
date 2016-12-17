---
layout: code
title: "trackwall"
link: "trackwall"
last_version: "master"
pre1: "Project status: experimental; it works for the author, and may be useful to others, but may also sacrifice your firstborn to Cthulhu and take out a new mortgage on your house."

---


[![Build Status](https://travis-ci.org/Carpetsmoker/trackwall.svg?branch=master)](https://travis-ci.org/Carpetsmoker/trackwall)
[![Coverage Status](https://coveralls.io/repos/github/Carpetsmoker/trackwall/badge.svg)](https://coveralls.io/github/Carpetsmoker/trackwall)
[![Go Report Card](https://goreportcard.com/badge/arp242.net/trackwall)](https://goreportcard.com/report/arp242.net/trackwall)

DNS proxy and filter.

Its intended usage is to block third-party browser requests. It's not intended
to "block advertisement" as such, rather it's intended to "block third party
requests".

It's inspired by adsuck, which unfortunately hasn't been updated in a few years
and is suffering from some problems.

Advantages:

- Lightweight.
- Browser independent − also works for requests outside the browser.
- Will not endlessly frob in web page's DOM (which many adblocks do).

To be fair, there are some disadvantages as well:

- It's currently a bit more difficult to set up.
- Unable to filter by URL (only domain name). This is usually not a problem
  unless you want to filter out every last advertisement (which is not this
  program's goal).

Getting started
===============

Download and building
---------------------
trackwall is written in Go, so you'll need that. Tested systems are:

- Go 1.7 on Arch Linux
- Go 1.6 on VoidLinux (musl libc)
- Go 1.6 on Ubuntu 16.04
- Go 1.5 on OpenBSD 5.9

Other POSIX systems should also work.

You can download and build it with:

	$ go get -u arp242.net/trackwall
	$ go install trackwall

You will probably want to run the `install.sh` script to setup some stuff as
well:

	$ $GOPATH/src/arp242.net/install.sh

Setting up `/etc/resolv.conf`
-----------------------------
After trackwall is up and running you'll need to tell the OS to actually use it.
This is usually done by adding `nameserver <addr>` to `/etc/resolv.conf`. Most
systems auto-generate this file (usually from DHCP).

### OpenBSD
Set `/etc/dhclient.conf` to something like:

	# The installer adds this line, not strictly needed
	send host-name "yourhostname";

	# List our nameserver first
	prepend domain-name-servers 127.0.0.53;

Running `sh /etc/netstart` will apply the settings.

If you want to listen on the loopback interface that is not `127.0.0.1` (which
is the case by default) you'll have to add that address as an alias, which can
be done in `/etc/hostname.lo0`:

	inet alias 127.0.0.53

Running `sh /etc/netstart` will apply the settings.

### VoidLinux
If you're using the GNU libc version then setting `/etc/resolv.conf.head` to:

    nameserver 127.0.0.53

should be enough.

**Note**: if you're using the musl libc version then this won't work as
expected, since musl's resolvers sends a query to *all* nameservers and uses
whichever one responds fastest, so you'll need to set *only* trackwall as the
nameserver. This can be done by creating
`/usr/libexec/dhcpcd-hooks/90-resolv.conf` with:

	#!/bin/sh
	echo 'nameserver 127.0.0.53' > /etc/resolv.conf

Don't forget to make this executable! You'll also need to set the `dns-forward`
setting manually in `/etc/trackwall/config`.

### Ubuntu
Set `/etc/resolvconf/resolv.conf.d/head` to:

	nameserver 127.0.0.53

and run `resolvconf -u`.

### Arch Linux
Add to `/etc/resolvconf.conf` to :

	name_servers=127.0.0.53

and run `resolvconf -u`.


Browser setup
--------------

### Root certificate
On first startup a root certificate will be generated and put in
`/var/trackwall`. We use this root certificate to sign https requests.

You will need to import this certificate in your browser.


**NOTE!** Make sure the certificate is readable! Firefox will **NOT** show an
error or warning if it's not.

### Cache
You will need to turn off the hyper-aggressive ttl-ignoring DNS cache that both
Firefox and Chrome are infected with.

How it works
============
An address like:

	http://blocked.example.com/some_script.js

will be resolved to:

	http://127.0.0.53:80/some_script.js

trackwall runs a HTTP server at `127.0.0.53:80` and `127.0.0.53:443` which will
either:

1. Serve some no-ops for some common scripts so web pages don't error out
   (Google Analytics, AddThis, etc.).
2. Serve an simple HTML or JS page informing the user that this request is
   blocked. This is a useful so that you don't have to guess *why* a request
   doesn't work and to keep the browser's error log clutter-free.

ChangeLog
=========
No release yet. This is experimental software.

TODO
====
- Listen to signals to reload
- Measure some degree of performance

FAQ
===

Will this serve as a local DNS resolver and/or cache?
-----------------------------------------------------
No. This is not a DNS resolver/cache, just a proxy/filter. If you're looking for
a DNS cache then [unbound][unbound] is a good option. Running both on even an
older system should be fine (the trackwall author is running them both on a
ten-year old OpenBSD laptop).

This program sucks. What alternatives are there?
================================================
Sorry :-( I always appreciate feedback by the way, so drop me a email at
martin@arp242.net

Here are some similar programs:

- [adsuck][adsuck] (POSIX systems)
- [Little Snitch][little-snitch] (OSX)
- [dnsblock][dnsblock] (POSIX systems)


Authors and license
===================
This program is written by Martin Tournoij <martin@arp242.net>, whose job would
have been a lot harder without [Miek Gieben's DNS library][miekg-dns].

The MIT License (MIT)

Copyright © 2016 Martin Tournoij

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

The software is provided "as is", without warranty of any kind, express or
implied, including but not limited to the warranties of merchantability,
fitness for a particular purpose and noninfringement. In no event shall the
authors or copyright holders be liable for any claim, damages or other
liability, whether in an action of contract, tort or otherwise, arising
from, out of or in connection with the software or the use or other dealings
in the software.

[adsuck]: https://github.com/conformal/adsuck
[miekg-dns]: https://godoc.org/github.com/miekg/dns
[dnsblock]: https://github.com/torrentkino/dnsblock
[little-snitch]: https://www.obdev.at/products/littlesnitch/index.html
[unbound]: https://unbound.net/
