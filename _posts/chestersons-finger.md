---
title: "Chesterton's middle finger"
date: '2026-06-22'
tags: ['Programming', 'Workplace']
---

The [Chesterton's fence] analogy says that you need to be careful to change
things if you don't understand why things are the way they are, because there
may be good reasons you haven't considered yet. This is broadly good advice in
many different contexts, including programming where it can be easy to "fix"
some weird code only to discover there was a reason for the weirdness later on
when things break.

This is Chesterson's middle finger:

    # List all commit body content (but not the subject line)
    % git log --no-merges --format=format:'%b' | sed '/^$/d' | wc -l
    295

That's 295 lines of commit text over the last 13 years. In total. The commit
subjects are usually just "fix page A" – even for huge changes – and are
pointless. If I manually remove some dependabot, "revert commit", and "fix typo"
commit bodies it's just 167 lines. That's about one line a month.

There is no other documentation. There are barely any comments in the code.

This is Chesterson's middle finger: "Yes, we did all these weird things and
we're not telling anyone why. Haha fuck you."

This is not the first time I've seen a less-than-useful commit log, but it is
the first time I'm hired after everyone else left. There is no one to ask.

In theory there was a three week handover period from the previous developer,
but that was just as communicative as the commit log. Never have I sympathized
more with Jack Bauer's methods to extract information and I regret not employing
some of them.

There are unfinished refactors. There are left-overs from removed features.
There are features that were added but never linked/used but are still in the
code. There are features no one seems to be using. Overall it seems to suffer
quite badly from [Chesterton’s gap] ("There isn't a fence yet? Lets build
fences!" without asking if a fence is actually needed).

Everything is just a big fat middle finger.

---

Writing *well* is hard. Writing something vaguely passable is not. By and large
there are three questions to answer: "What are you changing?", "why are you
changing it?", and "why is this a good solution?"

Sometimes "Implement new feature X" is enough, although it's rare there is
nothing more to say – most of the time there is *something* to say about how/why
it's added as it is.

If you're fixing a bug, refactoring or changing things, or making some other
substantial change then it's very rare there isn't at least a paragraph or two
to comment on the "what's changing, why change it, and why is this good?"
questions.

Writing this is not an optional extra; it's part of the job. If you're not doing
it then you're not doing your job as a software developer. It doesn't need to be
eloquent. It doesn't need to be perfect English. It doesn't need to be a
comprehensive essay on the nature of reality. It's okay to forget something
(although better if you don't). It just needs ... *something*. Any half-way
serious attempt will be infinitely better than *nothing at all*.

If you do *nothing at all* then you're just giving everyone after you the
finger.

[Chesterton's fence]: https://fs.blog/chestertons-fence/
[Chesterton’s gap]: https://stephantul.github.io/blog/unfence/
