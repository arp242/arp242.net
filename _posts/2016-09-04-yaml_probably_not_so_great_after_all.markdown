---
layout: post
title: "YAML: probably not so great after all"
excerpt: YAML looks great at a glance, but has some problems that may not be obvious at first
---


I previously wrote [why using JSON for human-editable configuration files is a
bad idea][json-no]. Today we’re going to look at some of the problems with YAML.


Can be hard to edit, especially for large files
-----------------------------------------------
YAML files can be hard to edit, and this difficulty grows quite fast as the file
gets larger.

A good example of this are Ruby on Rails’ translation files; for example:

	en:
	   formtastic:
		 labels:
		   title: "Title"  # Default global value
		   article:
			 body: "Article content"
		   post:
			 new:
			   title: "Choose a title..."
			   body: "Write something..."
			 edit:
			   title: "Edit title"
			   body: "Edit body"


This still looks okay, right? But what if this file has 100 lines? Or 1,000
lines? It is very difficult to see "where" in the file you are because it may be
off the screen. You’ll need to scroll up, but then you need to keep track of the
indentation, which can actually be pretty hard even with indentation guides,
especially since 2-space indentation is the norm and [tab indentation is simply
forbidden][faq][^1].

I’ve been programming Python for over a decade, so it’s not like I’m not used to
significant whitespace, but sometimes I’m still struggling with YAML. In Python,
the drawbacks and loss of clarity are usually contained by not having functions
that are several pages long, but data or configuration files have no such
natural limits to their length.

For small files this is not a problem; but it really doesn’t scale well to larger files.

It’s pretty complex
-------------------
YAML may seem ‘simple’ and ‘obvious’ at a glance, but it’s actually not. The
[YAML spec][yaml-spec] is 23,449 words; for comparison, [TOML][toml-spec] is
838 words, [JSON][json-spec] is 1,969 words, and [XML][xml-spec] is 20,603
words.

Who among us have read all that? Who among us have read and *understood* all of
that? Who among of have read, *understood*, and **remembered** all of that?

For example did you know there are [*nine* ways to write a multi-line string in
YAML](http://stackoverflow.com/a/21699210/660921) with subtly different behaviour?

Yeah :-/

That post actually gets even more interesting if you look at [its revision
history](http://stackoverflow.com/posts/21699210/revisions), as the author of
the post discovers more and more ways to do this and more of the subtleties
involved.

It’s telling that the YAML spec starts with a preview, which states (emphases
mine):

> This section provides a quick glimpse into the expressive power of YAML. **It is
> not expected that the first-time reader grok all of the examples**. Rather, these
> selections are used as motivation for the remainder of the specification.

### It’s not portable
Because it’s so complex, its claims of portability have been greatly
exaggerated. For example consider this example taken from the YAML spec:

	? - Detroit Tigers
	  - Chicago cubs
	:
	  - 2001-07-23

	? [ New York Yankees,
		Atlanta Braves ]
	: [ 2001-07-02, 2001-08-12,
		2001-08-14 ]

So aside from the fact that most readers of this probably won’t even know what
this does, try parsing it in Python with PyYAML:

	yaml.constructor.ConstructorError: while constructing a mapping
	  in "a.yaml", line 1, column 1
	found unhashable key
	  in "a.yaml", line 1, column 3

But in Ruby it works:

	{
		["Detroit Tigers", "Chicago cubs"] => [
			#<Date: 2001-07-23 ((2452114j,0s,0n),+0s,2299161j)>
		],
		["New York Yankees", "Atlanta Braves"] => [
			#<Date: 2001-07-02 ((2452093j,0s,0n),+0s,2299161j)>,
			#<Date: 2001-08-12 ((2452134j,0s,0n),+0s,2299161j)>,
			#<Date: 2001-08-14 ((2452136j,0s,0n),+0s,2299161j)>
		]
	}

The reason for this is because you can’t use a list as a dict key in Python:

	>>> {['a']: 'zxc'}
	Traceback (most recent call last):
	  File "<stdin>", line 1, in <module>
	  TypeError: unhashable type: 'list'

And this restriction is hardly unique to Python; common languages such as PHP,
JavaScript, and Go all share this restriction.

So use this in a YAML file, and you won’t be able to read it in most languages.

Here’s another example again taken from the examples section of the YAML spec:

	# Ranking of 1998 home runs
	---
	- Mark McGwire
	- Sammy Sosa
	- Ken Griffey

	# Team ranking
	---
	- Chicago Cubs
	- St Louis Cardinals

But Python says:

	yaml.composer.ComposerError: expected a single document in the stream
	  in "a.yaml", line 3, column 1
	but found another document
	  in "a.yaml", line 8, column 1

While Ruby outputs:

	["Mark McGwire", "Sammy Sosa", "Ken Griffey"]

Which behaviour is the correct one? I, for one, wasn’t able to extract that
from the spec in a reasonable amount of time, but given that it occurs as an
example in the YAML spec, I’d guess that it shouldn’t error out. The Ruby
output also misses the second document, so I’m not even sure that’s actually
correct.

The important bit there though is that two major programming languages behave
*differently*, and that it’s non-trivial to even see which behaviour is the
correct one.

------------

One of the results of this is that some people [are implementing subsets of
YAML](https://docs.saltstack.com/en/latest/topics/yaml/) without all the obscure
stuff almost no one uses anyway.


Goals achieved?
---------------
The spec states:

> The design goals for YAML are, in decreasing priority:
>
> 1. YAML is easily readable by humans.
> 2. YAML data is portable between programming languages.
> 3. YAML matches the native data structures of agile languages.
> 4. YAML has a consistent model to support generic tools.
> 5. YAML supports one-pass processing.
> 6. YAML is expressive and extensible.
> 7. YAML is easy to implement and use.

So how well does it do?

> YAML is easily readable by humans.

True only if you stick to a small subset. The full set is quite complex − much
*more* so than XML or JSON.

> YAML data is portable between programming languages.

Not really true, as it’s too easy to create constructs that are not supported
by common languages.

> YAML matches the native data structures of agile languages.

See above. Plus, why only support agile (or dynamic) languages? What about
other languages?

> YAML has a consistent model to support generic tools.

I am not even sure what this means and I can’t find any elaboration.

> YAML supports one-pass processing.

I’ll take their word for it.

> YAML is expressive and extensible.

Well, it is, but I would argue that it’s *too* expressive (e.g. too complex).

> YAML is easy to implement and use.

	$ cat `ls -1 ~/gocode/src/github.com/go-yaml/yaml/*.go | grep -v _test` | wc -l
	9247

	$ cat /usr/lib/python3.5/site-packages/yaml/*.py | wc -l
	5713

Conclusion
----------
Don’t get me wrong, it’s not like YAML is absolutely terrible − it’s certainly
not full-on stupid as [using JSON][json-no] − but it’s not exactly great either.
There are some drawbacks and surprises that are not at all obvious at first, and
there are actually a number of better alternatives (such as [TOML][toml] and
other more specialized formats).

Personally, I’m not very likely to use it again.

[^1]: If tabs would be allowed, I would be able to (temporarily) increase the tab width to a higher number to make it easier − this is sort if the point of tabs.

[faq]: http://www.yaml.org/faq.html
[yaml-spec]: http://yaml.org/spec/1.2/spec.pdf
[toml-spec]: https://github.com/toml-lang/toml
[json-spec]: http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf
[xml-spec]: https://www.w3.org/TR/REC-xml/
[json-no]: http://arp242.net/weblog/JSON_as_configuration_files-_please_dont.html
[toml]: https://github.com/toml-lang/toml
