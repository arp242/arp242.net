---
layout: code
title: "testing.vim"
link: "testing.vim"
last_version: "master"
---

testing.vim is a small testing framework for Vim.

I originally implemented this for vim-go, based on Fatih's previous work (see
[1157][1157], [1158][1158], and [1476][1476]), and eventually extracted it out
to this. It's loosely inspired by Go's `testing` package.

My philosophy of testing is that it should be kept as simple as feasible;
programming is already hard enough without struggling with a poorly documented
unintuitive testing framework.

testing.vim includes support for code coverage reports (via [covimerage][cov]).

Usage
-----

Tests are stored in a `*_test.vim` files, which are customarily stored next to
the original file; all functions starting with `Test_` will be run.

Run `./test /path/to/file_vim.go` to run test in that file, `./test
/path/to/dir` to run all test files in a directory, or `./test/path/to/dir/...`
to run al test files in a directory and all subdirectories.

You can filter test functions with the `-r` option. See `./test -h` for various
other options.

testing.vim will always use the `vim` from `PATH` to run tests; prepend a
different PATH to run a different `vim`.

[cov]: https://github.com/Vimjas/covimerage
[1476]: https://github.com/fatih/vim-go/pull/1476
[1157]: https://github.com/fatih/vim-go/pull/1157
[1158]: https://github.com/fatih/vim-go/pull/1158
