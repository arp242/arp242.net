---
layout: code
title: "testing.vim"
link: "testing.vim"
last_version: "master"
---

testing.vim is a small testing framework for Vim.

The design is loosely inspired by Go's `testing` package.

My philosophy of testing is that it should be kept as simple as feasible;
programming is already hard enough without struggling with a poorly documented
unintuitive testing framework. This is what makes testing.vim different from
some other testing Vim runners/frameworks.

testing.vim includes support for running benchmarks, benchmarking syntax
highlighting files, and code coverage reports (via [covimerage][cov]).

Example
-------

	fun! Test_example() abort
		if 2 isnot 2
			call Error('two is not two')
		endif

		" TODO: expand
	endfun

Usage
-----

Tests are stored in a `*_test.vim` files, all functions matching the
`Test_\k+() abort` signature will be run.
It is customary – but not mandatory – to store `n_test.vim` files next to the
`n.vim` file in the same directory.

testing.vim exposes several variables:

	g:test_verbose    -v flag from commandline (0 or 1).
	g:test_dir        Directory of the test file that's being run.
	g:test_tmpdir     Empty temp directory for writing; this is the default cwd.
	g:test_run        -r flag from commandline.
	g:test_bench      -b flag from commandline.

And a few functions:

	Error(msg)        Add a message to v:errors.
	Errorf(msg, ...)  Like Error(), but with printf() support.
	Log(msg)          Add a "log message" in v:errors; this won't fail the test.
	                  Useful since :echom and v:errors output isn't interleaved.
	Logf(msg, ...)    Like Log, with with print() support,.

Run `./test /path/to/file_test.vim` to run test in that file, `./test
/path/to/dir` to run all test files in a directory, or `./test/path/to/dir/...`
to run al test files in a directory and all subdirectories.

A test is considered to be "failed" when `v:errors` has any items that are not
marked as informational (as done by `Log()`).
Vim's `assert_*` functions write to `v:errors`, and it can also be written to as
a regular list for adding custom testing logic.

You can filter test functions with the `-r` option. See `./test -h` for various
other options.

testing.vim will always use the `vim` from `PATH` to run tests; prepend a
different PATH to run a different `vim`.

See [gopher.vim for an example Travis integration](https://github.com/Carpetsmoker/gopher.vim/blob/master/.travis.yml).

### Syntax highlighting benchmarks

There is also a small script to benchmark syntax highlighting:

	./bench-syntax file.go:666

The default is to `redraw!` 100 times; this can be changed with an optional
second argument:

	./bench-syntax file.go:666 5000

Some tips for improving performance:

- Try to reduce the `COUNT`; a lot of syntax can only appear in certain places,
  so there is no need for Vim to look on every line. For example:

      syn region goBuildTag start="//\s*+build\s"rs=s+2 end="$"

  This works perfectly well; but build tags can only appear in comments, so
  this:

      syn region goBuildTag contained [..]
	  syn region goComment start="//" end="$" contains=goBuildTag

  Will be faster, as Vim won't have to look for the pattern on most lines of the
  file, just files that are already marked as `goComment`.

- Make the regexp "fail" as soon as possible, for example these two are
  effectively identical in behaviour:

      syn match       goSingleDecl      /\(import\|var\|const\) [^(]\@=/
      syn match       goSingleDecl      /^\s*\(import\|var\|const\) [^(]\@=/

  But the second version is a lot faster due to the `^\s*`; The regular
  expression can stop matching much faster for most lines.

Credits
-------

I originally implemented this for vim-go, based on Fatih's previous work (see
[1157][1157], [1158][1158], and [1476][1476]), which was presumably inspired by
[runtest.vim](https://github.com/vim/vim/blob/master/src/testdir/runtest.vim) in
the Vim source code repository.

[cov]: https://github.com/Vimjas/covimerage
[1157]: https://github.com/fatih/vim-go/pull/1157
[1158]: https://github.com/fatih/vim-go/pull/1158
[1476]: https://github.com/fatih/vim-go/pull/1476
