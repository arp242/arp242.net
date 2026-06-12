---
title: "Dependencies should be fetched directly from VCS"
date: 2026-06-12
tags: ['Security', 'Ruby']
---

I've been writing Ruby at my new $dayjob in the last month. After spending most
of the last decade writing Go it's been a fun change of scenery. I did Ruby
before (years ago) and I can't really tell you which is "better" – Ruby is very
different from Go in almost every respect and I find both quite effective in
getting stuff done in their own way.

One aspect where I do feel Go is clearly better is dependency management;
specifically the security aspect thereof. Go is not magically immune to
malicious dependencies, but it is a lot more resistant to them chiefly because
there is no "publish a package" step.

---

In Go dependencies are identified by URL, e.g. github.com/user/pkg. Go
identifies which VCS is being used (git in this case) and fetches the tag or
commit you specified in your go.mod file. The go.mod file serves as both a
dependency specification and "lock file". It lists exact versions; there is no
~\>1.1. It includes both direct and indirect dependencies and lists your full
dependency tree (the go command writes to go.mod).

There are more aspects to Go Modules, including security features, but I will
skip over them for the purpose of this article. The relevant bit is
"dependencies are identified by URL, the code is fetched directly from the VCS,
and it does this for both direct and indirect dependencies".

Auditing and updating dependencies is easy: I do `git log -p old..new` (usually
via a forge web UI), read all the commits, and update the go.mod file. I don't
have many dependencies and those I do have don't change much. It's usually
pretty fast. I don't need to do careful in-depth reviews here; just look for
suspicious stuff. Something like `exec.Command(..)` or `http.Post(..)` in a
globbing library would stand out. It's hard to really hide stuff.

I've been doing this for years for every dependency. As a solo developer. It's
easy. Some projects have much larger dependency trees and this becomes more
time-consuming, but not hard or confusing. It's still easy, just takes a bit of
time.

---

For Ruby things are different as it has a "publish a package" step: you create a
.gem archive and upload that to rubygems.org. You can put anything in there – no
guarantee the .gem contents correspond to the source repo. To audit it I need to
do something like:

    curl -s https://rubygems.org/downloads/example-2.7.5.gem >old.gem
    curl -s https://rubygems.org/downloads/example-2.8.2.gem >new.gem

    mkdir old new
    tar xf old.gem -C old
    tar xf new.gem -C new

    (cd old && tar xf data.tar.gz)
    (cd new && tar xf data.tar.gz)

    diff -urN old new

It works, I guess, but is far from easy. The individual commits are lost and is
generally harder to audit. In some cases the diff is small enough that it's
okay. In other cases it's huge and not having access to the commits is a pain. I
can also totally see myself get confused about what I did and didn't audit. I
guess the number of people doing this sort of auditing is very low because it's
just such a pain.

This is not unique to Ruby: this is how many (most?) package systems work.

---

Almost all of the "side-channel attacks" I've seen are perhaps more accurately
described as "package publishing attacks". They rely on injecting something in
the "publish a package" step. Whether that's RubyGems, npm, PyPI, .tar.gz FTP
downloads, or something else is a relatively minor detail. It's rare that the
actual source repo gets compromised as it's just too visible. You need to at
least slightly hide your exploit for it to be effective.

The recent npm compromises all relied on gaining access to the npm account and
injecting something in the published package. xz had some exploit code in the
source repo but was inert, hidden in a binary test file and only activated in
the modified .tar.gz release. Back in 2018 event-stream added a dependency on
flatmap-stream, which had nefarious code in index.min.js only on the published
npm package.

Which points to a second problem: packages containing "compiled" resources. The
JavaScript that TypeScript generates is not completely unreadable, it's
certainly much *less* readable and auditable than the original TypeScript. To
say nothing of minified files or binary blobs. This is less of a problem in
Ruby, but a far bigger problem in npm.

---

Last week RubyGems [added a cooldown option] and "AI-assisted vulnerability
scanning against the most critical gems". Not a bad thing to do as a short-term
move, but I feel a more appropriate solution would be to reconsider the entire
"publish a package" model. It just lacks the required transparency. AI tools are
not going to magically fix that.

I probably would have created something similar to RubyGems myself twenty years
ago. Distributing .tar.gz files on SourceForge was by and large how things
worked and many projects did not have a publicly accessible VCS repo, or did not
have one at all. Generally this worked fairly well at the time. I'm not blaming
any one here – I would have done the same. RubyGems is just designed in a
different world.

I'm not saying RubyGems and npm need to copy what Go does *exactly* in every
respect and I'm not saying all of this is completely perfect either. But as far
as I know, it's the best anyone has come up with thus far. Some other aspects of
Go modules (such as [Minimal Version Selection]) are less important.

I appreciating that completely changing how this works is hard and potentially
disruptive. But dealing with this endless stream of hijacked packages is also
hard and disruptive. So...

In the specific case of Bundler, there is already *some* support for this. You
can do:

    gem 'rails', git: 'https://github.com/rails/rails.git', tag: 'v8.1.2'

And it will fetch the rails gem from git, but will still fetch dependencies from
rubygems.org. Maybe there is some way to cajole Bundler in to using git for
everything, but it's an uphill battle and easy to accidentally use rubygems.org.

Just thinking out loud here, but something like this would probably go a long
way, and won't break existing Gemfiles:

    # Do not allow fetching anything from rubygems.org;
    # changes gem() behaviour to use git.
    must 'use-git'

    gem 'github.com/rails/rails', 'v8.1.2'

    # Indirect (automatically written and updated by "bundle install" and similar)
    indirect do
        gem 'github.com/rails/actionview', 'v8.1.2'
        gem 'github.com/fxn/zeitwerk',     'v2.8.2'
        # ... etc...
    end

Gemfile.lock can still be used for hashes (similar to go.sum), but is otherwise
not all that useful.

There's a bunch of details to be sorted out here and I'm not pretending those
are straight-forward to sort out well, but there does seem to be a reasonable
path there, I think?

---

Or maybe something else entirely. I don't know. The main point is: **I want to
reliably audit my dependencies like a responsible developer and RubyGems makes
it too hard**, as do other package managers (but I don't care about them).

[added a cooldown option]: https://blog.rubygems.org/2026/06/03/cooldown-let-new-gems-be-vetted.html
[Minimal Version Selection]: https://go.dev/ref/mod#minimal-version-selection
