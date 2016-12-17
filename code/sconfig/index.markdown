---
layout: code
title: "sconfig"
link: "sconfig"
last_version: "master"
pre1: "Project status: experimental"

---

[![GoDoc](https://godoc.org/arp242.net/sconfig?status.svg)](https://godoc.org/arp242.net/sconfig)
[![Go Report Card](https://goreportcard.com/badge/github.com/Carpetsmoker/sconfig)](https://goreportcard.com/report/github.com/Carpetsmoker/sconfig)
[![Build Status](https://travis-ci.org/Carpetsmoker/sconfig.svg?branch=master)](https://travis-ci.org/Carpetsmoker/sconfig)
[![Coverage Status](https://coveralls.io/repos/github/Carpetsmoker/sconfig/badge.svg?branch=master)](https://coveralls.io/github/Carpetsmoker/sconfig?branch=master)

`sconfig` is a simple and functional configuration file parser for Go.

What does it look like?
=======================
A file like this:

	# This is a comment

	port 8080 # This is also a comment

	# Look ma, no quotes!
	base-url http://example.com

	# We'll parse these in a []*regexp.Regexp
	match ^foo.+
	match ^b[ao]r

	# Two values
	order allow deny

	host  # Idented lines are collapsed
		arp242.net         # My website
		stackoverflow.com  # I like this too

	address arp242.net

Can be parsed with:

	package main

	import (
		"fmt"
		"os"

		"arp242.net/sconfig"

		// Types that need imports are in handlers/pkgname
		_ "arp242.net/sconfig/handlers/regexp"
	)

	type Config struct {
		Port    int64
		BaseURL string
		Match   []*regexp.Regexp
		Order   []string
		Hosts   []string
		Address string
	}

	func main() {
		config := Config{}
		err := sconfig.Parse(&config, "config", sconfig.Handlers{
			// Customer handler
			"address": func(line []string) error {
				addr, err := net.LookupHost(line[0])
				if err != nil {
					return err
				}

				config.Address = addr[0]
				return nil
			},
		})

		if err != nil {
			fmt.Fprintf(os.Stderr, "Error parsing config: %v", err)
		}

		fmt.Printf("%#v\n", config)
	}


But why not...
==============
- JSON?  
  JSON is not at all suitable for configuration files. Also see: [JSON as
  configuration files: please don’t][json-no].
- YAML?  
  I don't like the whitespace significance in config files, and YAML can have
  some weird behaviour. Also see: [YAML: probably not so great after all][yaml-meh].
- XML?  

		<?xml version="1.0"?>
		<faq>
			<header level="2">
				<content>But why not...</content>
			</header>
			<items type="list">
				<item>
					<question>XML?</question>
					<answer type="string" adjective="Very" fullstop="true">funny</answer>
				</item>
			</items>
		</faq>

- INI or TOML?  
  They're both fine, I just don't like the syntax much. Typing all those pesky
  `=` and `"` characters is just so much work man!

How do I...
===========

Validate fields?
---------------
There is no built-in way to do this. You can use `if` statements :-)

Maybe I'll add this at a later date, an early (unreleased) version actually had
tag-based validation, but I removed it as it added a bunch of complexity and I'm
not at all sure this is a common enough problem that needs solving.

Besides, there are are several libraries that already do a good job at that such
as
[validator](https://github.com/go-playground/validator),
[go-validation](https://github.com/BakedSoftware/go-validation),
and others.

Set default values?
-------------------
Just set them before parsing:

	c := MyConfig{Value: "The default"}
	sconfig.Parse(&c, "a-file", sconfig.Handlers{})

Use `int` types? I get an error?
--------------------------------
Only `int64` and `uint64` are handled by default; this should be fine for
almost all use cases of this package. If you want to add them, you can do easily
with your own TypeHandler :-)

Note that the size of `int` and `uint` are platform-dependent, so adding those
may not be a good idea...

I get a "don’t know how to set fields of the type ..." error if I try to use `sconfig.TypeHandlers`
---------------------------------------------------------------------------------------------------
Include the package name; even if the TypeHandler is in the same package. Do:

    sconfig.TypeHandlers["[]main.RecordT"] = func(v []string) (interface{}, error) {

and not:

	sconfig.TypeHandlers["[]RecordT"] = func(v []string) (interface{}, error) {

Replace `main` with the appreciate pacakge name.


Syntax
======
The syntax of the file is very simple.

### Definitions

- Whitespace: any Unicode whitespace.
- Hash: `#` character (U+0023).
- Backslash: `\` character (U+005C).
- Space: ` ` character (U+0020).
- NULL byte: U+0000.
- Newline LF (U+000A) or CR+LF (U+000D, U+000A).
- Line: Any set of characters ended by a Newline

### Reading the file

- A file must be encoded in UTF-8.

- Everything after the first Hash is considered to be a comment and will be
  ignored unless a Hash is immediately preceded by a Backslash.

- All Whitespace is collapsed to a single space unless a Whitespace character is
  preceded by a Backslash.

- Any Backslash immediately preceded by a Backslash will be treated as a single
  Backslash.

- Any Backslash immediately followed by anything other than a Hash, Whitespace,
  or Backslash is treated as a single Backslash.

- Anything before the first Whitespace is considered the Key.

	- Any character except Whitespace and NULL bytes are allowed in the Key.

- Anything after the first Whitespace is considered the Value.

	- Any character except NULL bytes are allowed in the Value.
	- The Value is optional.

- All Lines that start with one or more Whitespace characters will be appended
  to the last Value.

Programs using it
=================
- [trackwall](https://arp242.net/code/trackwall)
- [transip-dynamic](https://arp242.net/code/transip-dynamic)

Alternatives
============
Aside from those mentioned in the "But why not..." section above:

- [https://github.com/kovetskiy/ko](https://github.com/kovetskiy/ko)

[json-no]: http://arp242.net/weblog/JSON_as_configuration_files-_please_dont.html
[yaml-meh]: http://arp242.net/weblog/yaml_probably_not_so_great_after_all.html
