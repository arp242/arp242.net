---
layout: post
title: "Why is no one signing their emails?"
---

I received this email a while ago:

> Queensland University of Technology sent you an Amazon.com Gift Card!
>
> You've received an Amazon.com gift card! You'll need the claim code below to
> place your order.
>
> Happy shopping!

University of Queensland? Why would they send me anything? Where is that even?
Australia right? That's the other side of the world! Looks like spam!

It did look pretty good for spam, so I took a second look. And a very close
third look, and then I decided it wasn't spam.

I was still confused why they sent me this. A week later I remembered: half a
year prior I had done an interview regarding my participation on Stack Overflow
for someone's paper; she was studying somewhere in Australia – presumably the
university of Queensland. No one had ever mentioned anything about a reward or
Amazon gift card so I wasn't expecting it. It's a nice bonus though.

---

Here's the thing: I've spent several years professionally developing email
systems; I administered email servers; I read all the relevant RFCs. While there
are certainly people who are more knowledgable, I know more about email than the
vast majority of the population. And I still had to take a careful look to
verify the email wasn't a phishing attempt.

And I'm not even a target; I'm just this guy, you know? [Ask John Podesta what
it is to be targeted](https://en.wikipedia.org/wiki/Podesta_emails#Data_theft):

> SecureWorks concluded Fancy Bear had sent Podesta an email on March 19, 2016,
> that had the appearance of a Google security alert, but actually contained a
> misleading link—a strategy known as spear-phishing. [..]
> The email was initially sent to the IT department as it was suspected of being
> a fake but was described as "legitimate" in an e-mail sent by a department
> employee, who later said he meant to write "illegitimate".

Yikes! If I was even remotely high-profile I'd be crazy paranoid about all
emails I get.

It seems to me that there is a fairly easy solution to verify the author of an
email: sign it with a digital signature. Either S/MIME or PGP will do. I don't
even care about encryption here, just signing to prevent phishing.

It's not hard to do; S/MIME works more or less the same as HTTPS: you get a
certificate from the Certificate Authority Mafia, sign your email with it, and
presto. Not very hard. Many email clients already support verifying S/MIME
signatures (and more will implement support once people actually start using
it). I implemented S/MIME signature verification in a Ruby on Rails app once. It
was about ten lines of code.

PGP could also be used; we can bypass much of the key exchange dilemma by just
shipping email clients with keys for large organisations (PayPal, Google, etc.);
like browsers do with some certificates. Or publish the keys on a DNS record.
Even just publishing them on your website (or, if you're a bank, in local
branches etc.) so people can manually add them to their keyrings is a lot better
than *not signing anything at all*!

Is it perfect? No. I understand stuff like key exchange is hard. Is it better?
Hell yes. Would probably have avoided Podesta and the entire Democratic Party a
lot of trouble.
Here's a "[sophisticated new phishing
campaign](https://www.eset.com/us/about/newsroom/corporate-blog/paypal-users-targeted-in-sophisticated-new-phishing-campaign/)"
targeted at PayPal users. How "sophisticated"? Well, by not having glaring
stupid spelling errors, duplicating the PayPal layout in emails, duplicating the
PayPal login screen, a few forms, and getting an SSL certificate. Truly, the
pinnacle of Computer Science.

Okay sure, they spent some effort on it; but any nincompoop can do it; if this
passes for "sophisticated phishing" where "it's easy to see how users could be
fooled" then the bar is pretty low.

---

I can't recall receiving a single email from any organisation that is signed
(much less encrypted). Banks, financial services, utilities, immigration
services, governments, tax services, voting registration, Facebook, Twitter, a
zillion websites ... all happily sent me emails *hoping* I wouldn't consider
them spam and *hoping* I wouldn't confuse a phishing email for one of theirs.

Interesting experiment: send invoices for, say, a utility bill for a local
provider. Just copy the layout from the last utility bill you received. I'll bet
you'll make more money than freelancing on UpWork if you do it right.

I've been intending to write this post for years, but never quite did because
"surely not everyone is stupid?" I'm not a crypto expert, so perhaps I'm missing
something here, but I wouldn't know what. Let me know if I am.

There are probably a few factors that impede the implementation of signing:

- Conflation between "signing" and "encrypting". Two very different things, but
  the same tools are used for both. Encryption is a lot harder as there's
  usually zero margin for error: everyone needs to be able to decrypt your
  emails. For signing there's more margin; it's okay if half the people never
  verify your signatures.

- Confusion between every-day "random person A emails random person B"-usage
  versus "large company with millions of users sends thousands of emails
  daily"-usage. Certainly for PGP/GPG a lot of the effort seems to be focused on
  the first scenario, which is great, but probably not the most pressing problem
  to solve right now.

In the meanwhile PayPal is not solving the problem by publishing [articles which
advice you to check for spelling
errors](https://www.paypal.com/cs/smarthelp/article/how-to-spot-fake,-spoof,-or-phishing-emails-faq2340).
Okay, it's good advice, but do we really want this to be the barrier between an
attacker and your money? Or Russian hacking groups and your emails?

The way forward is to make it straight-forward to implement signing in apps and
then *just do it* as a developer, whether asked or not; just as you set up https
whether you're asked or not. I'll write a follow-up with more technical details
later.
