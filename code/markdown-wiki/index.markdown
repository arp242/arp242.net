---
layout: code
title: "markdown-wiki"
link: "markdown-wiki"
last_version: "master"
redirect: "https://github.com/Carpetsmoker/markdown-wiki"
---

[![This project is archived](https://img.shields.io/badge/Status-archived-red.svg)](https://arp242.net/status/archived)

**markdown-wiki** or **mdwiki** is a basic wiki.

Features:

- Documents are written in markdown.
- All documents are stored on the file system, you can edit them through the
  web interface, or directly on the file system with your editor of choice.
- Versions are tracked with a VCS; currently Mercurial and Git are supported.
- It has a simple interface, no excessively ‘hip’ JS. It’s perfectly usable in
  `lynx`.
- Lighter than DokuWiki!


Installation
------------
- Install dependencies with  [bundler][bundler]: `bundle install`.

- You can optionally configure some settings in `config.rb`.

- You will need to initialize a `user` file and a VCS repository in `data/`;
  running `./install.rb` is the easiest way to initialize a repo; you can add
  users with `./adduser.rb`.

- Start it with: `./mdwiki.rb`, or with a port number: `./mdwiki.rb -p 4568`.


Markdown flavour
----------------
[See the Kramdown docs](http://kramdown.gettalong.org/syntax.html). You can
configure this in `config.rb` with `MARKDOWN_FLAVOUR`.

Paths ending with `@` will get redirected to `.markdown`; e.g.
`[link](/other_page@)` is the same as `[link](/other_page.markdown)` this saves
some typing for wiki links.  
This is not a markdown extension, but just a HTTP redirect.


Editing documents on the file system
-----------------------------------
- Spaces are stored as an underscore (`_`).
- Files must end with `.markdown` or `.md` to be editable; all other files are
  treated as a data file.
- You can use any pathname, but paths *cannot* begin with `special:` (case
  insensitive) or end with a `@`.


Known issues
------------
- The ‘preview’ functionality is imperfect, since Kramdown & the PageDown
  markdown flavours differ. In fact, it’s so imperfect that I disabled it for
  now...


[kramdown]: http://kramdown.gettalong.org/
[sinatra]: http://www.sinatrarb.com/
[bundler]: http://bundler.io/
