---
layout: code
title: "markdown-wiki"
link: "markdown-wiki"
last_version: "tip"
pre1: "Experimental"

---

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


Changelog
---------
1.0 version is to-be-released.


TODO
----

### For 1.0:
- Log/history/recent changes page could be a lot better...
- File uploads.
- Translations with gettext
- Write Special:Help
- Start page
- Index now shows everything ... Maybe make this configurable/smarter
  (perhaps collapse)?
- Search in filenames & content; we can maybe use hg/git so we have a okay(-ish)
  performance (?) But this won't search non-commited changes?
- And finally ... list it here: `http://www.wikimatrix.org/wiki/become_a_maintainer`

### Later:
- More fine-grained access control; maybe some sort of glob pattern (or list of
  them) for each user.
- Tags; we can do this by creating a dir for each tag, and then symlinking pages
  we want in this tag.

### (Probably) much later (or perhaps never...)
- Make it possible to use mdwiki as a public website; either by 1) generating
  HTML, 2) Provide a "read-only mode" & a "edit mode" (or something...)
- Proper cache headers; also make sure we're cache friendly for Varnish and
  such... ESI?
  https://www.varnish-cache.org/trac/wiki/VCLExampleCacheCookies
  https://www.varnish-cache.org/trac/wiki/VCLExampleCachingLoggedInUsers
- Kramdown can save as PDF, perhaps we want to support this?
- Maybe allow execution of code in pages? Would be cool to write code docs.
- Rails integration? lib/sidekiq/web.rb does something like that; this way we
  can document a rails project, and view it with mdwiki


[kramdown]: http://kramdown.gettalong.org/
[sinatra]: http://www.sinatrarb.com/
[bundler]: http://bundler.io/
