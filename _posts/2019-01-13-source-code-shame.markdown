---
layout: post
title: "Source code shame"
---

<div class="hatnote">
Discussions:
<a href="https://www.reddit.com/r/programming/comments/ag2h51/testing_isnt_everything/ee3f3aw/">/r/programming</a>.
</div>

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

Eric S. Raymond made [similar observations in The Art of Unix
Programming](http://catb.org/~esr/writings/taoup/html/ch18s02.html#id3001522):

> Unix manual pages traditionally have a section called BUGS. In other cultures,
> technical writers try to make the product look good by omitting and skating
> over known bugs. In the Unix culture, peers describe the known shortcomings of
> their software to each other in unsparing detail, and users consider a short
> but informative BUGS section to be an encouraging sign of quality work.
> Commercial Unix distributions that have broken this convention, either by
> suppressing the BUGS section or euphemizing it to a softer tag like
> LIMITATIONS or ISSUES or APPLICATION USAGE, have invariably fallen into
> decline.

A public issue tracker is the modern variant of maintaining a BUGS section in
the manpage.
