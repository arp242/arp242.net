---
title: "Browsers and conflicts of interests"
layout: post
updated: 2018-12-22
---

<div class="hatnote">Discussions:
<a href="https://www.reddit.com/r/firefox/comments/8avev2/browsers_and_conflicts_of_interests/">/r/firefox</a>.
Feedback:
<a href="https://github.com/Carpetsmoker/arp242.net/issues/2">#2</a>.
</div>

What do you get when you search for ‘Firefox’ in a new Windows 10 installation?

A big fat ad for Microsoft Edge:

<figure class="border"><img alt="Firefox in Bing" src="{% base64 ./_images/browser/ms-edge1.png %}"></figure>

This is a *full-screen* screenshot on a 1920×1080 screen (right-click and select
‘view image’ for the full size). Firefox is juts *barely* visible at the bottom.

It doesn’t end there, Microsoft also “helpfully” displays a warning that this
file “could harm your computer”:

<figure><img alt="Downloading Firefox" src="{% base64 ./_images/browser/ms-edge2.png %}"></figure>

[According to
Microsoft](https://support.microsoft.com/en-gb/help/2566263/a-warning-message-unexpectedly-appears-when-you-try-to-download-a-file),
“The SmartScreen Application Reputation service checks the reputation of a
file”, and should display this only for files with no significant reputation.
Somehow I find it hard to believe that the Firefox installer fits this bill…

Wait, there’s more! When changing the default browser from Edge to Firefox we
get yet another ad, baked right in to the settings screen:

<figure class="border"><img alt="Changing default browser" src="{% base64 ./_images/browser/ms-edge3.png %}"></figure>

Other people – who have used Windows 10 for more than the ten minutes I used it
– have been treated to more anti-Firefox ads:

<figure class="border"><a href="https://superuser.com/q/1146123/71885"><img alt="Chrome is draining your battery faster" src="{% base64 ./_images/browser/ms-edge5.png %}"></a></figure>
<figure class="border"><a href="https://www.reddit.com/r/firefox/comments/5our4n/windows_10_now_has_builtin_adds_targeting_firefox/"><img alt="Microsoft Edge is safer than Firefox" src="{% base64 ./_images/browser/ms-edge6.png %}"></a></figure>

Oh, and Microsoft also
[banned browsers from its Windows Store](https://www.bleepingcomputer.com/news/microsoft/microsoft-has-effectively-banned-third-party-browsers-from-the-windows-store/).

---

It doesn’t end with Microsoft. For years [Google displayed a Chrome
advertisements on Google
search](https://productforums.google.com/forum/#!topic/chrome/u_8RWVl1TzE)
(although it looks like they have stopped doing it now). And what about enabling
the ‘Do Not Track’ header in Chrome?

<figure class="border"><img alt="Enabling Do Not Track" src="{% base64 ./_images/browser/chrome1.png %}"></figure>

I’m sure that the fact that Google has a significant interest in tracking the
hell out of everyone on the internet is purely coincidental, as is Google
[banning extensions that disrupt its business model][1].

Chrome’s [new ad blocker][2] (or ‘ad filter’ as they call it) is also rather
suspect. We now have Google – whose primary revenue comes in through ads –
determining what ads you get to see. How often do you think it will filter
Google ads?

[Clearing all cookies in Chrome didn't clear Google
cookies](https://twitter.com/ctavan/status/1044282084020441088); they added an
option for it in a later version, but by default "clear all cookies" will still
retain Google-related cookies. It also won't clear local storage, meaning that
"clear browsing data" is rather ineffectual to prevent tracking.

[1]: https://www.bleepingcomputer.com/news/google/google-bans-adnauseam-from-chrome-the-ad-blocker-that-clicks-on-all-ads/
[2]: https://theintercept.com/2017/06/05/be-careful-celebrating-googles-new-ad-blocker-heres-whats-really-going-on/
[3]: https://bugzilla.mozilla.org/show_bug.cgi?id=975444

Recently someone [claimed that YouTube deliberately slowed the performance of
Edge][4]. I don't think this claim is true – there are valid reasons for
overlaying an empty div – but that doesn't matter. What matters is that
Google/YouTube definitely *could* do so if they want, which is a marked
difference from just a few years ago.

I don't think we want to have a company to have that amount of power. They're
mostly behaving well right now ([mostly...][5]) but are you sure they will still
in five years? Ten years? Thirty years? Past experiences with companies such as
Big Blue, AT&T, Microsoft, etc. seem to have been forgotten.

[4]: https://news.ycombinator.com/item?id=18697824
[5]: https://arstechnica.com/gadgets/2018/12/the-web-now-belongs-to-google-and-that-should-worry-us-all/

---

These concerns are hardly new; Microsoft bundling their Internet Explorer
browser (as well as some other products, such as Media Player) with their
Windows operating system was a subject of much complaining and litigation in the
past, eventually leading to the (in)famous
[BrowserChoice.eu](https://en.wikipedia.org/wiki/BrowserChoice.eu). Whether the
BrowserChoice.eu screen was a good solution is up for grabs; many people found
it annoying. But it seems to me that a *single* screen offering you a *useful*
choice is a lot better than the *several* annoying fake warnings that Windows 10
shows.

I haven’t used Windows – or any Microsoft product – in years, but it looks like
it’s still the [same old
crap](https://www.cnet.com/news/facts-behind-microsofts-anti-linux-campaign/).
All of this makes paying the Microsoft tax on my ThinkPad even more sour :-(

---

One reason Microsoft can now get away with their Internet Explorer shenanigans
is because a lot changed in the last ten years, and Microsoft is no longer as
dominant as it once was: Internet Explorer market share is small, and macOS –
and to a lesser extent Linux – offers competition to Windows.

For some reason people’s perception of Google seems more cavalier; part of the
reason for that is because it doesn’t have the dominance Microsoft once had
(Chrome ‘only’ has about 60% market share at the time of writing), but I suspect
that another important reason is that you don’t directly pay for most Google
products. Search, Gmail, Chrome: it's all free of charge. Some of it (like
Chromium and Android) is even (partly) Open Source (or ‘[Free
Software](https://www.fsf.org/about/what-is-free-software)’, if you prefer).
This is kind of neat, but seems to do little to protect most people’s actual
freedoms, and in the end it’s important to remember that it’s not about the
money you pay, but about your freedom.
