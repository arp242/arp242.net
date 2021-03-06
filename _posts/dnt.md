---
title: "Why GoatCounter ignores Do Not Track"
date: 2020-01-04
tags: ['GoatCounter', 'Web', 'Politics']
---

GoatCounter doesn't support the `Do-Not-Track` (DNT) header, and that's a
feature. 

DNT is a way for tracking companies to pretend that they're doing something
without actually doing something meaningful. They know full well that most
people will never visit their browser's setting page, and only a small subset
will actually enable this setting. Compliance is voluntary anyway, and can be
interpreted in many different ways.

[Most people don't like persistent tracking][poll], and [ethical
concerns][ethics]<sup>\[[Google Docs][ethics-docs]]</sup> go back many years
(the *"ethical challenges to behavioral targeting"* chapter especially is worth
reading; I'm not going to repeat the arguments here).

If something is widely considered unethical then it *should not be done at all*,
instead of relying on savvy-enough consumers to opt-out of the unethical
practice, especially when consumers need to actively hunt for the opt-out
mechanism. You can't expect every consumer to be deeply invested and informed
about every topic. We all have jobs, spouses, children, hobbies, and a long list
of other issues we care about.

The extent and scope of tracking is in constant flux, and even savvy users will
have a hard time determining what *exactly* is being tracked by whom. The
[Google Privacy Policy][google-privacy] is so vague and full of words like "may"
that no one can really determine what it concretely means; what *exactly* am I
agreeing to? Take [Why is Stack Overflow trying to start audio?][audio] for
example, nowhere is it mentioned in Google's or Microsoft's Privacy Policy that
they "may" use an unrelated API to sneakily collect data about you, yet they're
still doing it.

In short, DNT allows those with a interest in tracking to *claim* they're doing
something, while not *actually* affecting all that much in practice.

[poll]: https://www.amnesty.org/en/latest/news/2019/12/big-tech-privacy-poll-shows-people-worried/
[ethics]: https://www.researchgate.net/publication/271753939_Legal_and_Ethical_Challenges_of_Online_Behavioral_Targeting_in_Advertising
[ethics-docs]: https://docs.google.com/document/d/15fJVogQxIPsxkolPjVWsA89kcdxohdGKa1WdoI1TKAE/edit?usp=sharing
[google-privacy]: https://policies.google.com/privacy?hl=en-US
[audio]: https://meta.stackexchange.com/q/331960/166789

---

The [DNT specification][spec] defines "tracking" as *"collection, retention, and
use of all data related to the request and response"*, but that is too broad and
not a useful definition. Should DNT prevent things like error logs with request
information? Rate limiters based on IP address? Spam prevention? Any and all
statistics about the number of visitors? Probably not.

The introduction is more specific and reasonable on what kind of "tracking" it's
intended to combat:

> In the status quo: A user navigates a sequence of popular websites, many of
> which incorporate content from a major advertising network. In addition to
> delivering advertisements, the advertising network assigns a unique cookie to
> the user agent and compiles observations of the user’s browsing habits.
>
> With Do Not Track: A user enables Do Not Track in her web browser. She
> navigates a sequence of popular websites, many of which incorporate content
> from a major advertising network. The advertising network delivers
> advertisements, but refrains from THIRD-PARTY TRACKING of the user.

But, this is not what GoatCounter does, it just collects some basic statistics
about how many people visit your site. To give a real-world analogy: it just
counts how many people are entering your shop through which door. What it
*doesn't* do is then follow those people after they've left your store to see
which other stores they visit, snoop on as much personal details as possible,
and create a profile based on that. That's what tracking is, and is just not the
same thing as what GoatCounter is doing.

[dnt-track]: https://www.digitaltrends.com/computing/do-not-tracking-tools-do-nothing/
[spec]: https://www.ietf.org/archive/id/draft-mayer-do-not-track-00.txt

---

From a practical point of view, we can safely conclude that DNT is a failed
initiative. Very few trackers actually do anything with it. The only programs
that honour DNT are those where it doesn't really matter all that much anyway
(like GoatCounter). The more financial interest there is in tracking, the less
likely it's honoured in a meaningful way.

Because few people set DNT in the first place it ironically [makes your browser
*more* unique and trackable][dnt-track].

The W3C disbanded the DNT working group and the proposal is dead in the water.
It's time to move on and investigate alternatives, instead of clinging to a
failed proposal.

---

Why do people want it? I think because many people feel powerless against
tracking, and this is one of the few actions they *can* take. It seems a good
example of [*politician's logic*][logic] from *Yes, Minister*:[^ym]

> "He is suffering from politician's logic."
>
> "Something must be done, this is something, therefore we must do it."
>
> "But doing the wrong thing is worse than doing nothing."

So what *can* we do then? As individual consumers ... not all that much,
unfortunately. Using Firefox instead of Chrome probably helps a bit, as does
using an adblocker, and maybe frobbing with a setting or two. But it would be
foolish to believe it will stop all tracking/fingerprinting.

Legislation like the GDPR are more effective in protecting consumers' privacy,
but it does have problems: essentially trackers can keep doing what they want if
they "ask consent". In practice it just means people get a popup they click away
as opt-outing of every website is a lot work: a lot of the forms plain suck, in
some I had to click literally *dozens* of toggles.

Again, you can't expect every consumer to be deeply invested in the issue, and
as mentioned before, it's not even easy to find out what *exactly* is being
tracked in the first place so it's not all that clear what you're consenting to.
I don't like tracking, but on practice I often click "yes" anyway as I got a
life to live and shit to do.

Using consent as a basis is flawed anyway. "But you consented to this clearly
unethical thing" is the [material of comedy sketches][liver].

Still, better GDPR enforcement is a good start we can implement *now*, and GDPR
gives consumers some reasonable rights such as the right to know what data is
collected, and the right to have that data removed.

Another thing we can do is to make sure there are good alternatives available.
This is essentially what I'm trying to do with GoatCounter, as I found there are
simple [no *free* alternatives to Google Analytics][rationale]. It's easy to
chastise people for using Google Analytics, but it's also unrealistic to expect
everyone to either shell out $10/month or self-host complex software for their
personal weblog. I know this is not realistic for everything (it will not be so
easy to displace e.g. Facebook), but I do think there's much to gain here.


[rationale]: https://github.com/zgoat/goatcounter/blob/master/docs/rationale.markdown
[logic]: https://www.youtube.com/watch?v=vidzkYnaf6Y
[liver]: https://www.youtube.com/watch?v=Sp-pU8TFsg0

[^ym]: A little aside on [*Yes Minister*](https://en.wikipedia.org/wiki/Yes_Minister):
       it's really good; you should watch it. The stuffy setting and decor can
       be a bit off-putting, but it's got a lot of sharp observations which
       apply today just as much as they did in the early 80s.
