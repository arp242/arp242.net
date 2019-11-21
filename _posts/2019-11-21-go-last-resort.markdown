---
layout: post
title: 'Go’s features of last resort'
---

A "Feature of Last Resort" (FOLR) is a useful feature which solves certain
otherwise hard-to-solve problems, but are often best avoided.

I stole this term from Mercurial's [Features of Last Resort][hg] wiki page. As
far as I know it originated on that page (and isn't widely used outside of it).
Many complex systems have these kind of FOLRs, and being explicit about it makes
things easier for new users, who do not yet have the experience to distinguish
them from regular features.

At any rate, this is a list of what I consider FOLRs in Go.[^list]

[^list]: The list is not 100% comprehensive. For example Go compiler directives
         and arguably type aliases could also be included, but I have not
         witnessed them being abused often so I excluded them for brevity.

Struct tags
-----------

Struct tags allow annotating struct fields with extra metadata to be retrieved
at runtime with reflection:

    type T struct {
        F int `json:"f"`
    }

**Why it exists and when to use** – provide name aliases for marshalling and
unmarshalling, which would be tricky otherwise (pass a `map[string]string` to
`json.Marshal()`?)

**Problems** – lack of type checking; typos can pass silently. `vet` catches a
bunch of spacing errors, but won't catch misspellings. Libraries that use struct
tags often don't error out at runtime (you can never be quite sure if a struct
tag is intended for you or not, so erroring out may cause conflicts).

Especially some of the more creative uses of struct tags is essentially
"programming by comments". There is no "discoverability" in the form of API
docs, code completion, etc. If I see the struct tag `valid:"yikes"` then how do
I figure out what this means to who? With regular Go code I can "jump to
definition" or grep, but for struct tags this is much harder.

It also rather hard to read (non-aligned) and edit (follows from being hard to
read).

**Alternatives** – it depends on what exactly you're doing, but data (e.g. map)
or function calls can cover almost all struct tag cases.


Empty interface
---------------

The empty interface (`interface{}`) is an interface with no methods, and is
satisfied by any type.

**Why it exists and when to use** – sometimes you really need to accept any
type (but this is not very common for most types of programs).

**Problems** – no compile-time type checks; limited tooling support. Reflection
is hard, may be quite slow, and often incomplete (are you sure
`map[string]map[int][]struct{}` will work for your function that accepts "any"
type?)

**Alternatives** – this is the *Great Go Generics Debate*. Alternatives include:

- Write it multiple times for each type (possibly generated).
- Use an actual interface with methods.
- Convert to other type; e.g. just accept `int64` instead of `int` and call as
  `fun(int64(i))`.

See [Summary of Go Generics Discussions][generics] for some more details and
examples.

Imports aliases, dot-imports
----------------------------

Imports can be aliased as `b "foo/bar"`, so that instead of `bar.X` you use
`b.X`. All identifiers can be imported to the current namespace with
`. "foo/bar"`, in which case you'd use just `X`.

**Why it exists and when to use** – sometimes you need to alias packages to
prevent conflicts. Ideally package names should be unique, but sometimes it
happens when combining third-party packages. It's also needed when a directory
name contains invalid identifier characters (e.g. `go-pkg`).

The dot-imports exist mostly for tests that run outside the package they're
testing ([`pkg_test` packages][test]).

**Problems** – names often assume the package name, for example `zip.File` is
clearer than `z.File` or `File`. It almost always hurts readability. Especially
when used to shorten longer package names it can be unclear what something like
`b` refers to. 

**Alternatives** – just use regular imports.


panic()
-------

The `panic()` builtin displays a message, stack trace, and halts the program,
unless `recover()`'d.

**Why it exists and when to use** – sometimes the program really cannot continue
and the only thing left to do is to "panic". It's also a way to indicate that
something impossible has happened, such as exiting an infinite loop,
initialisation error (*"can't find foo.html"*), or some types of programmer
error on startup (*"can't pass empty string"*).

I think "never use panic", or even "never use panic in libraries" is too strict.
Using panics to signal initialisation errors is often convenient, especially for
functions which would otherwise not have error returns.

**Problems** – using panics as if they're exceptions is probably the most common
mistake I've seen new Go programmers make. It's understandable (I did it
myself!), but it's not how Go is expected to be used.

Panics *can* be used like exceptions, but this does not fit Go's
design aesthetics very well. Exceptions are generally considered to not be worth
the cost; see e.g. [Exception Handling Considered Harmful][exceptions].

Panics are a bit tricky to recover from and are often unexpected since it's not
the standard way to deal with errors in Go. In general it's best to forget that
`recover()` exists and consider panics as a shortcut for:

    fmt.Fprintln(os.Stderr, "oh noes!")
    debug.PrintStack()
    os.Exit(1)

Are you *sure* this is what you want to do? Sometimes it is, but often it's not.

**Alternatives** – most of the time just return errors.

init()
------

All `init()` functions in a package are automatically run when it's imported.

**Why it exists and when to use** – initialize data and set up state, for
example lookup tables or some package-global object.

**Problems** – there are a bunch of (potential) problems:

- It's "hidden" code that gets run, which can be surprising and unexpected
  especially if the code is non-trivial.
- Relying on global state is often not the best solution.
- It can make testing needlessly difficult.
- It's hard to signal errors (outside of `panic`).
- Can be a waste of resources if `init()` sets up something for `A()`, and you
  just want `B()`

**Alternatives** – depending on what you want to do:

- Instead of relying on package globals, using `NewFoo() Foo` constructors and
  passing `Foo` as a function argument is often a good alternative. See [A
  theory of modern Go][modern-go].

- For setting up a package-level variable a self-executing function will work
  just as well, and is clearer about what it's doing instead of relying on
  side-effects:

      var geodb = func() *geoip2.Reader {
          g, err := geoip2.FromBytes(pack.GeoDB)
          if err != nil {
              panic(err)
          }
          return g
      }()

   Which is even shorter than the `init()` solution:

      var geodb *geoip2.Reader

      func init() {
          var err error
          geodb, err = geoip2.FromBytes(pack.GeoDB)
          if err != nil {
              panic(err)
          }
      }

  Note I don't agree these kind of package-level variables should *always* be
  avoided like *A theory of modern Go* advocates. e.g. in the example above
  `geodb` is essentially just a fancy IP address → country code lookup table,
  and passing that through several layers of functions for just one call is IMO
  less clear.

cgo
---

cgo allows calling C code from Go.

**Why it exists and when to use** – interacting with C libraries, which are
ubiquitous. Perhaps the most commonly used cgo library is SQLite, which is a
perfectly valid use and would be impossible to implement without cgo.

**Problems** – it's comparatively slow, it inherits some of C's problems such as
unsafe memory, can be tricky to understand by Go programmers, and it makes
builds slower and more tricky. See [cgo is not Go][cgo] for a more detailed
breakdown of possible issues.

**Alternatives** – write it in Go if at all feasible.

<!--
Other
-----

While not exactly features of last resort", an additional (opinionated) list of
*"perhaps best avoided"*s:

- I never like "naked returns". Naming return values can be useful for
  documentation and clarity, but just add the variables with `return`.

- `if err != nil { return err }` should often do something more useful, like
  adding context, but be careful not to duplicate context! For example
  `os.Open()` will already include the filename (`open /nonexistent: no such
  file or directory`) so using `fmt.Errorf("cannot open %q: %s", filename, err)`
  is not very helpful.
-->


[hg]: https://www.mercurial-scm.org/wiki/FeaturesOfLastResort
[generics]: https://docs.google.com/document/d/1vrAy9gMpMoS3uaVphB32uVXX4pi-HnNjkMEgyAHX4N4/edit
[test]: https://golang.org/cmd/go/#hdr-Test_packages
[exceptions]: http://www.lighterra.com/papers/exceptionsharmful/
[modern-go]: https://peter.bourgon.org/blog/2017/06/09/theory-of-modern-go.html
[cgo]: https://dave.cheney.net/2016/01/18/cgo-is-not-go
