---
layout: post
title: Some thoughts on CDNs
categories: programming-and-such
---

“Of course you should use a CDN to deliver your JavaScript and CSS content” is
considered something of a truism among some developers, and advertising material
from CDNs is plentiful, but things are a bit more complex than that.

Performance
-----------
The greatest touted advantage of a CDN is faster load times. Because CDNs have
worldwide servers, users can fetch a copy of your content from a server nearby
which should be faster.

But is this always true?

- What if my website specifically targets Dutch users and my server is in the
  Netherlands? Is it still faster for all my Dutch users?

- CDN performance may not be consistent. One particular location may be blazing
  fast, and another may be very slow (and how do you know *which* locations are
  slow?)

- A CDN also introduces performance overhead in the form of a DNS request, a new
  TCP connection, and possibly new TLS negotiation; so a CDN has to not only be
  faster, it has to be fast enough to offset for this.

- Average load times are nice, but what about the *worst possible* load time? In
  my experience, this is often a lot worse with CDNs. Like with most things in
  life, a single ‘average’ number is pretty useless.

CDN performance is pretty hard to measure. In fact, I can’t really find any good
figures on the web that aren’t produced by a CDN provider (and thus not
reliable). My personal experience is checkered, and while a CDN can most
certainly improve the load performance, I would be careful in just assuming so.

It is already very easy to serve static content with very high performance using
tools such as [Varnish](https://www.varnish-cache.org/). In many cases, this is
about as fast (and certainly ‘fast enough’).

Hacks
-----
Any server can be compromised, no matter how secure. It is entirely possible for
someone to breach your CDN and inject malicious code.

Stuff like this *does* happen, for example
[with Linux Mint this week](http://arstechnica.co.uk/security/2016/02/linux-mint-hit-by-malware-infection-on-its-website-and-forum-after-hack-attack/)
and
[externally loaded malware ads](http://arstechnica.co.uk/security/2015/08/my-browser-visited-drudgereport-and-all-i-got-was-this-lousy-malware/)
are also a thing. There are many, *many*, more examples to be found.

These events are comparatively rare and usually (but not always!) quickly
discovered. But they *do* happen. It is a risk, and using a CDN increases the
attack surface.

An important question here is what sort of website are you developing? What is
the maximum damage that can be done? For example, the Plesk interface loads a
Facebook ‘like’ button by default, effectively giving Facebook complete control
of your server if they decide to take it. The chances that they actually will do
this are small, but the potential damage can be huge, and IMHO it’s not worth
the risk.

But if you just serve a basic weblog or some such, the worst that can happen is
that you serve ads or malware for a while (probably along with thousands of
other sites). Not great, but not a disaster either.

Malicious CDNs
--------------
In a similar vein, the CDN provider may "go bad" in the future and start
inserting adware or such in the CDN.
[Sourceforge does this with some
downloads](http://arstechnica.co.uk/information-technology/2015/05/sourceforge-grabs-gimp-for-windows-account-wraps-installer-in-bundle-pushing-adware/).

This is chiefly a concern with public CDNs and quite rare, but it *does* happen.
Are you *sure* that bootstrapcdn.com won't start serving crap in ten years’
time?

Availability
------------
A CDN may go down for an hour, week, month, or cease operation altogether. If
the CDN stops working, your JavaScript and CSS stop working, which basically
means that your site stops working.

This is especially a concern for sites you write once for clients and then never
look at again. Ideally, they should keep working for as long as possible.

Complexity
----------
The old adage of ‘everything is a fucking DNS problem’ has been replaced with
‘everything is a fucking caching problem’.

Caching is great, but it also adds a lot of complexity. CDNs effectively add
another layer of caching, and things can – and *do* – go wrong here.

Conclusion
----------
Think about the drawbacks, try to optimize your server with Varnish first, and
please, *measure* the actual real-world performance (which is probably easier
said than done).
