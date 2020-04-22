---
layout: post
title: "Tired of Stack Overflow"
tags: ['Community']
hatnote: |
 Discussions:
 <a href="https://lobste.rs/s/pmldds/tired_stack_overflow">Lobsters</a>,
 <a href="https://news.ycombinator.com/item?id=20859332">Hacker News</a>,
 <a href="https://www.reddit.com/r/programming/comments/cysae4/tired_of_stack_overflow/">/r/programming</a>.
 <br><br>
 Note: this post is something of a rant, and uses strong and emotional language.
 It's born out of a years-long frustration with seeing almost every single
 suggestion to make Stack Overflow a friendlier place not just rejected, but met
 with hostility.
---

I've been active on Stack Overflow in some form or the other since 2011, and
I've grown increasingly tired of it.

There are many reasons for this – not all of them are Stack Overflow's fault –
but what prompted this post was a [basic but valid question][wtf] getting
downvoted to -4 (it's now -3, since I added an upvote):[^vote]

[^vote]: The question has reached a significant amount of votes after this post
         went to the frontpage of Hacker News and /r/programming.

> Is there a way to list all standard Go packages? I have a list of packages and
> I want to figure out if this is a standard package.

Seems like a pretty valid question to me, so why is it downvoted to -4? Stack
Overflow is intended to [build a collection of useful question to the
programming community at large][goal], and this question is exactly the sort of
thing that will be useful to others as well. There are even multiple valid
answers, none of which show up in the first two pages of Google results, and the
answers are not completely obvious from the documentation either (`go list std`
is not documented in `go help list`, and `golang.org/x/tools/go/packages` is
fairly new, and the kind of thing you just have to know about).

Fun fact: this question now sits on the first page of Google results for "go
list standard packages", and is the only link which contains the actual answer.

Fun fact 2: the very similar question "[how to list all packages][old]" from
2015 has a +24 score with no downvotes.

Stack Overflow has downvotes to add a degree of quality control to the site, so
people looking to answer questions questions can more easily filter out unclear
or off-topic questions. Great! But how does that apply here?

I have no idea why this is downvoted at all, much less to -4. I'm also wondering
what went through the head of the person who saw the question at a score of -3
and just *had* to add their own downvote because "fuck this question just a
little bit more". Downvotes are useful for quality control, but there is no real
difference between -3 and -4.

Not only is this question useful, it's also exactly the sort of question that
Stack Overflow is useful for: "*How do I do X?"*. Often, *X* is quite a simple
thing, like *"append to a list"*, or *"merge two dictionaries"*. I find that the
longer I program with all sorts of different languages, the more I struggle
remembering all that sort of stuff. I spent 2 years programming Ruby 40 hours a
week, but that was 5 years ago; I remember much of the syntax and semantics, but
have forgotten much of the standard library.

For example, I recently wanted to know how to merge dictionaries in VimScript.
Turns out that [search results][merge-search] were not that helpful (lots of
Python answers, [one outdated Vim answer][merge-list]) so [I asked a
question][merge-q] and answered it myself. Now it's on top of the search
results, being useful to everyone who has the same question in the future.

[merge-search]: https://duckduckgo.com/?q=How+can+I+merge+two+dictionaries+in+Vim%3F
[merge-list]: http://vim.1045645.n5.nabble.com/vim7-merging-of-dictionaries-td1195738.html
[merge-q]: https://vi.stackexchange.com/q/20842/51

---

The -4 is a mild example, [this question][inf][^del] got downvoted to -46
(+29/-75). Sure, it's a very basic question, and certainly asked by a beginner.
Arguably it's not a good fit for Stack Overflow, but it did get closed as a
duplicate of a question with a score of +34 (+38/-4), and it wasn't an
effortless or "lazy" question either. There is no "quality control" in
downvoting a question to double-digits. The simple truth is that you're just
being a gigantic twat if you keep piling on votes like that. If you think that's
harsh then take a deep breath and consider the perspective of the person who
asked the question. I don't think I ever have been more disappointed in the
Stack Overflow community than with that question.

[^del]: Now deleted, but people with more than 10 000 reputation can still see
        it; [screenshot](/images/inf-ss.png).

If you're wondering why that question got those amounts of downvotes: it was the
topic [of a Meta question][infmeta]. People came in on Meta, and just *had* to
vote. This is not uncommon, and even has a name: ["the Meta effect"][metaeff].
Can people truly not comprehend how downvoting a post to -10 (or more) is
perceived by the author of that post? Considering many incidents like this and
the overwhelmingly negative feedback to almost any suggestion that would make
the site less abrasive (e.g.
[this](https://meta.stackoverflow.com/a/356263/660921),
[this](https://meta.stackoverflow.com/a/340177/660921)), it would seem that
quite a lot of people genuinely don't understand.

There are others aspects of the Stack Overflow system that can be harsh and
abrasive, most notably the closing of questions. There's a good reason questions
are closed – just like downvotes exist for good reasons – but there seems to be
a complete lack of understanding how that is often perceived.

To be fair, a big part of the problem is that the UI and feedback sucks. I've
always felt that fairly simple changes such as rephrasing *"your question was
put on hold"* to something like *"waiting for more information before we can
provide an answer"*  and showing "-4" as *"your question needs improvement"*
would make a big difference.

---

Every time these kind of topics get brought up on Meta people get *very*
defensive and shout "quality!" As if you need to be a dick to maintain
"quality". It's a false dichotomy: you can have quality *and* be nice, but there
is a complete unwillingness to even discus it.

In general I find Meta an unfriendly place. It's no surprise that Stack Overflow
(the company) pretty much ignores Meta; the community can be borderline abusive.
I still remember how Meta reacted to the Documentation effort of a few years
ago. In particular I felt bad for Jon Ericson because he tried very hard to be
constructive and to make it work. I too was critical of a lot of aspects of
Documentation, but far too much wasn't constructive, was just repeating the same
stuff *ad nauseam*, or was phrased very hostile.

I don't want to attack everyone on Meta, because there are also many great
people, but the overall atmosphere is not pleasant. It's tiresome, so for the
most part I just stopped trying to make things better which only resulted in
even more selection bias in Meta.

Meta, in general, has an overinflated sense of self-importance and entitlement.
Many genuinely seem to think they represent the community, while in fact they
just represent a small part because the rest got tired of them and left. As with
many of these communities: it's not who is right who wins the argument, it's the
one who is most active and most persistent. Some people call this "meritocracy"
🤷 Also see: [The other kind of censorship](/censorship.html).

[wtf]: https://stackoverflow.com/q/55807322/660921
[goal]: https://twitter.com/codinghorror/status/991082088689381376
[old]: https://stackoverflow.com/q/28166249/660921
[inf]: https://stackoverflow.com/q/35518226/660921
[infmeta]: https://meta.stackoverflow.com/q/318482/660921
[metaeff]: https://meta.stackoverflow.com/q/269349/660921

---

Here's another thing I'm completely fed up with: the "know-it-better". People
who just *love* to show they actually know stuff better. Here's a recent example
on a Go question (entire comment):

> There is no “pass by reference”, so I’m not sure where you got that. You’re
> simply passing the value, which is a copy and not going to change the
> original.

Technically correct, but everyone understands that "pass a pointer" was
intended. Yes, a new programmer got their terminology a bit incorrect (it is
confusing!) and a note correcting that is fine, but this isn't that. This is
going out of your way to supposedly not understand what the OP is asking, and
parading that they're stupid and wrong, while beating your chest about how much
smarter you are. Congratulations. Wipe off the spunk from your egowank already.

I think this is also one reason for the ridiculous downvotes from the previous
sections: *"look how stupid that guy is, and look how clever I am pointing that
out with my downvote!"*

This is exactly the sort of condescending attitude people are so tired of. I am,
anyway, and it's not even directed at me.

Sometimes it can be hard to fully realize the impact of a certain type of
behaviour if you've never experienced that kind of behaviour yourself. Many
people are only on one side (asking or answering), and they never really
experience the "other side".

I used to smoke a long time ago, and back in the day you were allowed to smoke
in most places: the workplace, restaurants, public transport. I smoked in those
places. I was raised in an environment where everyone smoked (inside the house!)
so I had always been used to the smell of tobacco smoke. I never saw a problem
with it.

Until I quit, that is, and experienced a mostly smoke-free environment for the
first time in my life. And hot damn was I ashamed of my previous behaviour once
I actually started noticing the horrible smell of tobacco!

---

No one can deny that Stack Overflow is very successful: search any programming
question and there's a good chance you'll get an answer on the first page of
Google results. How different it was before Stack Overflow!

Some argue that all of this abrasiveness contributed to this success by
maintaining "quality". I don't buy it. Many other Stack Exchange sites are *not*
abrasive like this and have similar *or better* quality. I'd argue that Stack
Overflow is a success *in spite* of all of the above, rather than *because* of
it.

A lot of people complain that the site has many more low quality questions than
it used to have. I tend to agree. This, apparently, justifies being a dick:

> SE forces us to constantly interact with a stream of garbage; that will
> inevitably create hostility.

Because "not saying anything" is not an option at all 🙄🤷

I have an alternate theory:

1. People are hostile.
2. Reasonable people tend to stop coming.
3. Who is left? Just the assholes, the clueless, and the people desperate to ask
   questions because they need it to do their job.

In other words, it's a bed of their own making.

The question is: does Stack Overflow want to be a site that people tolerate, or
one that people *like*?

<!--
If large amounts of people find you hostile and abrasive then you almost
certainly are. 
-->


Way forward
-----------

It's my observation that it's only a fairly small percentage of people who
consistently engage in this kind of behaviour. In some tags that I follow (or
used to follow) I can even point to the 1 or 2 people who are responsible for
\>80% of the shit.

But managing this is really hard. Most of us make a harsher-than-intended
comments every once in a while, and that's okay. It's the consistency and
long-term patterns that are an issue. Most of the time these people never cross
any hard lines (e.g. telling people that they're dumb), so it's hard to take
action unless you're really on top of things.

These problems are not endemic to the Stack Exchange platform. A lot of these
problems are *not* present on some other Stack Exchange sites. The Vi & Vim
Stack Exchange is *much* better in my opinion (I am a moderator there, so I may
be biased). We actually had one user being a condescending prick for a while, so
we kicked him off. The site has been much better ever since.

A rethink of the way moderation works might be a good idea; there are a whole
bunch of Stack Overflow mods, but there are many more tags, and many tags don't
have any mods regularly observing people's for
not-quite-insulting-but-unpleasant attitudes.

And, as mentioned before, just make the UI communicate things less abrasive. Why
show "-4" to someone? That's not really useful guidance for the OP, whereas a
*"Your question was poorly received, here are some tips that might make it
better"* message would be. Downvotes aren't to punish people, they're to make
people improve their questions.

---

At least several people in Stack Overflow (the company) realize not all is well.
For example the [Stack Overflow isn't very welcoming][welcome] post from over a
year ago actually echoes a lot of my own sentiments, such as *"let’s reject the
false dichotomy between quality and kindness"*. Great! Seems we arrived at the
same conclusions.

Yet ... nothing has changed.

The new [Code of Conduct][coc] hasn't changed much. Personally, I still think
the old [be nice][benice] policy was better phrased anyway, and you can write
all the rules you like; it's about enforcement. The entire thing was a
distraction, IMHO.

And these kind of sentiments aren't new either: [in 2014 people had similar
sentiments][2014], and I'm sure you can find even older ones if you search
enough.

I know many community Managers as kind and empathic people who genuinely care
about this sort of stuff (even though they may not agree with all the
particulars I've written here), and I *do* appreciate they're in a tough spot.
There are no "quick fixes" here. But on the other hand, it seems that things are
kind of in a stalemate, where everyone accepts that the status quo sucks but no
one dares to take the (drastic) action that's needed.

And the drastic actions that *do* get taken are meaningless and insignificant,
like the whole [Hot Network Questions
drama](https://meta.stackexchange.com/a/316976/166789). If you think that an
innocent and valid question about sexual relationships is the reason people
don't like Stack Overflow then you've never been to Stack Overflow. A lot of
effort, goodwill, stress, and time was lost on that which could have been much
better spent elsewhere.


[welcome]: https://stackoverflow.blog/2018/04/26/stack-overflow-isnt-very-welcoming-its-time-for-that-to-change/
[welcome2]: https://stackoverflow.blog/2019/07/18/building-community-inclusivity-stack-overflow/
[2014]: https://meta.stackoverflow.com/questions/251758/why-is-stack-overflow-so-negative-of-late
[..]: https://meta.stackoverflow.com/questions/381212/is-the-intensity-of-meta-working-in-our-favor-or-to-our-detriment

[coc]: https://stackoverflow.com/conduct
[benice]: https://web.archive.org/web/20180101151003/https://stackoverflow.com/help/be-nice
[new]: https://insights.dice.com/2018/08/10/stack-overflow-new-code-conduct/


<div class="postscript">
<strong>Related articles</strong>
<ul>
<li><a href="https://www.embeddedrelated.com/showarticle/741.php">My Love-Hate
Relationship with Stack Overflow: Arthur S., Arthur T., and the Soup Nazi</a></li>
</ul>
</div>
