---
title: "Choosing a license for GoatCounter"
date: 2019-12-30
tags: ['GoatCounter', 'Open source']
updated: '2020-07-01'
hatnote: |
    Discussions:
      [Hacker News](https://news.ycombinator.com/item?id=21914245).
---

Choosing a license has always been easy: MIT. It's the best-known "do what you
want" plain language license. Arguably ISC is slightly better, but also lesser
known.

I'm not especially concerned with patents or people using my work for commercial
purposes: a company using my little tool or library (with or without changes)
takes away nothing from my little hobby project that [I wrote for my own
reasons][diy].

[diy]: /diy.html

---

But with GoatCounter things are different: I'm actually [trying to make a living
from it][gc].

[gc]: /goatcounter.html

I *still* don't really care what people do with my code, but I *do* care if my
ability to make a living would be unreasonably impeded. Taking my MIT code and
working full-time on enhancements that aren't sent back to me means my
competitor has double the amount of people working on it: me (for free, from
their perspective), and them. They will always have an advantage over me.

I don't think it's  *likely* this will happen, but it's a risk I don't really
want to take.

The answer for this is "copyleft", which requires people to send changes back to
me. It still allows running an unmodified version to compete with my SaaS, which
is okay: at least it won't allow anyone to benefit from my work unfairly.

The well-known and widely used copyleft licenses from the Free Software
Foundation (FSF) such as the GPL are in my opinion not very good; they're dense
and hard to read. I also don't like the FSF as an organisation for reasons I
will explain in a future post, and would prefer to avoid them when possible.

I slapped on the AGPL 3.0 because I wanted to start shipping, and not get too
bogged down in these kind of license details. I recently looked for some
alternative copyleft licenses. My requirements:

- Have a copyleft which includes the so-called "network protection", which
  mandates that people submit changes even if they operate the code as a service
  (rather than sending people binaries).

- For practical reasons, an [OSI-approved][osi] license would be best; it avoids
  confusion, and is a requirement for applying to various open source benefits
  (e.g. free or discounted services, like Netlify, BrowserStack, Google Summer
  of Code, etc.)

  (Aside: I don't really like that the OSI is the *One True Authority* of "Open
  source" now; the term was around for a long time before the OSI was
  started[^oss] and there are many licenses that are perfectly fine according to
  the Open Source Definition, but the OSI just hasn't approved them. See e.g.
  [Don’t Rely on OSI Approval][osi-approval]. But it is what it is.)

[^oss]: Examples from
        [1993](https://groups.google.com/forum/#!msg/comp.os.ms-windows.programmer.win32/WoBvPB0U9Co/wXfpq5nEJTYJ),
        [1996](http://www.xent.com/FoRK-archive/fall96/0269.html).
        Furthermore, the term "Open" was in wide use before the OSI (e.g.
        OpenBSD, X/Open, etc.)<br>
        I'm not suggesting that Christine Peterson is lying when she claims to
        have coined "Open Source"; it could be coined independently on several
        occasions, or perhaps she had seen the term but merely forgot about it.

A number of projects have been experimenting with "almost open source" licenses,
such as the [Commons Clause][commons]. There are a number of advantages and I'm
not principally opposed to this, but it's mostly as a response to AWS and such
offering your product as a service. I don't think this will happen with
GoatCounter, as it's not this kind of "middleware" product.

[osi]: https://opensource.org/licenses/
[osi-approval]: https://writing.kemitchell.com/2019/05/05/Rely-on-OSI.html
[commons]: https://commonsclause.com/

Licenses
--------

Looking at the available licenses, there are unfortunately not very many. Some
notes about various licenses (not intended as a comprehensive comparison; for
some I stopped after I encountered something that made it clearly unsuitable for
my purposes):

### GPL (any version)

{:class="cmp"}
- <strong class="b">Bad</strong>: doesn't have the "network protection": you
  don't need to submit changes back to me if you modify the code and run it
  *only* as a SaaS.

### AGPL

{:class="cmp"}
- <strong class="g">Good</strong>: Copyleft with network protection, requires
  badactor.com to submit code when running a SaaS.
- <strong class="g">Good</strong>: well known.
- <strong class="b">Bad</strong>: long and dense language. It's 5174 words,
  which is about half an hour of reading time (probably more to properly grok
  it).
- <strong class="b">Bad</strong>: preamble needs to complain about others taking
  away freedom. This reads like a manifesto against commercial software, not a
  license. I find it unprofessional at best. It also needs to explain "free"
  because it stubornly uses a non-standard definition that no one else uses
  (sigh). As a result, it also needs to resort to uncommon words like "gratis",
  making the legalese even harder to comprehend.
- <strong class="b">Bad</strong>: Changing it is not allowed, so I can't change
  or remove parts I don't like (such as the the preamble). On the other hand,
  that would make it non-OSI approved anyway.
- <strong class="b">Bad</strong>: some companies avoid AGPL due to its extremely
  "viral" nature. This could potentially be solved with some sort of
  dual-licensing option.
- <strong class="b">Bad</strong>: I don't like that it imposes restrictions on
  non-commercial users. If you're running a private GoatCounter for your
  personal weblog with some hacks you clobbered together then go for it! No need
  to send me your ugly hacks. Again, I may investigate some dual-licensing
  options in the future.

### Common Public Attribution License 1.0 (CPAL)

{:class="cmp"}
- <strong class="g">Good</strong>: includes network protection.
- <strong class="b">Bad</strong>: [fails Debian's Free Software Guidelines](https://lists.debian.org/debian-legal/2007/09/msg00165.html):
> [..] the Original Developer may include [..] a requirement that each time an
> Executable and Source Code or a Larger Work is launched [..] a prominent
> display of the Original Developer's Attribution Information [..] must occur on
> the graphic user interface employed by the end user [..].

### Open Software License 3.0 (OSL)

{:class="cmp"}
- <strong class="b">Bad</strong>: requires "reasonable effort" to have users
  agree to the license on distribution (e.g. downloading source or a binary).
  This is just annoying.
- <strong class="b">Bad</strong>: [fails
  DFSG](https://lists.debian.org/debian-legal/2003/11/msg00178.html) because of
  overly strong patent clause.
- <strong class="n">Note</strong>: Didn't investigate beyond these two issues;
  the attribution clause especially is not what I want.

### IBM Public License Version 1.0 (IPL)

{:class="cmp"}
- <strong class="b">Bad</strong>: no network protection.
- <strong class="g">Good</strong>: seems like better more pragmatic GPL; may use
  it in the future where I would use GPL instead (but didn't investigate
  in-depth, as lack of network protection makes it unsuitable here).

### European Union Public License 1.2 (EUPL)

{:class="cmp"}
- <strong class="g">Good</strong>: includes network protection.
- <strong class="g">Good</strong>: is drafted specifically to work with EU law,
  and has official translations to all the EU jurisdictions, which is better
  for me as an EU citizen. The translations also make it easier for non-native
  speakers to grok the license (reading legal language hard even in your native
  language, and double as hard if it's not).
- <strong class="g">Good</strong>: 2259 words; less half of AGPL's 5174 words,
  which is probably the shortest you can get for these kind of licenses (one of
  the explicitly goals was to "not be too long, too complex, but be
  comprehensive and pragmatic"). It's still not very easily readable, IMHO, but
  the translations help a bit with that.
- <strong class="g">Good</strong>: explicitly compatible with GPL and various
  other copyleft etc. This should make it much easier to re-use than e.g. the
  AGPL.
- <strong class="b">Bad</strong>: not very widely known (yet), making it harder
  to re-use. GitHub for example lacks a "quick overview" for the EUPL (something
  I'll try and fix).
- <strong class="b">Bad</strong>: Like with AGPL, I don't like that it imposes
  restrictions on non-commercial users.
- <strong class="n">Note</strong>: OSI and FSF approved, but no judgement on
  DFSG compatibility (there are discussions and no one raised specific
  objections; I don't expect problems).
- <strong class="b">Bad</strong>: The GPL Compatability is good, but the way
  it's worded less so; you can distribute *"Derivative Works"* as GPL in its
  entirety, rather than just the changes made. In other words, you can
  circumvent the stronger copyleft.

### The Parity Public License 7.0.0

{:class="cmp"}
- <strong class="g">Good</strong>: includes network protection.
- <strong class="g">Good</strong>: Plain readable language.
- <strong class="b">Bad</strong>: none of the versions are OSI-approved, FSF
  hasn't published any opinion about it. In general seems to have almost no
  opinions published about it (yet).
- <strong class="b">Bad</strong>: the copyleft clause is quite strong (more so
  than AGPL or EUPL): "Contribute software you develop, operate, or analyze with
  this software".

### Reciprocal Public License 1.5 (RPL)

{:class="cmp"}
- <strong class="g">Good</strong>: includes network protection.
- <strong class="g">Good</strong>: has a plain-language introduction, making it
  clear what the requirements are without legalese.
- <strong class="g">Good</strong>: Makes a distinction between "personal use"
  and other use. The copyleft doesn't apply for personal use.
- <strong class="b">Bad</strong>: Almost as long as AGPL (4957 words), although
  the introduction makes it more palpatable.
- <strong class="b">Bad</strong>: OSI-approved, but not considered "free" by FSF:
  > The Reciprocal Public License is a nonfree license because of three
  > problems. 1. It puts limits on prices charged for an initial copy. 2. It
  > requires notification of the original developer for publication of a
  > modified version. 3. It requires publication of any modified version that
  > an organization uses, even privately.
  I'm not really principally opposed to these terms myself, though. I don't get
  why the "no charge" clause is objectionable (GPL has a similar one). The
  requirement to notify the original developer makes sense. Waiting for me to
  perhaps accidentally stumble upon your changes is not in the spirit of
  copyleft.
- <strong class="b">Bad</strong>: also requires submitting changes if you never
  publish the software at all ("Once you start running the software you have to
  start sharing the software"), and requires documentation of all changes
  ("clearly describing the additions, changes or deletions You made"), which is
  probably a bit too strong.

### Eclipse Public License 2.0 (EPL)

{:class="cmp"}
- <strong class="b">Bad</strong>: no "network protection".
- <strong class="n">Note</strong>: Didn't investigate beyond this.

### Mozilla Public License 2.0 (MPL)

{:class="cmp"}
- <strong class="b">Bad</strong>: no "network protection".
- <strong class="n">Note</strong>: Didn't investigate beyond this.

### CeCILL 2.1

{:class="cmp"}
- <strong class="b">Bad</strong>: It's explicitly specified that French law applies.
- <strong class="n">Note</strong>: Didn't investigate beyond the above, which
  already disqualifies it for me (and I would image most non-French), but it
  doesn't seem to have the network protection and has the same GPL-compatibility
  issues as the EUPL (i.e. it's "too compatible").


Conclusion
----------

The EUPL seems to have all the same provisions as the AGPL, but with several
advantages. I see no reason to prefer the AGPL over the EUPL; the biggest issue
is the GPL-compatibility copyleft circumvention but I've worked around that by
just removing the GPL, MPL and some other licenses from the "Compatible
licenses" appendix and adding a note at the top that this list appendix was
modified.

I like the Parity License. I think a more plain-language version of the (A)GPL
is long overdue, but it's very new and has a too strong copyleft. I don't think
it's suitable for serious projects (yet), but I'm interested and intend to keep
an eye on future developments.

The RPL is interesting, and is drafted for pretty much my exact use case. It was
a strong candidate. While I'm not especially concerned about the FSF's opinion
as such, the lack of their approval does provide some practical problems and
will be an issue of contention. There need to be *very clear* advantages in
order to adopt such a "non-free" license, and I'm not sure the RPL provides
them. I may change my mind about this in the future.

In the end, I decided EUPL was the best fit for now, so I relicensed GoatCounter
from AGPL 3 to EUPL 1.2.

<style>
.cmp               { list-style: none; }
.cmp strong:before { margin-right: .3em; margin-left: -1em; display: inline-block; }
strong.g { color: green; } strong.g:before { content: "✔"; }
strong.b { color: red;   } strong.b:before { content: "✘"; }
                           strong.n:before { content: "–"; }
</style>
