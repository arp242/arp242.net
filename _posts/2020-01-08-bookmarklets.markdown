---
layout: post
title: "Bookmarklets to deal with annoying designs"
tags: ['Web']
---

I have two [bookmarklets][bookmarklet] which I use frequently: `r` ("readable")
to improve the readability of text, and `f` ("fixed") one to remove fixed
navigation and banners. I put them in my toolbar as `r` and `f` so it doesn't
take up too much space.

Extensions are more popular these days but I rather like this lightweight
approach. It gives me easy control over when *exactly* it's executed, and it's
less intrusive than a full-on reader mode or whatnot. It's simple, fast, and
reliably works about 90% of the time :-)

Usage: in Firefox right-click the links and click "add bookmark", or
drag-and-drop to bookmarks toolbar. In Chrome it seems the only way is to
drag-and-drop to bookmarks toolbar. I'm not sure about other browsers, [but I'm
fairly sure the internet does][ddg].

<a href="javascript:(function() {
    document.querySelectorAll('p, li, div').forEach(function(n) {
        n.style.color = '#000';
        n.style.font = '500 16px/1.7em sans-serif';
    });
})();">readable</a> &nbsp; &nbsp; <a href="javascript:(function() {
    document.querySelectorAll('*').forEach(function(n) {
        var p = getComputedStyle(n).getPropertyValue('position');
        if (p === 'fixed' || p === 'sticky') {
            n.style.cssText += ' ; position: absolute !important;';
        }
    });
})();">fixed</a>

[bookmarklet]: https://en.wikipedia.org/wiki/Bookmarklet
[ddg]: https://duckduckgo.com/?q=how+to+add+a+bookmarklet&t=ffab&ia=web

readable
--------
Convert most text to something more readable:

    javascript:(function() {
        document.querySelectorAll('p, li, div').forEach(function(n) {
            n.style.color = '#000';
            n.style.font = '500 16px/1.7em sans-serif';
        });
    })();

Fortunately the "low contrast thin text"-fad seems slowly be going out of
fashion, but it still crops up often enough. Everyone who cared about good
design said it was completely stupid from the first minute it was used, but the
frontend crowd never listens and has to find out these things for themselves the
hard way 🤷‍♂️

[fc]: https://www.reddit.com/r/linuxquestions/comments/a4h90n/using_fontconfig_to_block_a_problematic_font/

Note: on my Linux system I noticed that very thin text almost always resolves to
"DejaVu Sans ExtraLight" (select "Fonts" in Firefox CSS inspector to see the
font Firefox selects). I tried mucking about with fonts.conf so it's never used,
but after some time I reaffirmed my opinion that fontconfig is a horrible
inscrutable mess and decided that life is too short to deal with this bullshit,
so I just did:

    $ rm /usr/share/fonts/TTF/DejaVuSans-ExtraLight.ttf

The font doesn't get many updates, so it should be mostly fine. I'm [not the
first to struggle with this][fc]. Contact me if you know how to make it work.


fixed
-----

Convert `fixed` and `sticky` positioning to `absolute`:

    javascript:(function() {
        document.querySelectorAll('*').forEach(function(n) {
            var p = getComputedStyle(n).getPropertyValue('position');
            if (p === 'fixed' || p === 'sticky') {
                n.style.cssText += ' ; position: absolute !important;';
            }
        });
    })();

The `!import` is needed because I found it's not uncommon for sites to override
`position: absolute` with `position: fixed !important` when someone scrolls
down.

This tends to break layouts a bit. I usually don't care as I just want to read
the main body text.

This is mostly to remove huge fixed navigation, which seem to be the latest fad.
It's not uncommon to see them take up 25% of the screen or more, which is just
annoying. Not everyone uses a 26″ screen…

I actually have two laptops: a 12″ 1920×1080 ThinkPad x270, and a 14″ 1366×768
HP 14s[^1], and it's broken on both: on the ThinkPad I often zoom which tend to
hugely inflate the size of these headers, and on the HP the screen just isn't
very high-res, which means that your 150px header is actually quite a
significant part of my available space.

[^1]: I got this laptop last month after my ThinkPad broke and I *really* needed
      a replacement to do some work. It was the cheapest laptop with an eMMC (so
      I could just swap the disk from the ThinkPad). My ThinkPad is actually
      still in warranty and should probably do something with that, but the HP
      actually works quite well for me.

Example I ran in to today is the [AWS blog][aws]; the header takes up about 30%
of screen space at a zoom level of 133%.

[aws]: https://aws.amazon.com/blogs/aws/urgent-important-rotate-your-amazon-rds-aurora-and-documentdb-certificates/
