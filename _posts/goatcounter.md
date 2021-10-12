---
title: "Launching GoatCounter"
date: 2019-08-13
tags: ['GoatCounter', 'Open source']
head: |
    <meta name="go-import" content="arp242.net/goatcounter git https://github.com/arp242/goatcounter.git">
    <meta name="go-source" content="arp242.net/goatcounter https://github.com/arp242/goatcounter https://github.com/arp242/goatcounter/tree/master/{/dir}/ https://github.com/arp242/goatcounter/tree/master/{/dir}">
---

**Update: [GoatCounter 1.0 released](/goatcounter-1.0.html)**.

So I made a thing, called [GoatCounter](https://www.GoatCounter.com). It's a web
statistics platform currently at "beta" or "MVP" status. I was actually working
on something entirely different, wanted to add some basic stats to it, and
discovered there are ... no good solutions. At least, not for my
requirements.[^fathom]

So why not make my own? I quit my job a while ago and while figuring out what I
want to do next I figured this is what I want to do. So yeah, let's offer it as
a service and try and make a living from this Open Source thing.[^oss] Like
many, I think this is the right way to make software, even if it'll probably
mean that making money will be a bit harder.[^mysql]

For me the dilemma was always:

1. Work on open source stuff, writing software that I feel has a lot of
   potential, but never have time to really polish it.
2. Work at a job, have plenty of time to polish stuff, but also time spent
   writing ... not so great ... stuff.

I worked full-time on [Trackwall](https://github.com/arp242/trackwall) for 3
weeks in April 2016 and made great progress. I started my job after that, and
while the core functionality worked very well, I never had the time to finish
the aspects that didn't work so well. The project is essentially the same as
[pi-hole][pi-hole] (which didn't turn up in my search for this kind of software
in early 2016), and I feel that with only one or two extra months of full-time
work it could have been a great project, that would be useful to many.

Similarly, I believe GoatCounter has a lot of potential; not just in providing
an income, but in making the web a (slightly) better place. I suspect that one
reason many people use Google Analytics is because it's free. Not only is Google
as a company problematic, Google Analytics as a product is massive overkill for
many people.

Right now GoatCounter isn't free because, well, I need to eat, and pay rent, and
more stuff like that, but it is very cheap, especially for personal use.
Ideally, I'd like to make it freely available for smaller websites in the
future.

But just spending a few evenings a week on it isn't enough. I don't know where
people find the time spend spend hours on OSS software next to their day jobs,
social life, partners, other hobbies, etc.

I figure that at $3/month, just 500 subscribers will give me enough to not
starve and just 1000 for something resembling a (low-end) normal income. That's
not all that much. There are tens – if not hundreds – of millions of websites
out there, and capturing a tiny market share should be doable.

I know it's a risk and that there's a decent chance this will fail. That's okay.
I'd rather take a chance to try to achieve a goal and fail instead of always
playing it on safe. Not doing anything is also a decision – which you can regret
just as much as any other – and the worst thing that can happen is that I lose
some money and end up taking a job again. Doesn't strike me as so bad, in the
grand scheme of things.

---

GoatCounter is not the only thing I'm working on: other things I worked on the
last week alone includes:

- [gopher.vim](https://github.com/arp242/gopher.vim) – a Vim plugin for Go. This
  also includes work on some external tools like
  [gosodoff](https://github.com/arp242/gosodoff) and
  [goimport](https://github.com/arp242/goimport).

- [testing.vim](https://github.com/arp242/testing.vim) is probably the best test
  framework for Vim out there (IMHO, but I might be biased).

- [jumpy.vim](https://github.com/arp242/jumpy.vim) – a small but rather useful
  Vim plugin

- [BestAsciiTable](https://github.com/arp242/bestasciitable) – because many of
  are actually quite crap.

- Worked on [zlog](https://github.com/zgoat/zlog),
  [zhttp](https://github.com/zgoat/zhttp),
  [formam](https://github.com/monoculum/formam).

- GoatLetter (unreleased, hopefully in a few months) – a newsletter service,
  with a similar design ethic as GoatCounter.

- [VimLog](/vimlog) – a more useful ChangeLog for Vim (there's much more new
  stuff happening than you'd might think!)

- Unnamed recipe site (unreleased, unplanned) – loads of 'em suck; I have some
  pretty clear ideas how to do it better. This was also my original idea that
  kicked of my need for web stats. There are still some missing parts but it's
  already functional. I paused it for the time being while I focus on
  GoatCounter and GoatLetter, but will almost certainly finish it, even if it
  ends up turning in to "Martin's personal recipe site".

In short, plenty of stuff. Few projects are "thousands of GitHub stars"-popular,
but then again, I never really did much advertising for most of it, and turns
out that [GitHub stars won’t pay your rent][stars].

[stars]: https://medium.com/@kitze/github-stars-wont-pay-your-rent-8b348e12baed

[pi-hole]: https://pi-hole.net/

[^fathom]: The closest thing is probably Fathom, but it doesn't seem very
           active: there haven't been any significant updates since Dec 2018. My
           initial plan was to contribute, but my first trivial patch is still
           sitting there ignored half a year later, exactly like all other
           patches and issues. I also wasn't wildly impressed by various
           technical aspects of it (most of which is fixable, but not if patches
           are ignored).

[^oss]: Or Free Software, if you prefer. I don't think it makes a lot of
        difference in practice, and "Open Source" is better known so I choose
        the pragmatic term (something for another post some day). "FLOSS" sounds
        ugly so I will never use that.

[^mysql]: There are, of course, plenty of Open source success stories – like Red
          Hat or MySQL – but most of them make money with enterprise software,
          rather than consumer software. Besides, MySQL got bought by Sun for $1
          billion while Oracle's yearly revenue is almost $40 billion and Larry
          Ellison's net worth is $66b, making him the 7<sup>th</sup> richest in
          the world; so...
