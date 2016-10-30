---
layout: code
title: "globedit.vim"
link: "globedit.vim"
last_version: "master"
pre1: "Project status: experimental"

---

globedit.vim adds variants of `:edit` and friends that can take a globbing
pattern to open multiple files:

    :Edit plugin/*.vim doc/*.doc
    :Split ??_*.c

See |wildcards| for a overview of the globbing patterns interpreted by Vim.

Compare this to the default behaviour of `:edit *.vim`, which will either:

- open a file named `*.vim` if there are no matches;
- open the file if there is exactly one match;
- error out with `E77: Too many file names ` if there are more than one
  matches.

