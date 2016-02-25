---
layout: code
title: MediaWiki-ExternalArticlesNg
link: mediawiki-externalarticlesng
---

A MediaWiki extension to automatically fetch article text from external wikis.

Improved version of [ExternalArticles][1]; you can now load content from more
than one site and add a notice that content was imported.

Example usage:

	wfLoadExtension('ExternalArticlesNg');
	$wgExternalArticles = [
		[
			'url' => 'http://en.wikipedia.org/w/index.php?title=',
			'rule' => '/^(Template|Module):.*$/',
			'text' => '<strong>Note</strong>: the text was automatically preloaded from the <a href="%s">Wikipedia template of the same name</a>.',
		],
		[
			'url' => 'http://example.com/w/index.php?title=',
			'rule' => '/.*/',
			'text' => '<strong>Note</strong>: the text was automatically preloaded from <a href="%s">example page of the same name</a>.' . 
				'Please make sure the spelling is correct as ExampleWiki often has terrible spelling!',
		],
	];

[1]: http://www.mediawiki.org/wiki/Extension:ExternalArticles
