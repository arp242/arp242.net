---
title: "Storing files in .git"
date: 2020-04-25
tags: ['Programming']
---

When working on projects I often want to keep some private files around: "TODO"
notes, work-in-progress commit messages, various reference files, etc.

For a long time I stored everything in `$HOME`, which was typically even more
cluttered than my actual home. My `$HOME/TODO` was just a mess of random notes
about random stuff.

At some point I realized you can just store stuff in the `.git` directory.

I typically have a `.git/todo` which contains carious "oh I thought of this
thing, lemme quickly write that down"-kind of notes. A lot of that doesn't need
to be in an issue tracker; half the time it's just something I need to check to
be sure, or something that doesn't pan out.

I write commit messages in `.git/draft`, and then `git commit -eF .git/draft` to
use it.

For my bot detection library I have a long list of `User-Agent` headers, IP
addresses (and reverse lookups/internet registry data) to detect patterns. It's
clearly part of the project, but won't be readily usable for anyone else and
doesn't really need to be in git itself.

I figured this was a small handy tip worth sharing ;-)
