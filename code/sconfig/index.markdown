---
layout: code
title: "sconfig"
link: "sconfig"
last_version: "v1.1"
---

[![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)
[![GoDoc](https://godoc.org/arp242.net/sconfig?status.svg)](https://godoc.org/arp242.net/sconfig)
[![Build Status](https://travis-ci.org/Carpetsmoker/sconfig.svg?branch=master)](https://travis-ci.org/Carpetsmoker/sconfig)
[![codecov](https://codecov.io/gh/Carpetsmoker/sconfig/branch/master/graph/badge.svg)](https://codecov.io/gh/Carpetsmoker/sconfig)

`sconfig` is a simple and functional configuration file parser for Go.

Installing
==========

	go get arp242.net/sconfig

Go 1.5 and newer should work, but the test suite only runs with 1.7 and newer.

What does it look like?
=======================
A file like this:

```apache
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
```

Can be parsed with:

```go
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
		// Custom handler
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
```

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

- Viper?  
  [viper](https://github.com/spf13/viper/) is very popular, which I frankly find
  somewhat surprising. It's large, quite complex, adds a [a lot of
  dependencies](https://godoc.org/github.com/spf13/viper?import-graph), and IMHO
  doesn't even work all that well to begin with.

How do I...
===========

Validate fields?
----------------
Handlers can be chained. For example the default handler for `int64` is:

	RegisterType("int64", ValidateSingleValue(), handleInt64)

`ValidateSingleValue()` returns a type handler that will give an error if there
isn't a single value for this key; for example this is an error:

	foo 42 42

There are several others as well. See `Validate*()` in godoc. You can add more
complex validation handlers if you want, but in general I would recommend just
using plain ol' `if` statements.

Adding things such as tag-based validation isn't a goal at this point. I'm not
at all that sure this is a common enough problem that needs solving, and there
are already many other packages which do this (no need to reinvent the wheel).

Set default values?
-------------------
Just set them before parsing:

	c := MyConfig{Value: "The default"}
	sconfig.Parse(&c, "a-file", nil)

Override from the environment/flags/etc.?
-----------------------------------------
There is no direct built-in support for that, but there is `Fields()` to
list all the field names. For example:

	c := MyConfig{Foo string}
	sconfig.Parse(&c, "a-file", nil)

	for name, val := range sconfig.Fields(&c) {
		if flag[name] != "" {
			val.SetString(flag[name])
		}
	}

Use `int` types? I get an error?
--------------------------------
Only `int64` and `uint64` are handled by default; this should be fine for almost
all use cases of this package. If you want to add any of the other (u)int types
you can do easily with your own type handler :-)

Note that the size of `int` and `uint` are platform-dependent, so adding those
may not be a good idea.

Use my own types as config fields?
----------------------------------
You have three options:

- Add a type handler with `sconfig.RegisterType()`.
- Make your type satisfy the `encoding.TextUnmarshaler` interface.
- Add a `Handler` in `sconfig.Parse()`.

I get a "don’t know how to set fields of the type ..." error if I try to add a new type handler
-----------------------------------------------------------------------------------------------
Include the package name; even if the type handler is in the same package. Do:

	sconfig.RegisterType("[]main.RecordT", func(v []string) (interface{}, error) {
	}

and not:

	sconfig.RegisterType("[]RecordT", func(v []string) (interface{}, error) {
	}

Replace `main` with the appropriate package name.


Syntax
======
The syntax of the file is very simple.

### Definitions

- Whitespace: any Unicode whitespace.
- Hash: `#` character (U+0023).
- Backslash: `\` character (U+005C).
- Space: ` ` character (U+0020).
- NULL byte: U+0000.
- Newline: LF (U+000A) or CR+LF (U+000D, U+000A).
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

Alternatives
============
Aside from those mentioned in the "But why not..." section above:

- [github.com/kovetskiy/ko](https://github.com/kovetskiy/ko)
- [github.com/stevenroose/gonfig](https://github.com/stevenroose/gonfig)

Probably others? Open an issue/PR and I'll add it.

[json-no]: http://arp242.net/weblog/JSON_as_configuration_files-_please_dont.html
[yaml-meh]: http://arp242.net/weblog/yaml_probably_not_so_great_after_all.html
