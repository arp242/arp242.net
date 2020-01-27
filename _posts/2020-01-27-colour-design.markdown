---
layout: post
title: "Colour design of commandline interfaces"
tags: ['Unix', 'UX']
---

A commandline interface (CLI) is a user interface. Like all user interfaces the
best ones are carefully designed with the user in mind. There are many aspects
on CLI user design; this will focus on colour design, as I feel that's what a
significant number of CLI program get wrong.

---

Here's what `git log` looks like for me:

<figure class="border"><img alt="Output of 'git log'" src="{% base64 ./_images/colour/git.png %}"></figure>

The yellow, light-blue, and green text are kind-of readable, but clearly
suboptimal. The colours are designed for a dark background, not a light one.

I've done a few informal surveys
<sup>([2019](https://lobste.rs/s/pop6bi/terminal_ide_background_colour),
[2014](https://forums.freebsd.org/threads/your-terminals-background-colour.44767/)</sup>)
and while the dark background is certainly more common, light backgrounds are
not rare. It's the default for several popular terminal emulators: xterm, rxvt,
gnome-terminal. The GUI versions of Vim and Emacs default to a white background.

{:class="x"}
**Ensure colours are readable on different backgrounds**

I appreciate it's not always easy to do this. One strategy is to setting both
the foreground and background colours:

<figure class="border"><img alt="Output of 'npm install'" src="{% base64 ./_images/colour/npm.png %}"></figure>

It looks kinda weird, but otherwise the white `npm` text would be on top of a
white background.

There is still no guarantee that it will work well since the exact shade of
colour is defined by the terminal, not the program. Another solution is to not
mix text and background colour:

<figure class="border"><img alt="Output of custom logger" src="{% base64 ./_images/colour/gc.png %}"></figure>

This still makes the error stand out, and ensures the text is always readable.

The original 8/16 colours (8 colours, each having a "bright" variant) are not
exactly defined. For example colour "4" is "blue", but the exact shade of blue
is [up to the implementation][8c]. You can never be quite sure if something is
readable.

This is fixed in 256 and true colour mode which define exact colours (although
you still can't be sure how it's perceived by your users because of differences
in computer screens, ambient light, human vision, etc. This is why it's usually
wise to take wide margins when it comes to contrast ratios and the like).

https://git.busybox.net/busybox/tree/coreutils/ls.c#n84

> Saying yes here will turn coloring on by default, even if no "--color" option
> is given to the ls command. This is not recommended, since the colors are not
> configurable, and the output may not be legible on many output screens.

But then the default is `y` 🤔 The result of which is that I need 

[8c]: https://en.wikipedia.org/wiki/ANSI_escape_code#Colors

{:class="x"}
**Prefer 256 colours or true colours**

Detecting which colours a terminal supports is tricky and unreliable, but it's
reasonably safe to assume a terminal supports 256 colours; I'm not aware of any
that doesn't. True colour support is [less universal, but still very
widespread][tc-support].

[tc-support]: https://gist.github.com/XVilka/8346728#not-supporting-true-color

---

Colours add a new dimension of information to text; this can be very helpful,
but when there are too many colours it becomes useless:

<figure class="border"><img alt="Output of 'exa'" src="{% base64 ./_images/colour/exa.png %}"></figure>

Aside from the yellow being truly hard to read, there are so many colours here
that it loses any information.

<!--
The [example on the homepage is even more colour dense][exa]
[exa]: https://the.exa.website/
-->

{:class="x"}
**Minimize colour usage for highest effectiveness**

Colours add an extra information dimension to text, but just as too much text
will overwhelm, so will too many colours. It just looked cluttered, rather than
organized.

There are no hard rules on what is "too many colours"; it depends on what
information you want to convey: if you want to direct attention, then fewer is
probably better. If you want to group, then it can be okay to use more colours.

{:class="x"}
**Decide what to use colours for**

Mixing usages isn't uncommon.

Group information: many colors *might* be okay.

Popup: probably not.

<!--
- Why do we add colours? Adds dimension; for example to:
  - Group information.
    - Divide in sections.
  - Highlight important information
  - Subdue less important information.
  - UI elements (e.g. popup menu)
  - Syntax highlighting: spot errors.

"angry fruit salad"
"Christmas tree"
"unicorn vomit"

- https://homepages.cwi.nl/~steven/Talks/2019/11-21-dijkstra/
  "red shapes"
  Easy to group: not easy to stand out.
-->

TODO

---

You usually don't want to display colours when the output is not an interactive
terminal device. This allows for easier piping and composition of tools.

{:class="x"}
**Don't output colours to non-terminal devices**

There are exceptions though, like in the above `exa` example I piped to `tail`
but still wanted to see colours. Using the `FORCE_COLOR` the environment flag or
a `--color always` commandline flag are reasonable solutions.

{:class="x"}
**Allow easily disabling colours altogether**

Sometimes users really don't want color, so make sure it can be easily disabled,
for example by using [`NO_COLOR`][no-color].

[no-color]: https://no-color.org/

<!--
https://colorusage.arc.nasa.gov/clutter.php
-->

<style>.x { max-width: 35em; margin: .5em auto; text-align: center; font-style: italic; padding: 1em 0;
    border-top: 2px solid #333; border-bottom: 2px solid #333; }</style>

