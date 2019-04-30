---
layout: post
title: I don’t like git, but I’m going to migrate my projects to it
updated: 2019-01-04
---

I don’t like git. But I’m going to migrate my projects to it.

Why I don't like git
--------------------

My chief gripe with git is its user interface. With ‘user interface’ I mean the
commandline user interface. Let me show by example:

	$ git help commit | wc -l
	506
	$ hg help commit | wc -l
	59
	$ hg help commit -v | wc -l
	96

Currently my git installation has 169 “core” commands:

	$ find /usr/lib/git-core -maxdepth 1 -type f -executable | wc -l
	169

Compare this to mercurial’s 50 built-in commands (from `hg help`), a number
which has remained constant since I wrote this article (whereas git had 160
commands when I first wrote this 2 years ago).

*“But git commit has so many more features”*, well, perhaps. But how many of
those are actually used by most users? Mercurial can be easily extended, and
most "missing" features are implemented in extensions (many are shipped with the
base mercurial install). For better or worse, git is bloatware, and like most
bloatware it comes with a [notoriously difficult to understand manual][git-man].

Mercurial has a manual and user interface that I understand without too much
effort, and this is by far the biggest reason I much prefer mercurial over git.
If I need to know something from mercurial I can just read the documentation and
go ‘ah’, with git … not so much. There’s a reason so many of the [top Stack
Overflow questions][so-top] are about git.

Some might say (and indeed, have said) that I’m lazy and just need to spend
more time and effort learning git. Well, perhaps, but the thing is, git doesn’t
really *do* anything. Unlike a programming language or API I can’t really
*build* anything with it. It’s merely *logistics* to facilitate the actual
building of stuff.  
It seems to me that ideally you want to spend as little as possible time on
logistics, and as much possible time on actually building stuff. I know enough
git to get by, but not enough to deal with rare exceptional situations that
occur only a few times a year. For example consider this error I made a while
ago:

	# Do work
	$ git checkout -b feature-branch
	$ git commit -m 'Best code ever!'
	$ git push

	# Okay, work here is done so let's check out master again.
	$ git checkout master

	# Go have dinner. Discover I forgot something after dinner, fix it.
	# Let's just ammend that commit instead of making a new one!
	$ git commit --amend

	# But wait, I forgot I switched back to master >_<

It’s not so easy to undo the amend ([the solutions listed here][undo-amend] undo
*everything*, not only the `--amend`).

Compare with `hg`:

	% hg ci --amend
	abort: cannot amend public changesets

This makes much more sense, since you typically don’t want to do this. There are
exceptions, but those are rare and far in between.

There are many more examples like this to be found.

---

From a technical point of view mercurial has some advantages as well. It has a
well-designed extension system; aside from the 50 standard commands mercurial
also ships with 31 extensions (`hg help extensions`) by default, which add many
of the commands that are enabled by default in git. It’s also pretty easy to
write your own extension.

git ‘extensions’ are commands starting with `git-`. These are typically shell or
Perl scripts – or in the case of `git-instaweb`, a shell script which generates
a Perl script – parsing the output of other git commands. It’s ugly, it’s
difficult to port reliably and its C core [leaves it open to classic memcpy
buffer overflows][git-memcpy]. It’s not even faster, since Python [is so much
easier to optimize][facebook-hg].

Why is everyone using git?
--------------------------

1. Linus Torvalds wrote it.
2. GitHub
3. Linus Torvalds wrote it.

GitHub had to compete with SourceForge. The challenge was pretty low;
SourceForge *always* sucked, was *always* slow, and the only thing anyone
really used it for was finding projects and when you found it, the first thing
you did was click “Visit this project’s website”.

As for Linus, well, remember his diving app that everyone got so excited about
even though most don’t actually dive? Linus also doesn’t attend user group
meetings any more because it became a problem, [as Greg Kroah-Hartman
explains][linus-fanboys]:

> One time somebody sat across from him [Linus] and stared at him for an hour without
> ever saying anything.

Software written by Linus are like films with Tom Cruise. People go see it
because it has Tom Cruise in it, not because it’s necessarily a great film.

Why switch to git?
------------------

The same reason so many use Facebook while complaining about it: the network
effect.

- We use git and GitHub at $dayjob. Half the time I type `hg` when I intended
  `git` or vice-versa. This is also why I use Markdown for most things (even
  though there are better alternatives); switching syntaxes is hard.

- Lots of people are familiar with git and GitHub – not so much with mercurial
  and Bitbucket. I feel I’m missing out on bug reports and patches because
  people simply can’t be bothered sending them on an unfamiliar platform. At
  least one person "forked" my project by converting the mercurial repo to git
  and uploading it to GitHub.

- A number of tools only work with git, and either don’t want to implement
  mercurial support or sometimes even removed it.

One important reason I’ve held out with mercurial and Bitbucket for as long as I
did is because I feel having something to choose is good and don’t like
monocultures. In a monoculture sooner or later things tend to stagnate, the world of
open source is not an exception (look at SourceForge, subversion, Apache, gcc,
etc.).

For a while I hoped that mercurial and git would *both* exist as common version
control systems, but this doesn’t seem to be happening anytime soon and I’ve
grown tired of spending the increasing ‘mercurial penalty’. As mentioned above,
I’d rather spend as little time as possible on these sort of logistics, and
simply by using mercurial instead of git I (and others) have to spend more time
on these logistics.

So let’s simply ‘go with the flow’ and use git, even though I don’t like it.

<div class="postscript">
<strong>Related articles</strong>
<ul>
<li><a href="https://doriantaylor.com/betamaxed">Betamaxed</a></li>
</ul>
</div>

[undo-amend]: http://stackoverflow.com/a/1459264/660921
[linus-fanboys]: https://www.bloomberg.com/news/articles/2015-06-16/the-creator-of-linux-on-the-future-without-him
[facebook-hg]: https://code.facebook.com/posts/218678814984400/scaling-mercurial-at-facebook
[git-memcpy]: http://www.openwall.com/lists/oss-security/2016/03/15/5
[git-man]: https://git-man-page-generator.lokaltog.net/
[so-top]: http://stackoverflow.com/questions?sort=votes
