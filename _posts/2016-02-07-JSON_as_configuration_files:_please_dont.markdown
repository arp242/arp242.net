---
layout: post
title: "JSON as configuration files: please don’t"
excerpt: Using JSON for configuration files is a disturbing trend.
---

I’ve recently witnessed the rather disturbing trend of using JSON for
configuration files.

Please don’t. Ever. Not even once. It’s a really bad idea.

It’s not what JSON was intended for and consequently not what it’s good at. JSON
is intended to be a “lightweight data-interchange format”, and claims that it is
“easy for humans to read and write” and “easy for machines to parse and
generate”.

As a data interchange format JSON works rather well. You *can* read and write it
pretty easily and it’s also very easy to parse for machines. It’s a good
trade-off between the extremes of machine-readable and human-readable and a
[huge improvement][^1] on what it intended to replace: XML, which I consider to
be unreadable by *both* machines and humans.

Bit none of that means it’s also suitable as a configuration file format, as
this has **different needs** than a data interchange format.

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

- No way to keep a basic ChangeLog in the config file itself, documenting
  changes made (which can be immensely useful).

- Much more difficult to debug, as quickly commenting out a section isn’t
  possible.

One [suggested workaround](http://stackoverflow.com/a/244858/660921) is to use a
new key, e.g.:

	{
		"__comment": "Something to comment about",
		"actual_data": "Hello, world"
	}

But this is just damn ugly.

### Readability
It’s just not *that* readable. Sure, it’s readable *for a data-interchange
format*, but not readable for a configuration file.

Readability counts.

### Strictness
The JSON standard is pretty strict—this is good, it allows for concise and fast
parsers that don’t have to muck about with different formats−but it also means
it’s more difficult to write.

A trailing comma in objects or arrays is an error, and something that has
bitten me more than once. And having to escape all instances or `"` can be
pretty annoying if your string contains a lot of `"`s.

### Lack of programmability
Not always an issue, but sometimes it is, especially when JSON is used to
configure some piece of code.

For example, consider:

	# This works much better on BritOs
	if ($uname === 'BritOs')
		$wear = 'trousers';
	else
		$wear = 'pants';

This is an issue for example in MediaWiki’s `skin.json` file. One thing I wanted
to do is not include some CSS if some plugin is loaded, and we can’t do this−we
can (probably) work around it in the PHP file, but “working around” things is
never good (and remember, we can’t leave a comment in the JSON file to inform
people that we’re working around things!)

Alternatives
------------
- The [“recommended way”][crockford] by JSON author Douglas Crockford is “pipe
  it through JSMin before handing it to your JSON parser”. *Some* JSON parsers
  also explicitly support comments (but most don’t).

- `import`, `require`, `include`, or use whatever code-importing facilities your
  language provides (or even `eval()`). Obviously, this means configuration
  files have to be a trusted source (which is usually the case).

- `ini` files; not standardized, but this usually isn’t a problem since
  configuration files typically are intended to be read by only one program.

- YAML; it’s okay-ish, but also rather complex. The indentation can also become
  difficult to follow in large documents.

- While I wouldn’t necessarily recommend it, “rolling your own” configuration
  file parser is really easy. In Python:

		with open('my-file.ini') as fp:
			for i, line in enum(fp.readline()):
				# Remove comments
				line = re.sub('[#;].*', '', line).strip()

				# Skip blank lines
				if line = '':
					continue

				# Error out on lines without a =
				if not '=' in line:
					raise Exception('No = on line {}'.format(i + 1))

				# Everything before the first = is a key
				line = line.split('=')
				key = line[0].strip()

				# Everything after that is the value
				value = '='.join(line[1:]).strip()

	This doesn’t support everything that `.ini` files do, but it’s enough for
	many applications.

Examples
--------
Name and shame :-)

- MediaWiki’s new [extension registration](https://www.mediawiki.org/wiki/Manual:Extension_registration)
  system is what motivated me to write this.
- npm’s [`package.json`](https://docs.npmjs.com/files/package.json) (which uses
  a [stupid system](http://stackoverflow.com/a/14221781/660921) for adding
  comments).

### Advocates
- [JSON configuration file format](http://octodecillion.com/blog/json-data-file-format/)


[^1]: XML advocates typically shout “validation!” here. There is something to be said for that, but XML validation is a horribly complex beast−I don’t think I’ve ever seen it work−and the problem can typically be solved by just using a few lines of code.


[crockford]: https://plus.google.com/+DouglasCrockfordEsq/posts/RK8qyGVaGSr
