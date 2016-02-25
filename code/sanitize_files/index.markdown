---
layout: code
title: sanitize_files
link: sanitize_files
---

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
