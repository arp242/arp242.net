---
layout: post
title: "The value of negative arguments"
---

Somehow people end up on my website. I'm not sure how because I typically don't
really post it anywhere. In particular, my articles about [JSON][json] and
[YAML][yaml] configuration files seem to get viewed (and shared) reasonably
frequently. [Jeff Atwood tweeted a link to my site][atwood], which is pretty
neat.

Recently someone submitted the JSON article to HN and Reddit's /r/programming.
Here are some of the comments:

> What's even worse is the lack of a proposed alternative. These days I'm
> getting sick and tired of "X is bad and you should not use it" articles with
> X being something popular that everybody uses/does, without proposing a
> decent alternative. Tell me what I should do, not what I shouldn't do. The
> first one is very valuable, the second is just giving yourself a tap on the
> shoulder.

> If I'm going to read a hate speech <sup>[ah yes, good ol' friendly reddit
> 🙄]</sup> about something like this, I want to at least have some constructive
> content telling me what I should use instead of JSON.

<style>blockquote sup { font-style: normal; }</style>

> Yeah this is ranting for rant sake. How about something constructive like some
> possible options

> But what else ? At least give alternatives...

> So what's the author's proposed alternative?

---

I used to propose some alternatives, but I removed that section because people
kept asking about "X", where "X" is something I never heard of, or am only
superficially familiar with.

It sounds easy to just "propose an alternative", but it's not really. Problems
aren't always obvious from just reading a few examples. YAML has some subtle
behaviour that can really trip people up, but this isn't really obvious from
just a glance and requires an in-depth review. Doing such a review of all
alternatives is much more time-consuming and harder than it might seem. TOML
looks kinda nice I guess, but I never really used it so I'm not sure if there
are non-obvious caveats.

More importantly, there is no single right answer. It depends on what kind of
program you're writing, the requirements, the language and environment you're
using, the intended userbase, social factors (e.g. if all tools in your company
already use XML then it's probably a good idea to stick with that), and probably
a bunch of other factors.

I also consider it out of scope of the article. My goal was to highlight some
(potential) problems you may encounter with using JSON for configuration files,
not to do a full review of all possible approaches you can take. This *is*
constructive, and all the "I wanted to configure my app with JSON, but then I
read your article and decided it was a bad idea so I used something else" emails
I've received over the years are proof of it.

*"Tell me what I should do, not what I shouldn't do"* sounds like a half-wisdom.
Sure, it's probably more useful. But at the same time, pointing out possible
errors people haven't thought of isn't useless or unconstructive.

---

I do think the original version was worded a bit too strong in some places,
which probably prompted some of the "this is unconstructive" replies. Fair
enough, and I edited it since. What can I say? When I wrote it I was frustrated
with MediaWiki's JSON usage for the extension system so I wrote a thing on my
website.

I never really expected it to be read, much less shared to HN or Reddit (it
wasn't me who posted it). In the last three years I also learned a thing or two
about communicating more nuanced in English – which is harder than you'd might
think as a non-native speaker, or at least, it was/is for me – on account of
living and working in English-speaking countries.

Rants or diatribes are defined by a certain level of anger, vitriol, bitterness,
or other negative emotions. Often times it serves to blow off steam rather than
persuade, which was definitely what I was doing when originally writing my JSON
article! This doesn't mean that any argument which argues against something is a
rant or diatribe, or that there is no value in arguing against something.

The main goal should be to *inform* people, rather than blow of steam of
convince them that X sucks. Try to argue from experience and actual problems you
faced, rather than "I don't like it!"

This is also known as a negative argument: "X is bad because Y", which is
opposite of a positive argument: "X is good because Y".

While it's often easier to be negative than positive, posts that are purely
positive are often just as bad – or worse – than the purely negative. They tend
to be incomplete, uncritical, and "it's great for everything" is often just as
wrong as "it sucks for everything". Arguably, it's more harmful as before you
know it everyone is using X in a wave of optimism and then we're all stuck with
it in cases where it was clearly never the appropriate tool.


<style>blockquote sup { font-style: normal; }</style>

[yaml]: /weblog/yaml_probably_not_so_great_after_all.html
[json]: /weblog/json_as_configuration_files-_please_dont
[atwood]: https://twitter.com/codinghorror/status/1009511858460479489
