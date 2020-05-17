---
layout: post
title: "Experiences with email-based login"
tags: ['GoatCounter', 'Email', 'UX']
hatnote: |
 Discussions:
 <a href="https://lobste.rs/s/kjm4nu/experiences_with_email_based_login">Lobsters</a>.
---

GoatCounter 1.2 (due to be released later today or tomorrow) will switch from
email-based authentication to password authentication.

The way it originally worked is that you would sign up with your email, and to
login a "magic link" with a secret token would be emailed to you, which will set
the cookie and log you in.

I did it like this after a [suggestions/discussion at Lobste.rs][l] last year,
and I thought it would be easier to implement (it's not) and easier for users
(it's not).

[l]: https://lobste.rs/s/kkfmoi/getting_toasty_observations_on_burnout#c_9d1rd6

Some problems I encountered:

- Some (perhaps even many?) people use password managers, and for them the whole
  email thing is an annoyingly different workflow. The built-in Firefox password
  manager has actually seen quite a few nice improvements recently, making it
  easier than ever.

- Getting 100% of emails delivered is hard and requires quite some setup.

- It's harder to get the self-hosted setup running, since emails are a hard
  requirement.

- If you lose access to your email, you lose access to your account.

  One issue I had is people misspelling their email during signup, so they were
  immediately locked out of their account. This is an issue especially on
  GoatCouner since people choose a domain code (`mycode.goatcounter.com`) during
  signup, and this code is now "taken" if they choose to re-register.

  It's pretty hard to test if an email is deliverable without sending an actual
  email (and even then you don't know, as the receiving server may silently drop
  it or classify it as spam).

  I got quite a few "undeliverable email" returns from the "please set a
  password"-announcement I sent this morning, and these people will never be
  able to login unless they email me and ask me to change their email manually.
  I presume these are inactive accounts, but still...

- I found it annoying to use myself:

  1. Go to arp242.goatcounter.com
  2. Enter my email.
  3. Go to FastMail.
  4. Wait 10 seconds to 5 minutes for the email to arrive.
  5. Click the link, opening a new logged-in goatcounter tab.
  6. Close the old goatcounter tab where I filled in my email and FastMail tab.

  Whereas with password auth it's:

  1. Go to arp242.goatcounter.com
  2. Enter my email and password.

- It's quite a bit of code to deal with various edge cases, allowing people to
  configure the From address, etc. The code is neither simpler nor shorter than
  just using password auth.

- It's harder in development. I added some special code to show the signin link
  when using `-dev` so I didn't have to copy it from the GoatCounter logs, but
  meh.

- The signin links doesn't always work: they're valid only once and I *think*
  some "preview" or "prefetch" logic accessed the URL and invalidated it, but I
  never quite got to the bottom of it in spite of quite a bit of effort (I never
  experienced it myself, just got user reports).

  This is fixable by allowing the link to be re-used within 15 minutes or so,
  but this was really the straw that made me implement the password auth.

In some other use cases it might work better, but for GoatCounter it didn't
really work very well (the Lobsters thread linked above has some people report
different experiences).

---

I considered allowing both email and password auth, but that's more code to
maintain and more flags in the CLI, so figured it's best to just remove the
email auth. I'm not sure if anyone truly likes it.

In my own experience outside of GoatCounter as a user I find logging in with
some magic token (Medium sends emails, Tinder sends SMS) annoying in general.
Then again, I also find logging in with a strong password on mobile annoying and
the value of some token-based auth is probably greater there. I'm not sure what
the best solution is here, but I do know that forcing *everyone* to use
token-based authentication is probably not a good idea.

The Firefox password sync solved most of my issues here. I was wary of syncing
passwords from the browser for a long time, but found myself changing and
re-using passwords just to log in on mobile, which is even less secure.

I might bring back some token-based auth in the future as an auxiliary method,
sending tokens over SMS or Telegram is probably easier here. But for now,
there's bigger fish to fry in GoatCounter.
