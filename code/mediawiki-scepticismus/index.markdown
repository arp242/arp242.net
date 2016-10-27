---
layout: code
title: "MediaWiki-Scepticismus"
link: "MediaWiki-Scepticismus"
last_version: "master"
pre1: "Project status: archived (I no longer work on this, as I don't have a MediaWiki install to administer any more. It's still usable, though, and I'll still fix bugs when reported; contact me if you want to take over maintainership)."

---


MediaWiki skin designed to be comfortably readable. Designed for
[skepticpages.org](https://skepticpages.org).

Tested with Firefox 44, Chromium 49, Midori 0.5.11, Internet Explorer 11, and
Safari 9. Should work in most reasonable new (last ~2 years) browsers.

Requires:

- PHP 5.4+
- FontAwesome to be loaded (with, for example, [Extension:FontAwesome2][1]).

It's mostly complete, but there are probably a few rough edges that need
polishing out. It also hard-codes some values (logo, favicon) which should
probably be fixed before a "real" release.

Take a look at `styles/variables.css` for some customisation.

It also adds some user-configurable options in the "appearance" tab of
Special:Settings.

[1]: https://www.mediawiki.org/wiki/Extension:FontAwesome2
