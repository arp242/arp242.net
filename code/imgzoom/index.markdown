---
layout: code
title: "imgzoom"
link: "imgzoom"
last_version: "version-1.0"
redirect: "https://github.com/Carpetsmoker/imgzoom"
---

[![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)

imgzoom is a simple image zoomer. It will animate images to the maximum
allowable size by the viewport, but will never make them larger than the
image's actual size.

[Demo](https://carpetsmoker.github.io/imgzoom/example.html).

This is a simple alternative to "lightbox" and such. This script has no
external dependencies and should work well with pretty much any browser
(including IE11, but not older versions).

Basic usage:

	<img src="http://example.com/image.jpg" style="width: 300px">

or:

	<img src="http://example.com/thumbnail.jpg" data-large="http://example.com/fullsize.jpg">

Then bind to the click event with e.g.

	window.addEventListener('load', function() {
		var img = document.querySelectorAll('img');
		for (var i=0; i<img.length; i++) {
			img[i].addEventListener('click', function(e) { imgzoom(this); }, false);
		}
	}, false);

With jQuery it's even easier:

	$(document).ready(function() {
		$('img').on('click', function(e) { imgzoom(this); });
	})

For best results you probably want to add a wee bit of styling:

		img.imgzoom-loading {
			cursor: wait !important;
		}

		.imgzoom-large {
			cursor: pointer;
			box-shadow: 0 0 8px rgba(0, 0, 0, .3);

			/* Simple animation */
			transition: all .4s;
		}


This is a simplified version of
[bluerail/picture_zoomer](https://github.com/bluerail/picture_zoomer), which I
wrote a few years ago.
