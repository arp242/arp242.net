---
title: "Source code shame"
date: 2019-01-13
tags: ['Community', 'Open source']
---

I suspect that that many companies don't publish their source code not because
they're against the idea of it, but because they're ashamed of the quality.
Publishing the source – either as open source of ‘source available’ – will mean
showing your entire customer base what a bloody mess it is.

With a closed code base, you can fix most issues "silently" without too many
customers noticing there was actually a really embarrassing bug or security
issue. You can't really do this with open source software. Got an embarrassing
bug because of unprofessional and careless programming? Everyone can see.

This is a rather sorry state of things, but unfortunately a lot of software just
plain ol' sucks. Is there open source software that sucks? Sure. But at least it
forces programmers to be honest about it.

Here's [Dennis Ritchie's comments on the BUGS section in Unix man
pages](http://www.collyer.net/who/geoff/history.html):

> Our habit of trying to document bugs and limitations visibly was enormously
> useful to the system. As we put out each edition, the presence of these
> sections shamed us into fixing innumerable things rather than exhibiting them
> in public. I remember clearly adding or editing many of these sections, then
> saying to myself "I can't write this," and fixing the code instead.

A public issue tracker is the modern variant of maintaining a BUGS section in
the man page.
