---
layout: code
title: "globedit.vim"
link: "globedit.vim"
last_version: "version-1.0"

---

[![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)

Add variants of `:edit` and friends that can take a globbing pattern to open
multiple files:

    :Edit plugin/*.vim doc/*.doc
    :Split ??_*.c

See `:help wildcards` for a overview of the globbing patterns interpreted by Vim.

Compare this to the default behaviour of `:edit *.vim`, which will either:

- open a file named `*.vim` if there are no matches;
- open the file if there is exactly one match;
- error out with `E77: Too many file names ` if there are more than one
  matches.

Based on my answer here, which also lists some other solutions:
http://vi.stackexchange.com/q/2108/51

See `:help globedit` for the full documentation.
