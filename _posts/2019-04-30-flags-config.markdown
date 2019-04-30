---
layout: post
title: "Flags are great for configuration"
---

I like to configure programs with commandline flags. Why include thousands of
lines of code to parse [confusing file formats][yaml] when you can just run
`prog -foo`? Want to support loading from environment variables? `prog -foo
"$ARG"`, or if you want to set a default use `prog -foo "${ARG:-default}"`. Want
to inspect the flags the application was launched with? `ps`. Want the
documentation? `prog -help`. Want a config file? Create a simple shell script.

Is this suitable for everything? No, of course not. In particular config files
will work better for apps you launch frequently and have a lot of settings such
as, say, `git`. But for servers or other programs that aren't invoked very often
I find this works very well.

For large and complex applications it's probably not a good idea to configure
everything with flags. Configuring something like Postfix with just flags would
clearly be silly. Most applications are not complex; and if your application
does grow it'll be easy to replace the flag parsing code – which is usually just
a few lines – with something more advanced.

I see plenty of fairly simple programs that have complex configuration schemes
just to load a few settings.
The project I worked on this week has 2.8k lines of code and 8 settings and uses
a config library with 2.2k lines of code plus 9.5k from the YAML library. I
don't think that really makes things [easier][easy].

---

I've never really liked the idea of directly using environment variables for
configuration. It's not very explicit, can be surprising (with subprocesses
inheriting parent), there are no warnings on typos, and it's hard to inspect.
Using flags allows you to use environment variables (for e.g. secrets) while
fixing most of those issues: it's explicit, clear which variables are used, and
you get errors on typos.

    #!/bin/sh

    # Error out on undefined variables to catch typos or other errors such as env
    # vars not being defined when you expected it (not enough systems do this!)
    set -u

    # exec replaces the process; prevents needless /bin/sh from dangling around.
    exec prog \
        -foo "$FOO" \
        -bar "${BAR:-default}"

You can probably do something similar with systemd unit files. Personally I'd
just call that shell script from systemd; it's just so much [easier to
understand, test, and debug][easy].

---

Another approach that I rather like is the [suckless](https://suckless.org/)
one: configuration is done by editing config.h and recompiling the program.
These tools are aimed at advanced users and are fairly small and quick to
recompile (you don't really want to recompile Vim every time you change a
setting). Still, I think it can work well for many problems. Not everything
needs to be a setting.

<div class="postscript"><strong>Also see</strong>
<ul>
<li><a href="/weblog/flags-config-go.html">Using flags for configuration in Go</a></li>
</ul></div>

[easy]: /weblog/easy.html
[yaml]: /weblog/yaml_probably_not_so_great_after_all.html
[json]: /weblog/json_as_configuration_files-_please_dont
[sconfig]: https://github.com/Carpetsmoker/sconfig
