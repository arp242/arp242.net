---
layout: post
title: Generate passwords from the commandline
categories: programming-and-such
---

I needed to generate a random password from a shell script, I figured that this
was solved long ago, so I turned to *teh interwebz* to quickly copy/paste a
working solution. Inspecting [the][moar1] [first][moar2] [few][moar3]
[links][moar4] that turned up, I noticed many of the proposed solutions are
dubious at best.

The date ain’t random, buddy
----------------------------

The most obviously wrong are:

	$ date +%s | sha256sum | base64 | head -c32
	$ date | md5sum
	$ ping -c 1 yahoo.com | md5 | head -c8

To paraphrase a quote from <del>holy scripture</del> The Hitchhikers guide to
the Galaxy: *“This is obviously some strange usage of the word ‘random’ that I
hadn’t previously been aware of”*.

Both SHA256 & MD5 also output in hex, so that would limit the total amount of
characters to just 16, instead of 92.

tr means translate characters
-----------------------------

Most of the other commands suffer from a dubious usage of `tr(1)`.

`tr(1)` [works on characters][tr], not byte streams, `/dev/urandom` outputs a
byte stream, not characters. If your locale is set to (extended) ASCII or a
variant thereof (ISO-8859-1, Windows-1252) this is more or less okay, since
every byte is a character or escape code.

With UTF-8 or another multibyte character sets it gets more complicated. Not
every random byte stream is a valid set of UTF-8 characters, the chances of a
random byte stream also being a valid UTF-8 character stream are small.

Yet, it appears to work on Linux with GNU `tr`. Why? Here’s a clue:

	$ echo 'I løv€ π' | tr '[:lower:]' '[:upper:]'
	I LøV€ π

	$ echo 'I løv€ π' | tr øπ€ X
	I lXXvXXX XX

We would expect the ø and π to be uppercased, but they’re not, and the ø, π, and
€ getting replaced by 2 or 3 X’s?

The astute reader will have recognized what this means, GNU `tr` doesn’t handle
multibyte characters, and always assumes an ASCII character set, which is
somewhat disappointing, since it’s 2014, not 1974.

FreeBSD, for example, does this correctly, it also gives an error message on
invalid UTF-8 sequences:

	$ echo 'I løv€ π' | tr '[:lower:]' '[:upper:]'
	I LØV€ Π

	$ echo 'I løv€ π' | tr øπ€ X
	I lXvX X

	$ head -c5 /dev/urandom | tr X Y
	tr: Illegal byte sequence

	$ setenv LC_CTYPE C

	$ head -c5 /dev/urandom | tr X Y
	f��!�

The moral here is: **byte streams are not character streams**, don’t use ’em as
such. It may work for now, but whenever someone adds multibyte support to GNU
tr, your command will fail. It’s 2014, **always assume multibyte**.

Other problems
--------------

While I’m whining anyway…

	$ openssl rand -base64 8 | md5 | head -c8

Using `openssl rand` is a good idea, but piping it to md5 isn’t. base64 gives me
64 characters, md5 gives me 16, making the password *a lot* easier to brute
force. Also, 8 characters is too short, use at least 15.

	$ curl -s http://sensiblepassword.com/?harder=1

Getting a random password from the internet is spectacularly stupid & naive.
Someone now knows:

- A password you are using for some service or site
- Unique personal details about you (IP address, browser/environment info)

I can now cross-reference the info with other data collected about you. For
example, you once posted to a mailing list, your IP address is in the mail’s
header, so we now have a password, name, and an email address. I hope you can
finish the scenario from here…

Just don’t do this. Ever. Randomly banging on the keyboard is a lot better.

Good solutions
--------------

	$ strings -n 1 < /dev/urandom | tr -d '[:space:]' | head -c15
	$ openssl rand -base64 15
	$ gpg2 --armor --gen-random 1 15

The first solution could be considered slightly better, since it includes more
characters (92 instead of 64). It also doesn’t require external tools (although
openssl is almost always available these days).

Lessons
-------

- A byte stream is not the same thing as a character stream.
- Use `strings(1)` to convert a byte stream to a character stream.
- Don’t use the hex output of a hashing algorithm (SHA256, MD5).
- Don’t trust copy/paste solutions from the internet; always think for yourself!
- BSD beats GNU.

[moar1]: http://www.howtogeek.com/howto/30184/10-ways-to-generate-a-random-password-from-the-command-line/
[moar2]: http://www.commandlinefu.com/commands/matching/random-password/cmFuZG9tIHBhc3N3b3Jk/sort-by-votes
[moar3]: http://osxdaily.com/2011/05/10/generate-random-passwords-command-line/
[moar4]: https://wikicomputers.wordpress.com/2010/10/26/10-ways-to-generate-a-random-password-from-the-command-line/
[tr]: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/tr.html
