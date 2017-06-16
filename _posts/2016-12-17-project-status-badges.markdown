---
layout: post
title: Project status badges
categories: programming-and-such
---

Most code that I write outside of work ends up on the internet sooner or later,
but not all code that I put on the internet is of equal quality. Some of it is
quite nice and polished. Other code is a quick hack or some experiment; it *may*
still be useful for others – and why not put it on the web – but it’s probably a
good idea to set some expectations about the status.

I’m hardly the first person to do this. A ‘beta’ label or ‘pre-1.0’ version are
commonly used, but also commonly abused. So commonly abused that a ‘beta’ label
or ‘0.1’ release is pretty useless these days for meaningful communication about
a project’s status.

To set some expectations, I've been adding text to the top of my README files.
This works, but is a bit ugly. Today I made some
‘[shields](https://github.com/badges/shields)’ to make it look a bit better.
I’ve also written brief explainer pages for every status.

Here they are:

- [![This project is considered experimental](https://img.shields.io/badge/Status-experimental-red.svg)](https://arp242.net/status/experimental)  
  May work, or may sacrifice your first-born to Justin Bieber.

- [![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)  
  Should work for most purposes; is reasonably bug-free and documented.

- [![This project is considered finished](https://img.shields.io/badge/Status-finished-green.svg)](https://arp242.net/status/finished)  
  Does what it needs to do and there are no known bugs; don’t expect any large
  changes or feature additions.

- [![This project is archived](https://img.shields.io/badge/Status-archived-red.svg)](https://arp242.net/status/archived)  
  The author has stopped working on it, but should still work and may still be
  useful.

And the Markdown:

- <input type="text" style="width: 98%;"
	value="[![This project is considered experimental](https://img.shields.io/badge/Status-experimental-red.svg)](https://arp242.net/status/experimental)">
- <input type="text" style="width: 98%"
	value="[![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)">
- <input type="text" style="width: 98%"
	value="[![This project is considered finished](https://img.shields.io/badge/Status-finished-green.svg)](https://arp242.net/status/finished)">
- <input type="text" style="width: 98%"
	value="[![This project is archived](https://img.shields.io/badge/Status-archived-red.svg)](https://arp242.net/status/archived)">

I didn’t create any of the images myself. It’s just the
[shields.io](http://shields.io/#your-badge) service. If you want, you can modify
the colours by frobbing with the URL.

Some might argue there should be more statuses, but I like to keep things
simple.

- If your project is unmaintained and no longer works you should probably just
  take it offline. Broken code serves no one.

- If your code isn’t Experimental but not ‘reasonably bug-free and documented’
  then it is, in fact, just Experimental.  
  No one would consider a washing machine with a long list of defects or no
  instructions on how to use acceptable. Why should we for software? I don't
  think that creating an in-between ‘yeah, it sort of works’ status will help
  anyone.  
  Just go and fix those few bugs and/or write some docs :-)
