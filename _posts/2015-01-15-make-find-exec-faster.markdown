---
layout: post
title: Making find -exec faster
categories: programming-and-such
---

Here’s a little `find` trick that not many people seem to know:

	# 13 seconds...
	$ time find . -type f -exec stat {} \; > /dev/null
			13.20s real             3.94s user              9.22s sys

	# 1.5 seconds! That's almost 10 times faster!
	$ time find . -type f -exec stat {} + > /dev/null
			1.48s real              0.68s user              0.79s sys

	# Run the first command again, to make sure we’re not being biased by fs
    # cache or got some fluke
	[~]% time find . -type f -exec stat {} \; > /dev/null
			13.40s real             3.67s user              9.51s sys

	# FYI...
	[~]% find . -type f | wc -l
	    2641

That’s quite a large difference! All we did was swap the `;` for a `+`.

Let’s see what [POSIX has to say about it][posix] (emphases mine):

> If the primary expression is punctuated by a `<semicolon>`, **the utility
> `utility_name` shall be invoked once for each pathname** 
>
> [.. snip ..]
>
> If the primary expression is punctuated by a `<plus-sign>`, the primary shall
> always evaluate as true, and the pathnames for which the primary is evaluated
> shall be aggregated into sets. **The utility `utility_name` shall be invoked once
> for each set of aggregated pathnames.**

Or in slightly more normal English: If you use `;`, `find` will execute the
utility once for every path; if you use `+`, it will cram as many paths as it
can in an invocation.

How many? Well, as many as `ARG_MAX` allows. [Quoting from POSIX Again][limits]:

> `{ARG_MAX}`  
> Maximum length of argument to the exec functions including environment data.  
> Minimum Acceptable Value: `{_POSIX_ARG_MAX}`
>
> `{_POSIX_ARG_MAX}`  
> Maximum length of argument to the exec functions including environment data.  
> Value: 4096

Most contemporary systems have it set much higher though; Linux (3.16, x86\_64)
defines `ARG_MAX` as 131072 (128k), while FreeBSD (10, i386) gives it as 262144
(256k).


Let’s verify this with [`truss`][truss][^1]:

	# Amount of files we have
	$ find . -type f | wc -l
	    2641

	$ truss find . -type f -exec stat {} \; >& truss-slow
	$ truss find . -type f -exec stat {} + >& truss-fast

	# Less than ARG_MAX, so we expect one fork()
	$ find . -type f | xargs | wc -c
		119528

	# Yup!
	$ grep fork truss-fast | wc -l
		1

	# And we fork() once for every file
	$ grep fork truss-slow | wc -l
		2641


Caveat
------

There is one small caveat, this won’t work:

	# FreeBSD find
    $ find . -type f -exec cp {} /tmp +
	find: -exec: no terminating ";" or "+"

	# GNU find is even more cryptic:
	$ find: missing argument to `-exec'


Going [back to POSIX][posix]:

> Only a `<plus-sign>` that immediately follows an argument containing only the
> two characters "{}" shall punctuate the end of the primary expression. Other
> uses of the `<plus-sign>` shall not be treated as special.

In other words, the command *needs* to end with `{} +`. `cp {} /tmp +` doesn’t,
and thus gives an error.  

We can work around this by spawning a `sh` one-liner:

	$ find . -type f -exec sh -c 'cp "$@" /tmp' {} +


[^1]: Linux users can use [`strace`][strace]. OpenBSD users [`ktrace`][ktrace].

[posix]: http://pubs.opengroup.org/onlinepubs/9699919799/utilities/find.html
[limits]: http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/limits.h.html
[truss]: http://www.freebsd.org/cgi/man.cgi?query=truss&apropos=0&sektion=0&manpath=FreeBSD+10.1-RELEASE&arch=default&format=html
[strace]: http://sourceforge.net/projects/strace/
[ktrace]: http://www.openbsd.org/cgi-bin/man.cgi?query=ktrace&apropos=0&sec=0&arch=default&manpath=OpenBSD-current
