---
layout: code
title: "MediaWiki-WIGO"
link: "MediaWiki-WIGO"
last_version: "master"
pre1: "Project status: archived (I no longer work on this, as I don't have a MediaWiki install to administer any more. It's still usable, though, and I'll still fix bugs when reported; contact me if you want to take over maintainership)."

---


Add and vote for news links. Used on [skepticpages.org](https://skepticpages.org).

Tags:

- `<listwigo group=".." num=".."/>` − List `num` WIGO entries for the group
  `group`.
- `<wigorefs/>` − Show all WIGO entries which link to the current page.
- `<addwigo group=".."/>` − Show a form to add a new entry to `group`.
- `<wigo id=".."/>` − Show WIGO entry for WIGO `id`.

Groups are dynamic; so just adding a new `<addwigo/>` tag is enough.

It was inspired by the [wigo3 extension](http://rationalwiki.org/wiki/User:Nx/Extensions)
at RationalWiki, but it's a complete rewrite and doesn't share any code.
