---
layout: code
title: "testing.vim"
link: "testing.vim"
last_version: "master"
redirect: "https://github.com/Carpetsmoker/testing.vim"
---

testing.vim is a testing tool for Vim loosely inspired by Go's `testing`
package. It includes support for testing syntax highlighting, benchmarking code
and syntax highlighting, linting,  and coverage reports (via [covimerage][cov]).

Example
-------

Annotated example test function
([original](https://github.com/Carpetsmoker/gopher.vim/blob/acb9e38/autoload/gopher/internal_test.vim#L25-L39)):

```vim
fun! Test_cursor_offset() abort
	" Create a new bufer, and add three lines to it. Make sure the cursor is on
	" the third line.
	new
	call append(0, ['€', 'aaa', 'bbb'])
	call cursor(3, 0)

	" Call the function we want to test and ensure we have the correct output.
	let l:out = gopher#internal#cursor_offset()
	call assert_equal(8, l:out)

	" Again with a different parameter.
	let l:out = gopher#internal#cursor_offset(1)
	call assert_equal(':#8', l:out)

	" Write the buffer; it's chdir()'ed to a tmp dir, so it's fine to just write
	" stuff.
	silent w off

	" Ensure filename is added.
	let l:out = gopher#internal#cursor_offset(1)
	call assert_equal(g:test_tmpdir . '/off:#8', l:out)
endfun
```

Usage
-----

testing.vim is not a Vim plugin. Clone/download it and run the `tvim` script to
launch it. You can put this directory in your `PATH`, or use `make` to install
it:

	$ make install                     # To /usr/local
	$ PREFIX=~/.local make install     # Non-root install.

The test of the documentation will assume `tvim` is in `PATH`.

Run `tvim test path/to/file_test.vim` to run tests in that file, `tvim test
path/to/dir` to run all test files in a directory, or `tvim test
path/to/dir/...` to run al test files in a directory and all subdirectories.

Tests are stored as `*_test.vim` files, all functions matching the `Test_\k+()
abort` signature will be run.
It is customary – but not mandatory – to store `n_test.vim` files next to the
`n.vim` file in the same directory.

testing.vim exposes several variables:

	g:test_verbose    -v flag from commandline (0 or 1).
	g:test_debug      -d flag from commandline (0 or 1).
	g:test_run        -r flag from commandline, as a string.
	g:test_bench      -b flag from commandline, as a string.
	g:test_dir        Directory of the test file that's being run.
	g:test_tmpdir     Empty temp directory for writing; this is also set as the
	                  working directory before running tests.
	g:test_packdir    Directory of the plugin in the temporary directory (this
	                  is a link to the REAL plugin, so don't modify files!)
	g:bench_n         Number of times to run target code during benchmark.

And a few functions:

	Error(msg)        Add a message to v:errors.
	Errorf(msg, ...)  Like Error(), but with printf() support.
	Log(msg)          Add a "log message" in v:errors; this won't fail the test.
	                  Useful since :echom and v:errors output isn't interleaved.
	Logf(msg, ...)    Like Log, with with printf() support.
	TestSyntax()      Test syntax highlighting. Usually you want to generate
	                  this with test-syntax.

A test is considered to be "failed" when `v:errors` has any items that are not
marked as informational (as done by `Log()`). Vim's `assert_*` functions write
to `v:errors`, and it can be written to as any list. You don't need to use
`Error()`.

You can filter test functions to run with the `-r` option. See `tvim help test`
for various other options.

testing.vim will run the binary form the `TEST_VIM` environment variable,
defaulting to `vim`. Managing different Vim installations is out-of-scope for
this project.

See [gopher.vim for an example Travis integration](https://github.com/Carpetsmoker/gopher.vim/blob/master/.travis.yml).

Syntax highlighting tests
-------------------------

You can generate tests for syntax highlighting with `tvim gen-syn`. How it
works:

1. Write a test file for the syntax to test; for example `basic.go` with the
   contents:

       package main

       import "fmt"

       func main() {
       	var msg = "Let's go!"
       	fmt.Println(msg)
       }

2. Verify that the highlighting is correct in this file.

3. Run `tvim gen-syn syntax/test/basic.go > syntax/test/go_test.vim`; this will
   generate a test script recording the current syntax highlighting.

4. Test the file as any other `_test.vim` script.

Linting
-------

Linting works like testing: `tvim lint ./...`.

Currently supported lint tools:

- [vint](https://github.com/Kuniwak/vint)

Benchmarks
----------

Benchmarks are also loaded from `*_test.vim` files. Benchmark functions match
the pattern `Benchmark_\k+() abort`.

Use `tvim test -b` to select which benchmarks to run. Use `-b .` to run them
all.

A benchmark is expected to run the benchmarked code `g:bench_n` number of times.

Example:

```vim
fun! Benchmark_trim() abort
  let l:s = '  hello  '
  for i in range(0, g:bench_n)
    call gopher#internal#trim(l:s)
  endfor
endfun
```

### Syntax highlighting benchmarks

You can benchmark syntax highlighting with `tvim bench-syntax file.go:666`.

The default is to `redraw!` 100 times; this can be changed with an optional
second argument: `tvim bench-syntax file.go:666 5000`.

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

Rationale
---------

My philosophy of testing is that it should be kept as simple as feasible;
programming is already hard enough without struggling with a poorly documented
unintuitive testing framework. This is what makes testing.vim different from
some other Vim testing tools.

My requirements:

1. Easy to run test, including just a single test function.
2. Easy to see what failed *exactly*.
3. Easy to debug failing tests, e.g. with printf-debugging.
4. Reasonably intuitive for anyone familiar with VimScript.

None of the existing tools met these. Some of them didn't even meet any of them!

Credits
-------

I originally implemented this for vim-go, based on Fatih Arslan's previous work
(see [1157][1157], [1158][1158], and [1476][1476]), which was presumably
inspired by
[runtest.vim](https://github.com/vim/vim/blob/master/src/testdir/runtest.vim)
in the Vim source code repository.

[cov]: https://github.com/Vimjas/covimerage
[1157]: https://github.com/fatih/vim-go/pull/1157
[1158]: https://github.com/fatih/vim-go/pull/1158
[1476]: https://github.com/fatih/vim-go/pull/1476
