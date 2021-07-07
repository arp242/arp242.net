---
title: "The problems with hard wrapping email body text"
date: 2020-04-20
tags: ['Email', 'UX']
---

I think that hard-wrapping email body at 78[^1] characters is not a good idea,
as it makes it harder for people to read your emails. The problem is that when
you hard-wrap you mandate a minimum width, and the email will look borked for
readers with a screen that's smaller than 78 characters. So something like this:

    I am a coffee broker and I live at 37 Laurier Canal. It is not my habit to
    write novels or similar things, and therefore it took some time before I
    decided to order some reams of paper and started writing the book that you,
    dear reader, have just opened, and that you should read if you are a coffee
    broker, or if you are anything else. 

Appears like this on my phone:

    I am a coffee broker and I live at 37 Laurier
    Canal. It is not my habit to
    write novels or similar things, and therefore it
    took some time before I
    decided to order some reams of paper and
    started writing the book that you,
    dear reader, have just opened, and that you
    should read if you are a coffee
    broker, or if you are anything else. 

The forced linebreaks are intermingled with the wrapping linebreaks, and there
is no way the client can figure out if a hard wrap is meaningful and can be
safely omitted; the result is not great and rather annoying to read. This is a
common issue on phones, but also on desktop clients with some UI chrome and a
small(ish) reading pane such as the 3-pane "Outlook layout".[^2]

Wrapping by character count is incorrect with proportional (non-monospace) fonts
anyway, which is what the overwhelming majority of people use. In my font the
first two lines appear two words shorter than the lines below. Not a huge issue,
but looks weird.

Wide lines are hard to read, but email clients can still enforce a maximum
width; there is nothing preventing that. It's actually common to do this on
websites by setting `max-width: ...` on the main text body (as this site does).
I don't see why this can't work for email (and many clients do this already,
bit more on this later).

[^1]: Some encourage 78, others 76 or 72; I will stick to 78 here.

[^2]: I'm not sure if Outlook was actually the first to come up with it –
      probably not – but it's the most common client where it's used by default
      today. This layout is unasable on my laptop because the screen isn't large
      enough.

---

For years I was careful in wrapping emails; I mostly use the FastMail web UI
these days as I don't use email much, and investing in mutt or whatnot is not a
good ROI for me. I would copy to/from Vim to properly wrap stuff. At some point
I realized I wasn't sure what the practical advantages there are for this, other
than "it's considered good practice". But why?

I've searched extensively to find *practical* reasons for hard-wrapping text,
and I've not managed to find any. Usually it's either stated as a given that you
should do it, or it's claimed this is mandated by the standard.

What does [RFC5322][rfc5322] say about it?

> Each line of characters MUST be no more than 998 characters, and SHOULD be no
> more than 78 characters, excluding the CRLF.
>
> The 998 character limit is due to limitations in many implementations that
> send, receive, or store messages which simply cannot handle more than 998
> characters on a line.
>
> [..]
> 
> The more conservative 78 character recommendation is to accommodate the many
> implementations of user interfaces that display these messages which may
> truncate, or disastrously wrap, the display of more than 78 characters per
> line, in spite of the fact that such implementations are non-conformant to the
> intent of this specification (and that of [RFC5321] if they actually cause
> information to be lost).  Again, even though this limitation is put on
> messages, it is incumbent upon implementations that display messages to handle
> an arbitrarily large number of characters in a line (certainly at least up to
> the 998 character limit) for the sake of robustness.

There are a few things to note about this: the first is that it talks about
"line of characters"; SMTP is a line-oriented protocol, so (very) long lines can
cause issues, hence the 998 limit. This is transparently fixed in practically
every email client with `quoted-printable`; this email:

    Content-Transfer-Encoding: quoted-printable

    hello=
    world

Gets rendered on a single line (`helllo world`); SMTP sees two lines, but the
user sees one.

The second is that is explicitly mentions that email clients that don't handle
long lines as non-conformant. 

It seems to me that "hard-wrap all text at 78 characters" is a misreading of the
standard and a confusion between "how things should be sent on the wire" and
"how things should be displayed". The standard also doesn't allow NULL bytes,
but that's why we have base64 so we can send pictures and whatnot.

The previous RFC 2822 from 2001 (which is replaced by 5322) has a similar
message. [RFC 822][rfc822] from 1984 doesn't mention wrapping of body text at
all as far as I can find, but does mention the wrapping ("folding") problem, in
the context of headers:

> Note: Some display software often can selectively fold lines, to suit the
> display terminal. In such cases, sender-provided folding can interfere with
> the display software.

As far as I can see, there is nothing in any standard preventing you from
writing an email where entire paragraphs are just on a single line.


[rfc5322]: https://tools.ietf.org/html/rfc5322#section-2.1.1
[rfc822]: https://tools.ietf.org/html/rfc822

---

There's a middle-ground between hard wrapping and long lines: *format flowed*
([RFC 3676][rfc3676]), which distinguishes between "hard" and "soft" line
breaks. The idea is that email clients can still display the soft breaks as-is
if they want to, but you can also "reflow" them to fit the screen width. This is
basically how Markdown works (the original, not the "GitHub flavoured
Markdown").

But it's not widely supported, in spite of being around since 1999. Presumably
the reason for this is that simply writing long lines and having the email
client break them at its discretion works well enough for the vast majority of
users.

This isn't perfect since sometimes you really *don't* want the email client to
insert line breaks; this, again, is easily solved for most people by just using
HTML email and a `<pre>` tag.

The people who insist on hard-wrapped emails are usually also opposed to HTML
email. This is part of a certain mindset that I've come to call *Hacker
Conservatism*. Things like email were invented in the 70s, and refined in the
80s, but since then a lot of things have changed. In *Hacker Conservative*
circles there seems to be a lack of understanding that not everyone uses
computers as they do, and that the old way is the *One True Way*, any
pragmatical issues many people run in to be damned!

"Educating" an entire population on how to do it "correct" because they're all
"wrong" seems not just like a fool's errand, but also rather arrogant. You're
essentially just saying everyone should adjust to your personal preferences.
Meh.

So these days I just write paragraphs on a single line[^3], which will look
great for everyone unless you're not soft-wrapping the text, but that is a
choice you're making yourself.

[^3]: The motivation for writing this was someone telling me off for doing this.

[rfc3676]: https://tools.ietf.org/html/rfc3676
[gmail]: https://mathiasbynens.be/notes/gmail-plain-text
