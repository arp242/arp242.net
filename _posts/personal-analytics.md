---
title: 'Analytics on personal websites'
date: 2020-08-05
tags: ['GoatCounter', 'Web']
---

Sometimes I see people dismiss any analytics on personal websites as "vanity
statistics", or even outright dismiss it as "spyware". I don't think that's the
case, but then again since I'm working on an analytics app so of course I would
say that 🙃 I did write GoatCounter specifically for my personal use on this
website long before I had any plans with it (first pageview: May 21st 2019).

It's sometimes useful to have an indication what people are reading, or if
anyone is reading something at all. For a while I maintained a [Vim
ChangeLog][vimlog] as I felt it would be useful to have such a thing.[^vim]
Maintaining that is quite labour-intensive and boring, and it turned out no one
was actually reading it; so I stopped maintaining it. Without *some* form of
analytics, I would have no way of knowing this.

[vimlog]: /vimlog

There are some other projects as well where this is useful; e.g. [The Art of
Unix Programming][taoup], or [bestasciitable.com][best]. It's just useful to
know how popular such projects are before I choose to spend more time on them.

[taoup]: /the-art-of-unix-programming
[best]: https://bestasciitable.com

I considered ‘archiving’ [How to detect automatically generated emails][auto] as
I thought it wasn't all that interesting after all; I just wrote that after
writing an email system years ago.[^email] Turns out quite a few people end up
there from Google and bug-trackers and such, so guess it's more useful than I
thought! Instead of archiving it, I spent some time copy-editing and polishing
it.

[auto]: /autoreply.html

I'd also like to have *some* insight when people link things on Hacker News or
whatnot. I'm hardly obsessed with what people say about my writings (I
intentionally ignore most of Reddit) but lot of what I've written has been
nuanced, corrected, clarified, or otherwise improved after reading insightful
and constructive criticism in comment threads. There's quite some value in it.

[^vim]: Vim's development model is a bit quirky: every commit is a new "version"
        or "patchlevel", and actual versions (8.2, 8.3, etc.) are released
        sporadicly, and the tagging of such versions is kind of arbitrary. Most
        distros ship with Vim `8.2.<some-patch-level>`, and figuring out what
        supports which features is not an easy task as a plugin author. Also,
        people are missing out on new features simply because they don't know
        they exists.

[^email]: I think I wrote it around 2015 or so, I don't know why I didn't
          publish it until years later. I get distracted 😅

---

As for "vanity stats" or "stats to stroke your ego": I think that's actually a
valid use case as well. After you spent quite a bit of your spare time writing
an article it's just nice to know people are actually reading it. There's
nothing wrong with being validated – it's a basic psychological need and I'm not
a fan of casually dismissing it.

I have similar feelings about "fake internet points" on Stack Overflow and the
like by the way; if I spend some time writing an in-depth answer then it's just
nice to get some feedback that it's useful for people. I especially get a lot of
satisfaction out of answers that keep getting upvotes for years.

Stack Overflow also keeps some "analytics" and shows you how many people have
viewed your answers: *"Estimated number of times people viewed your helpful
posts (based on page views of your questions and questions where you wrote
highly-ranked answers)"*. Right now it shows ~1.7m people reached for Stack
Overflow, and ~1.9m people reached for Vi & Vim Stack Exchange. 3.6 million in
total.

This is a *very* imperfect and crude number for all sorts of reasons, but even
when drastically slashed it still means my answers have been helpful to at least
hundreds of thousands of people. I think that's pretty neat, and I don't think
there's anything wrong with "stroking my ego" with this.

You can make similar arguments about upvotes on Hacker News or Reddit, or even
"likes" on Instagram. That's not to say that there aren't all sorts of real
negative effects to all of this either – some people get fixated on the points
and will game the hell out of the system to get more of them, among other more
subtle effects – but let's not be so quick to dismiss it all either.

---

As a little postscript, I'm having a hard time writing about this sort of stuff
as I really don't want this site to turn in to an advertisement channel for
GoatCounter, or give the impression that it is. On the other hand it's what I
spend most of my time doing and thinking about at the moment. I considered
starting a GoatCounter-specific blog but 1) effort, and 2) I'd rather not
incentivise myself to *actually* start writing blogspam. For what it's worth,
this is not a new opinion and I wrote about some of this stuff [years ago
already][rep]. I've got a few more that I'd like to write as I think I've got
something interesting to say, but I'll try to mix it up with some other things
😅

[rep]: https://meta.stackoverflow.com/a/340180/660921


{% related_articles %}
- [Frustration of the numbers and my domain on the internet](https://thelion.website/ramblings/frustration-of-the-numbers-and-my-domain/) – a different take on the issue.
{% endrelated_articles %}
