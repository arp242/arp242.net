---
title: 'Jia Tanning Go code'
date: '2024-10-28'
tags: ['Go', 'Security']
---

The Go compiler skips files ending with `_test.go` during normal compilation.
They are compiled with `go test` command (together will all other .go files),
which also inserts some chutney to run the test functions. The standard way to
do testing is to have a `foo.go` and `foo_test.go` file next to each other.

If you have a file that appears to end with `_test.go` but doesn't actually end
with `_test.go`, then it will get compiled for a regular build. For example:

    a_test\uFE0E.go

U+FE0E is a variation selector. These are typically very invisible. Or more
traditional homoglyph trickery:

    b_t\u0435\u0455t.go"

Those Cyrillic letters appear virtually identical on my machine: b_tеѕt.go /
b_test.go, or as monospace: `b_tеѕt.go` / `b_test.go`.

This can also be done with zero-width space, zero-width joiner, and perhaps a
few other codepoints, but variation selectors tend to be the "most invisible" of
them.

This is pretty sneaky, something like this:

{:class="ft-go"}

    // user.go
    var bcryptCost = bcrypt.DefaultCost

    func hashPassword(pwd []byte) []byte {
        pwd, _ := bcrypt.GenerateFromPassword(pwd, bcryptCost)
        return pwd
    }

{:class="ft-go"}

    // user_test.go
    func init() { // The special "init" function gets run on import.
        // Lower bcrypt cost in tests, because otherwise any test will take
        // well over a second as it's so slow.
        bcryptCost = bcrypt.MinCost
    }


Is perfectly valid, but with a doctored "non-test" `user_test.go` it will now
lower the security of *all* passwords, and effectively inserts a backdoor.

There are many variants one can think of: code that looks innocent and would
probably pass many reviews, but will backdoor the codebase by weakening the
security, or adds in "test users", "test keys", "default passwords", and things
like that.

Who is carefully auditing tests for security in the first place? I've audited a
bunch of packages over the years, but I've never paid much attention to the test
files.

---

Most tools don't display this: Vim, VSCode, macOS finder, Windows Explorer,
/bin/ls, GitHub, GitLab, etc. – they all just display `user_test.go` with no
indication there's something more there. Take a look at the [test repo]; all
seems fairly innocent. Arguably, that's how it should be, at least for some of
these programs. Variation selectors are a Unicode feature and required to
display certain types of text. That said, filenames are not really "normal
text", certainly not in the context of code.

[test repo]: https://github.com/arp242/test

The major exception is the git CLI with `core.quotePath=true` (the default),
which displays the byte sequences for anything that's not ASCII. You need to
enable that setting to have *any* non-ASCII path display correctly, and
depending on locality it's probably a somewhat common setting. And how many
people use the git CLI to review files (instead of GitHub web UI, VSCode
integration, etc?) I'm a pretty heavy git CLI user, but typically don't use "git
diff" or "git log" for viewing differences between releases, and even if I did,
there's a good chance I'd miss this in a "git diff".

Another way to detect this is to carefully pay attention to the URL in e.g.
GitHub when viewing files, which displays escapes for some – but not all – of
the variants. But this isn't displayed in the PR view, only when browsing files,
and is very easy to miss.

---

I reported this to GitHub, GitLab, and BitBucket back in June. None of them
considered this to be a security issue. I don't really understand why, because
it doesn't seem too dissimilar to [LTR trickery to hide code]. Also GitHub will
display a warning for PRs with this sort of trickery:

    The head ref may contain hidden characters: "a\uFE0Eb"

Crafted branch names is an issue but crafted files are not? Well okay 🤷

[LTR trickery to hide code]: https://github.com/nickboucher/trojan-source

Also emailed the security@golang.org, but they never got back to me, so I guess
they don't consider it an issue either.

Is it viable to do a real-world attack with this? I don't know, I haven't tried.
I am not employed at the University of Minnesota so I don't go around sending
malicious patches just to see what would happen.

But if I were tasked to Jia Tan a Go codebase, this seems a promising method.
There's very little obfuscation and with a bit of careful design from a
malicious actor everything can seem legitimate test code that's there for valid
reasons, being only malicious because it gets compiled in the regular program,
and because it still gets compiled in the test program the tests will still
work. Seems like a great way to hide malicious code in plain sight.

Doing a full Jia Tan and compromising ssh is still tricky, because that requires
doing the sort of stuff that typically has no business being in a test file.
That's why in xz it was hidden in binary test data. Still, with the right
project and a bit of creativity I could envision this as a step in a similar
scheme, especially when done by the maintainer itself.
