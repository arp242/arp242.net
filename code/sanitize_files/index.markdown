---
layout: code
title: "sanitize_files"
link: "sanitize_files"
last_version: "master"
---

Project status: stable

-----------------------------------------

We’ve all been here, you just inherited a project and it’s a mess.

This will do some basic cleanup:

- Set all indentation to either tabs or spaces.
- Convert `\r\n` to `\n`.
- Add a `\n` to the end of files.
- Trim whitespace at the end of lines.
- Remove consecutive newlines.

This should cut down on most useless changes in your VCS log.

`sanitize_files` is language-agnostic, and should work for most (all?) common
programming languages. It will not fix language-specific code styles (location
of braces, identifier naming, etc.).

ChangeLog
=========

Version 1.1, 20160424
---------------------
- Removing consecutive newlines didn't work as intended.
- Better ignoring of VCS directories.
- Add encoding:utf-8 for Python 2.
- Also works if path is a file (rather than a directory).
- path is now mandatory and no longer defaults to cwd; it's confusing and may
  clobber stuff unintentionally.

Version 1.0, 20141104
---------------------
- Initial release

