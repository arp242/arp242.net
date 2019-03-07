---
layout: post
title: "JSON as configuration files: please don’t"
updated: 2016-12-17
---

<em class="hatnote">Also see
<a href="/weblog/yaml_probably_not_so_great_after_all.html">
YAML: probably not so great after all.</a></em>

I’ve recently witnessed the rather disturbing trend of using JSON for
configuration files.

Please don’t. Ever. Not even once. It’s a really bad idea.

It’s just not what JSON was designed to do, and consequently not what it’s good
at. JSON is intended to be a “lightweight data-interchange format”, and claims
that it is “easy for humans to read and write” and “easy for machines to parse
and generate”.

As a data interchange format JSON is pretty okay. A human *can* read and write
it comparatively easily, and it’s also pretty easy to parse for machines
(although there [are problems][parse]).
It’s a good trade-off between machine-readable and human-readable and a huge
improvement on what it intended to replace: XML, which I consider to be
unreadable by *both* machines and humans.

Using it for other purposes is somewhat akin to saying “hey, this hammer
works really well for driving in nails! I love it! Why not hammer in this screw
with it!” Sure, it sort of works, but it’s very much the wrong tool for the job.

Specific shortcomings
---------------------

### Lack of comments

This is by far the biggest problem: you can’t add comments in JSON files. The
occasional JSON parser supports it, but most don’t and it’s not in the standard,
in fact, comment support was [explicitly removed from JSON][crockford] for good
reasons.

This is **very** problematic.

- No way to document on why settings were set to what they are.

- No way to add mnemonics or describe caveats.

- No way to keep a basic ChangeLog in the config file itself, documenting which
  changes were made (which can be immensely useful).

- Much more difficult to debug, as quickly commenting out a section isn’t
  possible.

One [suggested workaround](http://stackoverflow.com/a/244858/660921) is to use a
new key, e.g.:

	{
		"__comment": "Something to comment about",
		"actual_data": "Hello, world"
	}

But this is just damn ugly.

Other people have pointed out that you can use the commit log, but this is an
even worse idea. Consider something like `bower`:

	// Please be VERY CAREFUL when updating this, since this library often
	// makes incompatible changes even in minor bugfix releases (e.g. when
	// updating from 1.1.1 to 1.1.2).
	'some_stupid_lib': '1.1.1'

So, are you going to dig though the entire commit history in search for some
important message?

Of course not.

### Readability

It’s just not *that* readable. Sure, it’s readable *for a data-interchange
format*, but not readable for a configuration file.

Readability counts.

### Strictness

The JSON standard is fairly strict − this is good, it allows for concise and
fast parsers that don’t have to muck about with different formats − but it also
means it’s more difficult to write.

For example a trailing comma in objects or arrays is an error, and something
that has bitten me more than once. And having to escape all instances or `"` can
be pretty annoying if your string contains a lot of `"`s.

### Lack of programmability

Not always an issue, but sometimes it is, especially when JSON is used to
configure some piece of code.

For example, consider:

	# This works much better on BritOS
	if ($uname === 'BritOS')
		$wear = 'trousers';
	else
		$wear = 'pants';

This is an issue for example in MediaWiki’s `skin.json` file. What I wanted to
do is *not* include some CSS if a certain plugin is loaded, and we can’t do this
− we can (probably) work around it in the PHP file, but “working around” things
is never good (and remember, we can’t leave a comment in the JSON file to inform
people that we’re working around things!)

The old way of doing things in MediaWiki (declaring class variables) was a lot
better and provided much more features.

Examples
--------

Name and shame :-)

- MediaWiki’s new [extension registration](https://www.mediawiki.org/wiki/Manual:Extension_registration)
  system is what motivated me to write this.
- npm’s [`package.json`](https://docs.npmjs.com/files/package.json) (which uses
  a [somewhat silly system](http://stackoverflow.com/a/14221781/660921) for adding
  comments).
- Bower is full-on idiotic by saying [comments aren't useful enough to
  support](https://github.com/bower/bower/issues/1059).
- … Unfortunately many, many more …


[crockford]: https://plus.google.com/+DouglasCrockfordEsq/posts/RK8qyGVaGSr
[toml]: https://github.com/toml-lang/toml
[parse]: http://seriot.ch/parsing_json.php
