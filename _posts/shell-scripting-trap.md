---
title: "The shell scripting trap"
date: 2017-12-26
tags: ['Unix']  # Shell
hatnote: |
    Update 2021-10-09: Since writing this three years ago I have since
    discovered that many "shell scripting problems" listed here are actually
    problems in POSIX sh and bash, and that zsh fixes many (though not all) of
    them. My updated take is to continue using shell scripts, but in zsh.  
    See: [s/bash/zsh/g](/why-zsh.html)

    Discussions:
      [Lobsters](https://lobste.rs/s/vghl4j/shell_scripting_trap),
      [/r/programming](https://www.reddit.com/r/programming/comments/968sbv/the_shell_scripting_trap/),
      [/r/commandline](https://www.reddit.com/r/commandline/comments/96i08f/the_shell_scripting_trap/).
    Translations:
      [Chinese (中文)](https://linux.cn/article-10772-1.html).
---

Shell scripting is great. It is amazingly simple to create something very
useful. Even a simple no-brainer command such as:

    # Official way of naming Go-related things:
    $ grep -i ^go /usr/share/dict/* | cut -d: -f2 | sort -R | head -n1
    goldfish

Takes several lines of code and a lot more brainpower in many programming
languages. For example in Ruby:

    puts(Dir['/usr/share/dict/*-english'].map do |f|
      File.open(f)
        .readlines
        .select { |l| l[0..1].downcase == 'go' }
    end.flatten.sample.chomp)

The Ruby version isn't that long, or even especially complicated. But the shell
script version was so simple that I didn't even need to actually test it to make
sure it is correct, whereas I did have to test the Ruby version to ensure I
didn't make a mistake. It's also twice as long and looks a lot more dense.

This is why people use shell scripts, it's so easy to make something useful.
Here's is another example:

    curl https://nl.wikipedia.org/wiki/Lijst_van_Nederlandse_gemeenten |
        grep '^<li><a href=' |
        sed -r 's|<li><a href="/wiki/.+" title=".+">(.+)</a>.*</li>|\1|' |
        grep -Ev '(^Tabel van|^Lijst van|Nederland)'

This gets a list of all Dutch municipalities. I actually wrote this as a quick
one-shot script to populate a database years ago, but it still works fine today,
and it took me a minimum of effort to make it. Doing this in e.g. Ruby would
take a lot more effort.

---

But there's a downside, as your script grows it will become increasingly harder
to maintain, but you also don’t really want to rewrite it to something else, as
you’ve already spent so much time on the shell script version.

This is what I call ‘the shell script trap’, which is a special case of the
[sunk cost
fallacy](https://youarenotsosmart.com/2011/03/25/the-sunk-cost-fallacy/).

And many scripts *do* grow beyond their original intended size, and often you
*will* spend a lot more time than you should on "fixing that one bug", or
"adding just one small feature". Rinse, repeat.

If you had written it in Python or Ruby or another similar language from the
start, you would have spent some more time writing the original version, but
would have spent *much* less time maintaining it, while almost certainly having
fewer bugs.

Take my [packman.vim](https://github.com/arp242/packman.vim) script for
example. It started out as a simple `for` loop over all directories and a `git
pull` and has grown from there.
At about 200 lines it's hardly the most complex script, but had I written it in
Go as I originally planned then it would have been much easier to add support
for printing out the status or cloning new repos from a config file. It would
also be almost trivial to add support for parallel clones, which is hard (though
not impossible) to do correct in a shell script.
In hindsight, I would have saved time, and gotten a better result to boot.

I regret writing most shell scripts I've written for similar reasons, and my
2018 new year's pledge will be to not write any more.

Appendix: the problems
----------------------

And to be clear, shell scripting does come with some real limitation. Some
examples:

- Dealing with filenames that contain spaces or other ‘special’ characters
  requires careful attention to detail. The vast majority of scripts get this
  wrong, even when written by experienced authors who care about such things
  (e.g. me), because it's so *easy* to do it wrong. [Adding quotes is not
  enough](https://dwheeler.com/essays/filenames-in-shell.html).

- There are many "right" and "wrong" ways to do things. Should you use `which`
  or `command`? Should you use `$@` or `$*`, and should that be quoted? Should
  you use `cmd $arg` or `cmd "$arg"`? etc. etc.

- You cannot store any NULL bytes (0x00) in variables; it is very hard to make
  shell scripts deal with binary data.

- While you can make something very useful very quickly, implementing more
  complex algorithms can be very painful – if not nigh-impossible – even when
  using the ksh/zsh/bash extensions. My ad-hoc HTML parsing in the example above
  was okay for a quick one-off script, but you really don't want to do things
  like that in a production-script.

- It can be hard to write shell scripts that work well on all platforms.
  `/bin/sh` could be `dash` or `bash`, and will behave different. External tools
  such as `grep`, `sed`, etc. may or may not support certain flags. Are you sure
  that your script works on all versions (past, present, and future) of Linux,
  macOS, and Windows equally well?

- Debugging shell scripts can be hard, especially as the syntax can get fairly
  obscure quite fast, and not everyone is equally well versed in shell
  scripting.

- Error handling can be tricky (check `$?` or `set -e`), and doing something
  more advanced beyond "an error occurred" is practically impossible.

- Undefined variables are not an error unless you use `set -u`, leading to "fun
  stuff" like `rm -r ~/$undefined` deleting user's home dir ([not a theoretical
  problem](https://github.com/ValveSoftware/steam-for-linux/issues/3671)).

- Small typos can have [large
  consequences](https://github.com/MrMEEE/bumblebee-Old-and-abbandoned/issues/123)
  in ways that don't for most other languages.

- Everything is a string. Some shells add arrays, which works but the syntax is
  obscure and ugly. Numeric computations with fractions remain tricky and rely
  on external tools such as `bc` or `dc` (`$(( .. ))` expansion only works for
  integers).
