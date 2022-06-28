---
title: "GoatCounter 1.1 release"
date: 2020-03-18
archive: true
tags: ['GoatCounter']
---

I released version 1.1 of GoatCounter today.

There are many changes, large and small. The most work was in revamping the CLI,
revamping the ACME/Let's Encrypt support so it's easier to use, and supporting
display in a configurable timezone. The [release page][r] has a more complete
changelog.

I originally made everything in UTC only as that was simpler, figuring it would
be fairly easy to add TZ support later on. Turns out that was a mistake as it
was much harder than expected to add TZ support and the initial patch introduced
a number of bugs, mostly related to some data being calculated over UTC, and
some over the user's TZ 😞

This pushed back the release by quite a bit; I originally wanted to release on
Feb 29th, as I thought it would be neat to release on a leap day, but that
didn't happen. Ah well, better luck in four years!

If you're using the goatcounter.com service then you've already been seeing
these changes in the last 2 months since it generally runs on master.

There are no binaries for this release, as building them reliably with cgo
(needed for SQLite) turned out to be hard to get correct for everyone. See
[#130](#130) for details.

Compiling it from source should be easy enough though, you just need Go and a C
compiler, both should be easily installable on pretty much all platforms.

For the next version I mainly want to focus on recording unique visits
([#13][#13]), which is probably the most-requested feature. I'll probably also
add some better support for events ([#55][#55]) and work on some minor
enhancements. See the [version 1.2 milestone][1.2].

Finally a special thanks for everyone who got in touch; people forwarded some
great ideas, feedback, bug reports, and graphics. More of that is always good 😊

[r]: https://github.com/zgoat/goatcounter/releases/tag/v1.1.0
[1.2]: https://github.com/zgoat/goatcounter/milestone/4
[#130]: https://github.com/zgoat/goatcounter/issues/130
[#13]: https://github.com/zgoat/goatcounter/issues/13
[#55]: https://github.com/zgoat/goatcounter/issues/55
