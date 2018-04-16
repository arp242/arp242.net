---
layout: code
title: "scomplete.vim"
link: "scomplete.vim"
last_version: "master"
---

My simple completion plugin.

- `:LastComplete` command to show last completed command.
-  Map Control+space to use context-completion unless this is already mapped.
   - Use `scomplete#map(key)` to define your own mapping: `scomplete#map('<Tab>')`.
