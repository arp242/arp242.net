---
title: "Browsers and conflicts of interests"
layout: post
updated: 9 Apr 2018
---

What do you get when you search for ‘Firefox’ in a new Windows 10 installation?

A big fat ad for Microsoft Edge:

<div class="border-img center-img"><img alt="Firefox in Bing" src="{% base64 ./_images/browser/ms-edge1.png %}"></div>

This is a *full-screen* screenshot on a 1920×1080 screen (right-click and select
‘view image’ for the full size). Firefox is juts *barely* visible at the bottom.

It doesn’t end there, Microsoft also “helpfully” displays a warning that this
file “could harm your computer”:

<div class="border-img center-img"><img alt="Downloading Firefox" src="{% base64 ./_images/browser/ms-edge2.png %}"></div>

[According to
Microsoft](https://support.microsoft.com/en-gb/help/2566263/a-warning-message-unexpectedly-appears-when-you-try-to-download-a-file),
“The SmartScreen Application Reputation service checks the reputation of a
file”, and should display this only for files with no significant reputation.
Somehow I find it hard to believe that the Firefox installer fits this bill…

Wait, there’s more! When changing the default browser from Edge to Firefox we
get yet another ad, baked right in to the settings screen:

<div class="border-img center-img"><img alt="Changing default browser" src="{% base64 ./_images/browser/ms-edge3.png %}"></div>

Other people – who have used Windows 10 for more than the ten minutes I used it
– have been treated to more anti-Firefox ads:

<div class="border-img center-img"><a href="https://superuser.com/q/1146123/71885"><img alt="Chrome is draining your battery faster" src="{% base64 ./_images/browser/ms-edge5.png %}"></a></div>
<div class="border-img center-img"><a href="https://www.reddit.com/r/firefox/comments/5our4n/windows_10_now_has_builtin_adds_targeting_firefox/"><img alt="Microsoft Edge is safer than Firefox" src="{% base64 ./_images/browser/ms-edge6.png %}"></a></div>

Oh, and Microsoft also
[banned browsers from its Windows Store](https://www.bleepingcomputer.com/news/microsoft/microsoft-has-effectively-banned-third-party-browsers-from-the-windows-store/).

---

It doesn’t end with Microsoft. For years Google displayed a Chrome
advertisements on Google search (although it looks like they have stopped doing
it now). And what about enabling the ‘Do Not Track’ header in Chrome?

<div class="border-img center-img"><img alt="Enabling Do Not Track" src="{% base64 ./_images/browser/chrome1.png %}"></div>

I’m sure that the fact that Google has a significant interest in tracking the
hell out of everyone on the internet is purely coincidental, as is Google
[banning extensions that disrupt its business model][1].

Chrome’s [new ad blocker][2] (or ‘ad filter’ as they call it) is also rather
suspect. We now have Google – whose primary revenue comes in through ads –
determining what ads you get to see. How often do you think it will filter
Google ads?

[1]: https://www.bleepingcomputer.com/news/google/google-bans-adnauseam-from-chrome-the-ad-blocker-that-clicks-on-all-ads/
[2]: https://theintercept.com/2017/06/05/be-careful-celebrating-googles-new-ad-blocker-heres-whats-really-going-on/
[3]: https://bugzilla.mozilla.org/show_bug.cgi?id=975444

---

These concerns are hardly new; the Microsoft browser bundling was a subject of
much complaining and litigation in the past leading to the (in)famous
[BrowserChoice.eu](https://en.wikipedia.org/wiki/BrowserChoice.eu). Whether that
was a good decision is up for grabs, but baking full-page ads and warnings in
your products strikes me as ethically dubious at best.

I haven’t used Windows – or any Microsoft product – in years, but it looks like
it’s still the same old crap. Just booting Windows also blew away my `grub`
bootloader by the way. My ten-minute stint with Microsoft Windows is over.

All of this makes paying the Microsoft tax on my ThinkPad even more sour…

---

Microsoft was (is) perceived as a monopoly; I suspect that a strong reason that
Google isn’t by many people because you don’t directly pay for their products.
Search, Gmail, Chrome: it's all free of charge. Some of it (like Chromium and
Android) is even (partly) Open Source (or ‘[Free
Software](https://www.fsf.org/about/what-is-free-software)’, if you prefer).
This is kind of neat, but seems to do little to protect most people’s actual
freedoms, and in the end it’s not about the money you pay but about your
freedom.
