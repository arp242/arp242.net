---
layout: post
title: "The downsides of JSON for config files"
tags: ['Programming', 'Config']
updated: 2019-04-16
desc: "JSON was designed as a data interchange format, and not a configuration format; it works but there are downsides."
hatnote: |
 Follow-up:
 <a href="/flags-config.html">Configuration with flags</a>.
 Also see:
 <a href="/yaml-config.html">
 YAML: probably not so great after all</a>.
 Discussions:
 <a href="https://news.ycombinator.com/item?id=19653834">Hacker News</a>;
---

I've recently witnessed the trend of using JSON for configuration files. I think
this is not a good idea.

It’s not what JSON was designed to do, and consequently not what it’s good at.
JSON is intended to be a “lightweight data-interchange format”, and claims that
it is “easy for humans to read and write” and “easy for machines to parse and
generate”.

As a data interchange format JSON is pretty okay. A human *can* read and write
it comparatively easily, and it’s also pretty easy to parse for machines
(although there [are problems](http://seriot.ch/parsing_json.php)).

It’s a good trade-off between machine-readable and human-readable and for many
use-cases it's a good improvement over XML.

Using it for other purposes is somewhat akin to saying “hey, this hammer
works really well for driving in nails! I love it! Why not hammer in this screw
with it!” Sure, it sort of works, but it’s the wrong tool for the job.

---

By far the biggest problem is that you can’t add comments. The occasional JSON
parser supports it, but most don’t and it’s not in the standard. Comment support
was [explicitly removed from JSON][1] for good reasons.

[1]: https://web.archive.org/web/20120506232618/https://plus.google.com/118095276221607585885/posts/RK8qyGVaGSr

There are many reasons you want to add comments: document why settings are set
to the values they are, add  mnemonics or describe caveats, warn against past
configuration mistakes, keep a basic ChangeLog in the file itself, or just for
commenting out a section/value when debugging.

One [suggested workaround](http://stackoverflow.com/a/244858/660921) is to use a
new key (e.g. `{"__comment": "a comment", "actual_data": "..."}`, but this
strikes me as pretty ugly.

Other people have pointed out that you can use the commit log, but who is going
to peruse the commit history in the off chance there is some important message
hidden in there?

Some JSON dialects – such as JSON5, Hjson, and HOCON – add support for comments,
as do some JSON parsers. That's great and I encourage you to use it, but that's
no longer JSON but a JSON dialect. This post is about JSON, not JSON dialects.

---

I also find the UX of JSON to be rather suboptimal for hand editing: you need to
muck about with trailing commas, the semantics for quoting are annoying, and it
lacks the ability to use multiline strings. These properties are good for JSON's
intended usage, but not so great for editing configuration files. Is it doable?
Of course. Is it fun? No.

I also don't find it especially readable, as it suffers from excessive
quotations and other syntax noise, I freely admit this is a matter of taste.

---

JSON is a declarative configuration language. Declarative configuration (DC)
works well for some problems, but not so well for others. In particular, using
DC to control logic is often not a good idea.

What prompted me to write this post was MediaWiki's new extension system. The
old system used a simple PHP file to hook in to the core MediaWiki code, load
required dependencies, etc. This was replaced with a JSON file in the new
system. What was lost with this is the ability to be clever about stuff like
compatibility with other plugins, or other logic.

It's also much more complex to implement, previously it was just
`require('plugin/foo/plugin.php');`, now it needs to parse a JSON file and do
something with the contents of it. That's much more complex, and thus [harder to
debug](/easy.html).

While using a JSON file for basic metadata makes sense (easier to parse and
display on websites), using it to describe how code works strikes me as a misuse
of DC. After all, that's what code is for.

---

A lot of people have asked me for suggestions about what to use. This is not
an easy question to answer, as it depends on your use case, programming
language, library environment, and social factors. There is no single "right
answer", other than perhaps "the simplest which meets all your requirements". I
actually wrote [an entire article about that](/negative-argument.html).

One good alternative might be to just [use commandline
flags](/flags-config.html).

There are a few JSON dialects designed especially for human editing:
[JSON5](https://json5.org/),
[Hjson](http://hjson.org/), and
[HOCON](https://github.com/lightbend/config/blob/master/HOCON.md). All of these
seem like a reasonable step up from regular JSON, although I have not used any
of them myself. JSON5 in particular seems like a good alternative, as it makes
the least changes to JSON.

I'm hesitant to suggest other alternatives, as I haven't done an in-depth
evaluation of all the formats ([other than YAML](/yaml-config.html)); potential
drawbacks may not be obvious from just glancing the spec (YAML is a good example
of this with a lot of subtle behaviour). I don't really have the time – or
interest – to do a full in-depth review of all alternatives.
