---
layout: post
title: "Better UX when reading from stdin"
tags: ['Unix', 'UX']
---

At some point you've probably typed `grep foo` instead of `grep foo file` or
`grep -r foo` and then spent far too long waiting for output before realizing
grep was waiting for input from stdin 🤦 Reading from stdin can be confusing.
The program *appears* to be working, but it's actually waiting to read from
stdin.

So, for years I've been adding this little line to tell users the program is
reading from stdin:

    fmt.Fprintf(stderr, "%s: reading from stdin...\n", filepath.Base(os.Args[0]))

This is in Go because that's what I'm using today, but it will work just as well
in any other language. It's printed to stderr so it won't interfere with regular
stdout piping.

This is helpful especially in cases where reading from stdin isn't necessarily
expected; for example my [uni][uni] tool will identify all codepoints with `uni
identify hello`, but with just `uni identify` it will read from stdin, which is
very useful but probably not expected by everyone.

The downside is that actually using it in a pipe looks a bit ugly:

    $ echo x | uni identify
    uni: reading from stdin...
         cpoint  dec    utf-8       html       name
    'x'  U+0078  120    78          &#x78;     LATIN SMALL LETTER X (Lowercase_Letter)

We can further improve on this by only showing this message if stdin is a
terminal:

    if isatty.IsTerminal(os.Stdin.Fd()) { // https://github.com/mattn/go-isatty
        fmt.Fprintf(os.Stderr, "%s: reading from stdin...\n", filepath.Base(os.Args[0]))
    }

	stdin, err := ioutil.ReadAll(os.Stdin)
	if err != nil {
		panic(fmt.Errorf("read stdin: %s", err))
	}

Or, alternatively, erasing the message after reading from stdin:

    fmt.Fprintf(os.Stderr, "%s: reading from stdin...", filepath.Base(os.Args[0]))
    os.Stderr.Sync()

	stdin, err := ioutil.ReadAll(os.Stdin)
	if err != nil {
		panic(fmt.Errorf("read stdin: %s", err))
	}

	fmt.Fprintf(stderr, "\r")

One thing to be careful of is that `\r` won't erase anything; it just puts the
cursor in the first column so new output will overwrite what's there. You can
see this with something like `printf 'Hello\ra\n'`, which appears as `aello`.

For many applications this is fine, but if the first line of output might be
shorter than the stdin message you can erase the line with an escape sequence:

	fmt.Fprintf(stderr, "\r\x1b[0K")

---

Here's a shell script version, too:

    printf >&2 '%s: reading from stdin...' "$(basename "$0")"
    stdin=$(cat <&0)
    printf >&2 '\r\033[0K'

    echo "$stdin"

[uni]: https://github.com/arp242/uni/
