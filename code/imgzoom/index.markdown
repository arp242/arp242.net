---
layout: code
title: "imgzoom"
link: "imgzoom"
last_version: "master"
redirect: "https://github.com/Carpetsmoker/imgzoom"
---

imgzoom is a simple image zoomer. It will animate images to the maximum
allowable size by the viewport, but will never make them larger than the
image's actual size.

This is a simple alternative to "lightbox" and such. This script has no
external dependencies

Basic usage is as simple as:

	<img src="http://example.com/image.jpg" style="width: 300px">

or:

	<img src="http://example.com/thumbnail.jpg" data-large="http://example.com/fullsize.jpg">

Then bind to the click event with e.g.

	Array.prototype.slice.call(document.querySelectorAll('img')).forEach(function(img) {
		img.addEventListener('click', function(e) {
			imgzoom(this)
		})
	})

With jQuery it's even easier:

	$('img').on('click', function(e) {
		imgzoom(this)
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
