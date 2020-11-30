---
title: "Stupid light software"
tags: ['Programming']
updated: 2020-11-30
hatnote: |
    Discussions:
      [Lobsters](https://lobste.rs/s/95hsvw/stupid_light_software),
      [Hacker News](https://news.ycombinator.com/item?id=25237184)
---

The ultralight hiking community is – as you may gather from the name – very
focused on ultralight equipment and minimalism. Turns out that saving a bit of
weight ten times actually adds up to a significant weight savings, making hikes
– especially longer ones of several days or weeks – a lot more comfortable.

There's also the concept of [stupid light][sl]: when you save weight to the
point of stupidity. You won't be comfortable, you'll miss stuff you need, your
equipment will be too fragile.

[sl]: https://andrewskurka.com/stupid-light-not-always-right-or-better/

In software, I try to avoid dependencies, needless features, and complexity to
keep things reasonably lightweight. Software is already hard to start with, and
the more of it you have the harder it gets. But you need to be careful not to
make it stupid light.

It's a good idea to avoid a database if you don't need one; often flat text
files or storing data in memory works just as well. But at the same time
databases do offer some advantages: it's structured and it deals with file
locking and atomicity. A younger me would avoid databases at all costs and in
hindsight that was just stupid light in some cases. You don't need to
immediately jump to PostgreSQL or MariaDB either, and there are many
intermediate solutions, SQLite being the best known, but [SQLite can also be
stupid light][sqlite] in some use cases.

[sqlite]: https://sqlite.org/whentouse.html

Including a huge library may be overkill for what you need from it; you can
perhaps just copy that one function out of there, or reimplement your own if
it's simple enough. But this only a good idea if you can do it *well* and ensure
it's actually correct (are you *sure* all edge cases are handled correctly?)
Otherwise it just becomes stupid light.

I've seen several people write their own translation services. All of them were
lighter than gettext. And they were also completely terrible and stupid light.

Adding features or API interfaces can come with significant costs in maintenance
and complexity. But if you're sacrificing UX and people need to work around the
lack of features then you app or API just becomes stupid light.

It's all about a certain amount of balance. Lightweight is good, bloated is bad,
and stupid light is just as bad as bloated, or perhaps even worse since bloated
software usually at least allowed you to accomplish the task whereas stupid
light may prevent you from doing so.

---

I won't list any examples here as I don't really want to call out people's work
as “stupid”, especially if they're hobby projects people work on in their spare
time. I can think of a few examples, but does adding them really add any value?
I'm not so sure that it does. Arguably "stupid light" isn't really the best
wording here – the original usage in hiking context is mostly a self-deprecating
one – and a different one without "stupid" would be better, but I couldn't
really think of anything better 🤷 And it does have a nice ring to it.

Stupid light isn't something you can measure and define exactly, just like you
can't measure and exactly define "bloat". It depends on a lot of factors. But
just as it's worth thinking about "do we really need this?" to avoid bloat, it's
also worth thinking about "can we really do without this?" to avoid stupid
light.
