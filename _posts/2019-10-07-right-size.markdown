---
layout: post
title: "On being the right size"
tags: ['Programming']
---


There's this pattern: *"everything should be done in small easy to understand
units, which can easily be combined to form larger more complex systems"*.
Examples include microkernels, microservices, small packages, and small
functions.

Sounds great, but applied everywhere will hit a snag: combining all those small
easy-to-understand units to do useful real-world stuff is rather hard. There are
plenty of research microkernel systems but general purpose microkernel systems
are rare: almost all mainstream kernels are either monolithic (Linux, FreeBSD,
OpenBSD) or hybrid (macOS, Windows), with just a few exceptions which are
special-purpose (QNX), historical (AmigaOS), or incomplete (GNU Hurd).

Microservices seem awfully similar to microkernels. Communication between the
different services is quite a hard to get right, and don't even mention the
orchestration of all those services. See: [MicroservicePremium][mspremium]. In
many ways it's even harder than microkernels. Most "microservices" are really
just [using a hybrid approach][mservice] which is perfectly reasonable, but
underscores that "true" microservices are hard.

Splitting everything in small packages can be a real pain; dependency management
is a hard problem. There's a reason monorepos exist (although they are an
extreme), and I think it's not uncontroversial to say that the JavaScript/npm
ecosystem suffers from some serious problems due to overmodularisation. 

[mservice]: https://blog.softwaremill.com/are-you-sure-youre-using-microservices-f8d4e912d014
[mspremium]: https://martinfowler.com/bliki/MicroservicePremium.html

---

Software split in to small functions is often harder to understand. Sure, the
individual functions may be easy to understand, but understanding the overal
system is much harder.

Sometimes longer functions in the form of *"do this, then do that, then do
such"* are okay, especially for more complex workflows that naturally belong
together. Splitting this up in to tiny functions often doesn't make the overall
logic easier to understand.

A program should be understandable, not "small" or "DRY"; those are merely
*tools* to achieve this understandability, but not end-goals in themselves.
Applying any tool indiscriminately is not going to end well.

Indiscriminately following Test-Driven Development can be really harmful. I
expanded on this at some length in my [testing isn't everything][testing]
article, so I won't repeat it here.

Global variables can be perfectly fine, especially if the program is small.
Sometimes it just makes more sense. The downsides come at scale: when you can no
longer see all global variables.

I suspect this is [why function programming hasn't taken over yet][fp-why]. In
spite of all the advantages, actually making useful programs with it is harder
than just writing a many simple functions.

As [Haldane already observed many years ago][haldane], the "right" size isn't
the smallest (or the largest). It's the right one.

<!-- https://www.joelonsoftware.com/2001/01/18/big-macs-vs-the-naked-chef/ -->

[testing]: /testing.html
[fp-why]: https://stackoverflow.com/a/2835936/660921
[haldane]: https://irl.cs.ucla.edu/papers/right-size.html
