---
title: "An API is a user interface"
date: 2020-11-25
tags: ['Programming']
updated: 2020-11-26
hatnote: |
    Discussions:
      [Lobsters](https://lobste.rs/s/tyabnv/api_is_user_interface),
      [Hacker News](https://news.ycombinator.com/item?id=25206182)
---

An API is a user interface for programmers, and is no different from a graphical
user interface, command-line user interface, or any other interface a human is
expected to work with. Turns out programmers are people – who would have
thought?

Whenever you create a publicly callable function you're creating a user
interface.

This applies to any API: libX11, libpng, Ruby on Rails, Go stdlib, a REST API,
gRPC, etc.

A library exists of two parts: implementation and exposed API. The
implementation is all about doing *stuff* and interacting with the computer,
whereas the exposed API is about giving a human access to this, preferably in a
convenient way that makes it easy to understand, and making it hard to get
things wrong.

This may sound rather obvious, but in my experience this often seems forgotten.
The world is full of badly documented clunky APIs that give confusing errors (or
no errors!) to prove it.

Whenever I design a public package, module, or class I tend to start by writing
a few basic usage examples and documenting it. This first draft won't be perfect
and while writing the implementation I keep updating the examples and
documentation to iterate on what works and axe what doesn't. This is kind of
like TDD, except that it "tests" the UX rather than the implementation. Call it
*Example Driven Development* if you will.

This is similar to sketching a basic mock UI for a GUI and avoids "oh, we need
to be able to do that too" half-way through building your UI, leading to awkward
clunky UI elements added as an afterthought.

In code reviews the first questions I usually have are things like "is this API
easy to use?", "Is it consistent?", "can we extend it in the future so it won't
be ugly?", "is it documented, and is the documentation comprehensible?".
Sometimes I'll even go as far as trying to write a simple example to see if
there are any problems and if it "feels" right. Only if this part is settled do
I move on to reviewing the correctness of the actual implementation.

---

I'm not going to list specific examples or tips here; it really depends on the
environment, intended audience, and most of all: what you're doing. Kernel
programming is different from doing a web UI for Rails.

Sometimes a single function with five parameters would be bad UX, whereas in
other cases it might be a good option, if all five really are mandatory, or if
you use Python and have named parameters. In other cases, it makes more sense to
have five functions which accept a single parameter.
There isn't "one right way" and some amount of subjective sense of "taste" is
involved. That's okay; things don't need to be perfect: if everyone started
treating APIs as user interfaces instead of "oh, it's just for developers, they
will figure it out" then we'll be 90% there.

That being said, the most useful general piece of advice I know of is John
Ousterhout's concept of *deep modules*: modules that provide large functionality
with simple interfaces. [Depth of module][depth] is a nice overview with goes in
to some more details about this, and I won't repeat it here.

[depth]: https://nakabonne.dev/posts/depth-of-module/

{% related_articles %}
- [Your Database as an API](http://kevinmahoney.co.uk/articles/your-database-as-an-api/)
- [UX Testing for Code](https://medium.com/@quikchange/ux-testing-for-code-e9ab157fb90f)
- [Measuring API Usability](https://www.drdobbs.com/windows/measuring-api-usability/184405654)
- [Readme Driven Development](https://tom.preston-werner.com/2010/08/23/readme-driven-development.html)
{% endrelated_articles %}
