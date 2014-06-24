---
layout: post
title: Opera 11 onload bug
---

Recent Opera versions don't execute onload when Microsoft .eot webfonts are used.


**Update 20110629**  
Opera released version 11.50, which fixes the issue. As mentioned in the
[changelog](http://www.opera.com/docs/changelogs/windows/1150/):  
*Custom web fonts prohibiting onload event firing*

-------------------------------------------------------------------------

Today I got bitten by a rather nasty bug that took me some time to figure out.

I noticed that in Opera 11.10 the function in my `<body onload="">` wasn’t
getting executed.

The problem occurs when using Microsoft `.eot` format webfonts. You can
specify the webfont in `@font-face` without problems, but as soon as you
actually use the font for anything things start to break.

I tested Opera 10.63 and it works fine, Opera 11.10 and 11.11 are broken. I
didn’t test Opera 11.00.

Workaround
----------
This webfont declaration only targets Internet Explorer, so we can use IE’s
conditional comments as a workaround.

	<!--[if IE]>
		<style type="text/css">
			@font-face {
				font-family: FuturaStdBook;
				src: url("fonts/futurastd-book-webfont.eot");
			}
		</style>
	<![endif]-->
