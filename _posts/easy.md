---
title: "Easy means easy to debug"
date: 2019-03-22
tags: ['Programming']
hatnote: |
    Translations:
      [Korean (한국어)](https://velog.io/@leejh3224/Easy-means-easy-to-debug).
---

{%- comment -%}
<div class="hatnote">
Follow-up: <a href="/understandable.html">How to make code easier to understand</a>
</div>
{%- endcomment -%}

What does it mean for a framework, library, tool to be "easy"? There are many
possible definitions one could use, but my definition is usually that it's *easy
to debug*.
I often see people advertise a particular program, framework, library, file
format, or something else as easy because "look with how little effort I can do
task X, this is so easy!" That's great, but an incomplete picture.

Code is written only once, but will almost always go through several debugging
cycles. With debugging cycle I don't mean "there is a bug in the code you need
to fix", but rather "I need to look at this code to fix the bug". To debug code,
you need to understand it, so "easy to debug" by extension means "easy to
understand".

Abstractions to make something easier to do often come at the cost of making
things harder to understand. Sometimes this is a good tradeoff, but often it's
not. In general I will happily spend more effort writing something now if that
makes things easier to understand and debug later on. It will often be a net
time-saver.

Simplicity isn't the *only* thing that makes programs easier to debug, but it is
the most important. Good documentation helps too, but unfortunately good
documentation is uncommon (quality is *not* measured by word count!)

The effects of this are real. Programs that are hard to debug will have more
bugs simply because it's so much harder and more time-consuming to fix bugs,
even if the initial bug count would be exactly the same as a program that is
easy to debug.

In a company setting, it's often not considered good Return Of Investment to
spend time on hard-to-fix bugs. In an open source setting, people will
contribute less (most projects have one or handful of regular maintainers, but a
long tail of hundreds or even thousands of contributors who submitted just one
or a few patches).

---

This is not exactly a novel insight; from the 1974 *The Elements of Programming
Style* by Brian W. Kernighan and P. J. Plauger:

> Everyone knows that debugging is twice as hard as writing a program in
> the first place. So if you're as clever as you can be when you write it, how
> will you ever debug it?

A lot of stuff I see seems to be written "as clever as can be" and is
consequently hard to debug. I'll list a few examples of this pattern below. It's
not my intention to argue that any of these things are bad per se, I just want
to highlight some trade-offs in "easy to use" vs. "easy to debug".

- ORM libraries can make database queries *a lot* easier, at the cost of making
  things a lot harder to understand once you want to solve a problem.

- Many testing libraries can make things harder to debug. Ruby's rspec is a good
  example where I've occasionally used the library wrong by accident and had to
  spend quite a long time figuring out what *exactly* went wrong (as the errors
  it gave me were very confusing!)

  I wrote a bit more about that in my [*Testing isn’t everything*](/testing.html)
  post.

- Many JavaScript frameworks I've used can be hard to fully understand. Clever
  state keeping logic is great and all, until that state won't work as you
  expect, and then you better hope there's a Stack Overflow post or GitHub issue
  to help you out.

  These libraries *do* make a lot of tasks a lot easier of course, and there is
  nothing wrong with using them. But in general I find there is far too much
  focus on "making it easy to use" and not enough on "making it easy to debug".

- Docker is great and makes a lot of things very easy, right up to the point you
  get:

      ERROR: for elasticsearch  Cannot start service elasticsearch:
      oci runtime error: container_linux.go:247: starting container process caused "process_linux.go:258:
      applying cgroup configuration for process caused \"failed to write 898 to cgroup.procs: write
      /sys/fs/cgroup/cpu,cpuacct/docker/b13312efc203e518e3864fc3f9d00b4561168ebd4d9aad590cc56da610b8dd0e/cgroup.procs:
      invalid argument\""

  or

      ERROR: for elasticsearch  Cannot start service elasticsearch: EOF

  And ... now what?

- Systemd is considered easier than SysV init.d scripts because it's easier to
  write systemd unit files than it is to write shell scripts. In particular,
  this is the argument Lennart Poettering used in his [systemd
  myths](http://0pointer.de/blog/projects/the-biggest-myths.html) post (point
  5) when explaining that systemd is easy.

  It's not that I disagree with Poettering exactly – also see [the shell
  scripting trap](/shell-scripting-trap.html) – but it is an incomplete
  picture. The plumbing required to make unit files easy means systemd as a
  whole is much more complex, and users *do* suffer effects from this.
  Look at [this issue](https://unix.stackexchange.com/q/185495/33645) I
  encountered and [the
  fix](https://cgit.freedesktop.org/systemd/systemd/commit/?id=6e392c9c45643d106673c6643ac8bf4e65da13c1)
  for it. Does that look easy to you?

{% comment %}
**Also see my follow-up: [How to make code easier to understand](/understandable.html)**
{% endcomment %}
