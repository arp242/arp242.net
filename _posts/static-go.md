---
title: "Statically compiling Go programs"
date: 2020-04-11
tags: ['Go']
---

Go creates static binaries by default unless you use cgo to call C code, in
which case it will create a dynamically linked binary. Using cgo is more common
than many people assume as the `os/user` and `net` packages use cgo, so
importing either (directly or indirectly) will result in a dynamic binary.

The easiest way to check if your program is statically compiled is to run `file`
on it:

{:class="ft-cli"}
    % file test.dynamic | tr , '\n'
    test.dynamic: ELF 64-bit LSB executable
     x86-64
     version 1 (SYSV)
     dynamically linked
     interpreter /lib/ld-linux-x86-64.so.2
     Go BuildID=LxsDWU_fMQ9Cox6y4bSV/fdMBNuZAmOuPSIKb2RXJ/rcazy_d6AbaoNtes-qID/nRiDtV1fOY2eoEVlyqnu
     not stripped

    % file test.static | tr , '\n'
    test.static:  ELF 64-bit LSB executable
     x86-64
     version 1 (SYSV)
     statically linked
     Go BuildID=hz56qplN20RU01EMBelb/58lm7IuCas399AWvpycN/BGETSDXvSFKK3BUjfgon/5xa5xLDJTC90556SUlNh
     not stripped

Notice the "dynamically linked" and "statically linked". You can also run `ldd`,
but this only works if the binary matches your system's architecture:

{:class="ft-cli"}
    % ldd test.dynamic
    test.dynamic:
            linux-vdso.so.1 (0x00007ffe00302000)
            libpthread.so.0 => /usr/lib/libpthread.so.0 (0x00007f3f86f4a000)
            libc.so.6 => /usr/lib/libc.so.6 (0x00007f3f86d87000)
            /lib/ld-linux-x86-64.so.2 (0x00007f3f86f80000)

    % ldd test.static
    test.static:
            not a dynamic executable

You can verify that a binary runs without external dependencies with `chroot`
(this requires root on most platforms):

{:class="ft-cli"}
    % chroot . ./test.static
    Hello, world!

    % chroot . ./test.dynamic
    chroot: failed to run command './test.dynamic': No such file or directory

The "No such file or directory" error is a bit strange, but it means that the
dynamic linker (e.g. `ld-linux`) isn't found. Unfortunately this is the exact
same message as when the `test.dynamic` itself isn't found, so make sure you
didn't typo it. I'm not sure if there's any way to get Linux to emit a more
useful message for this.[^h]

[^h]: It's a common source of confusion when a hashbang (`#!/bin/prog`) is set
      to a program that doesn't exist at that location.

---

There are two packages in the standard library that use cgo:

- `os/user` contains cgo code to use the standard C library to map user and
  group ids to user and group names. There is also a Go implementation which
  parses `/etc/passwd` and `/etc/group`. The advantage of using the C library is
  that it can also get user information from LDAP or NIS. If you don't use that
  – most people don't – then there is no real difference.

  On Windows there is only a Go implementation and this doesn't apply.

- `net` can use the C standard library to resolve domain names, but by default
  it uses the Go client. The C library has a few more features (e.g. you can
  configure `getaddrinfo()` with `/etc/gai.conf`) and some platforms don't have
  a `resolv.conf` (e.g. Android), but for most cases the Go library should work
  well.

Your binary will not be statically linked if your program imports one of those
two packages, either directly through a dependency. Especially the `net` one is
quite common.

You can use the `osusergo` and `netgo` build tags to skip building the cgo
parts:

{:class="ft-cli"}
    % go build -tags osusergo
    % go build -tags netgo
    % go build -tags osusergo,netgo

For simple cases where you don't use any other cgo code it's probably easier to
just disable cgo, since the cgo code is protected with a `cgo` build tag:

{:class="ft-cli"}
    % CGO_ENABLED=0 go build

---

What if we want to use the cgo versions of the above? Or what if we want to use
a cgo package such as SQLite? In those cases you can tell the C linker to
statically link with `-extldflags`:

{:class="ft-cli"}
    % go build -ldflags="-extldflags=-static"

The nested `-`s look a bit confusing and are easy to forget, so be sure to pay
attention (or maybe that's just me... 🤦‍♂️).[^f]

[^f]: The value of `-ldflags` is passed to `go tool link`, which passes the
      value of `-extldflags` to the C compiler.
      There's [an issue to make this easier](https://github.com/golang/go/issues/26492).

Some packages – such as SQLite – may produce warnings:

{:class="ft-cli"}
    % go build -ldflags="-extldflags=-static"
    # test
    /usr/bin/ld: /tmp/go-link-400285317/000010.o: in function `unixDlOpen':
    /[..]/sqlite3-binding.c:39689: warning: Using 'dlopen' in statically linked
    applications requires at runtime the shared libraries from the glibc version used
    for linking

`dlopen()` loads shared libraries at runtime; looking at the SQLite source code
it's only used only for [dynamically loading extensions][loadext]. This is not a
commonly used feature so this warning can be safely ignored for most programs
(you can verify with the chroot mentioned earlier). 

The go-sqlite3 package [provides a build flag to disable this][goext], if you
want to make the warnings go away and ensure this feature isn't used:

{:class="ft-cli"}
    % go build -ldflags="-extldflags=-static" -tags sqlite_omit_load_extension

The `os/user` and `net` packages will give you a similar warnings about the
`getpwnam_r()` etc. and `getaddrinfo()` functions; which also depend on runtime
configurations. You can use the tags mentioned earlier to make sure the Go code
is used.

Other cgo packages may emit similar warnings; you'll have to check the
documentation or source code to see if they're significant or not.

[loadext]: https://www.sqlite.org/loadext.html
[goext]: https://github.com/mattn/go-sqlite3/#feature--extension-list

---

One of Go's nicer features is that you can cross-compile to any
system/architecture combination from any system by just setting setting `GOOS`
and `GOARCH`. I can build Windows binaries on OpenBSD with `GOOS=windows
GOARCH=amd64 go build`. Neat!

With cgo cross-compiling gets a bit trickier as cross-compiling C code is
trickier.

The short version is that cross-compiling to different *architectures* (amd64,
arm, etc.) for the same OS isn't too hard, but cross-compiling to different
*operating systems* is rather harder. It's certainly doable, but you need the
entire toolchain and libraries for the target OS. It's a bit of a hassle and
probably easier to just start a virtual machine.

You'll need to install the toolchain for the target architecture (and OS, if
you're compiling to a different OS); if you're on Linux your package manager
will probably already include it, but they're named different on different
distros. Usually searching for `-linux-gnu` (or `-linux-musl`) should give you
an overview.

I'm very 😎 so I use Void Linux, and for extra 😎 I want to use musl libc, so
that's what I'll use in this example to cross-compile to arm and arm64; let me
know if you have the commands for other systems and I'll add them as well.[^p]

{:class="ft-cli"}
    # Replace musl with gnu if you want to use GNU libc.
    % xbps-install cross-aarch64-linux-musl cross-armv7l-linux-musleabihf

    % GOOS=linux GOARCH=arm64 CGO_ENABLED=1 CC=aarch64-linux-musl-gcc \
        go build -ldflags='-extldflags=-static' -o test.arm64 ./test.go

    % GOOS=linux GOARCH=arm CGO_ENABLED=1 CC=armv7l-linux-musleabihf-gcc \
        go build -ldflags='-extldflags=-static' -o test.arm ./test.go

aarch64 and arm64 are the same thing, just with a different name, just as x86_64
and amd64. To confirm that it works, you can use QEMU; for example with a simple
programs which runs `select date()` on a :memory: database:

{:class="ft-cli"}
    % qemu-aarch64 ./test.arm64
    <nil> 2020-04-11

    % qemu-arm ./test.arm
    <nil> 2020-04-11

Huzzah!

[^p]: Figuring them out just from the package index is a bit too much
      work/hassle, and also untested so it may contain errors or silly typos.

To make releasing binaries a bit easier I wrote a small script:
[gogo-release][gogo]. It's just a glorified `for` loop (a lot of software is,
really) to make the above a bit easier. For non-cgo projects the defaults
settings should work without problems. This is what I use to build GoatCounter
(which includes SQLite):

{:class="ft-sh"}
    matrix="
    linux amd64
    linux arm   CC=armv7l-linux-musleabihf-gcc
    linux arm64 CC=aarch64-linux-musl-gcc
    "

    build_flags="-trimpath -ldflags='-extldflags=-static -w -s -X main.version=$tag' -tags osusergo,netgo,sqlite_omit_load_extension ./cmd/goatcounter"

    export CGO_ENABLED=1

And then just run `gogo-release`.

---

To cross-compile for different systems I wrote [goon], which uses QEMU to start
a VM. It's a little bit unpolished, but it works. The main advantage of this is
that you can run tests on a "real" system, which is useful in some cases.

[zig] can also work (`zig cc`); unlike most other C compilers Zig ships with a
build environment for Linux, macOS, and Windows. It won't be helpful for
cross-compiling to other platforms (at the time of writing anyway; this may
change). See [this article][zig-cross] for some more details on that.

There is also [xgo][xgo], which [installs the required build
environment in a container][xgo-d]. It's not bad (although it is [a bit
messy][xgo-b]), but it only supports Linux, macOS, and Windows.

[goon]: https://github.com/arp242/goon
[zig]: https://ziglang.org/
[zig-cross]: https://dev.to/kristoff/zig-makes-go-cross-compilation-just-work-29ho



[gogo]: https://github.com/arp242/gogo-release
[xgo]: https://github.com/karalabe/xgo
[xgo-d]: https://github.com/karalabe/xgo/blob/master/docker/base/Dockerfile
[xgo-b]: https://github.com/karalabe/xgo/blob/master/docker/base/build.sh
