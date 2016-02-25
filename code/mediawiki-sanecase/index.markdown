---
layout: code
title: MediaWiki-SaneCase
link: mediawiki-sanecase
---

The SaneCase extension automatic corrects case mistakes. For example if the page
`Test` exists, and someone goes to `TEST`, they will be automatically redirected
to `Test` with a 301.

This is really much more sane than the default case-sensitivity.

This implements the "Auto redirect option" from Case sensitivity of page names:

> Automatically redirect to a page that has same spelling but different
> capitalization (have the computer do the disambiguation pages when a spelling
> doesn't match an existing page)
>
> Negatives: Performance and possible search engine duplicate content penalties
> caused by MediaWiki's redirection mechanism.

My response to that:

- It's one very simple query, the performance hit should be almost unnoticeable
  for most sites.
- The user having to figure out the correct URL is often more of a performance
  hit, not to mention a huge usability hit. Plus these are the sort of responses
  that can be cached very well in Varnish or whatnot.
- A 301 "Moved Permanently" redirect should be fine for search engines.

Also see: https://www.mediawiki.org/wiki/Extension:SaneCase
