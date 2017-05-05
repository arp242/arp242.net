---
layout: code
title: "download-npo"
link: "download-npo"
last_version: "version-2.7.2"

---

[![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)
[![PyPI](https://img.shields.io/pypi/v/download-npo.svg)](https://pypi.python.org/pypi/download-npo)
[![Build Status](https://travis-ci.org/Carpetsmoker/download-npo.svg?branch=master)](https://travis-ci.org/Carpetsmoker/download-npo)
[![Build status](https://ci.appveyor.com/api/projects/status/72k47k6m209o2u25/branch/master?svg=true)](https://ci.appveyor.com/project/Carpetsmoker/download-npo/branch/master)
[![codecov](https://codecov.io/gh/Carpetsmoker/download-npo/branch/master/graph/badge.svg)](https://codecov.io/gh/Carpetsmoker/download-npo)


**Download-npo downloads videos from the Dutch npo.nl site. The rest of the
documentation is in Dutch.**

Download-npo (voorheen `download-gemist`) download videos van [npo.nl][npo]. In
principe zouden alle sites die gebruik maken van de zogeheten “NPOPlayer” zouden
moeten werken, zoals bv. ncrv.nl of nrc.nl (al zijn deze niet allemaal getest).

Voor vragen of opmerkingen kun je een [een issue maken][issue] of mailen naar
[martin@arp242.net][mail].


Installatie
===========
### Linux, BSD, OS X, etc.
Het makkelijkste is om `pip` te gebruiken, wat op de meeste systemen vaak al
aanwezig is:

    pip install download-npo

Als je (nog) geen `pip` hebt kan je dat meestal installeren als `python-pip`.

Voor **Ubuntu** zijn er ook packages beschikbaar in [Maarten Fonville's
PPA][ppa]:

	$ sudo add-apt-repository ppa:maarten-fonville/download-npo
	$ sudo apt-get update
	$ sudo apt-get install download-npo

### Windows

1. [Download][d-py] en installeer Python.
2. Daarna kan je de [laatste versie downloaden][releases].
3. Dubbel-klik `download-npo-gui.pyw` om de boel te starten.

---------------

Als je oudere Silverlight/Windows media player uitzendingen wilt downloaden heb
je [libmms][libmms] nodig. Dit werkt vooralsnog alleen op POSIX (i.e.
niet-Windows) systemen. Dit is verder geheel optioneel.


Gebruik
=======
download-npo is een commandline-tool, er is ook een grafische frontend
`download-npo-gui`.

Voorbeeld:  
`download-npo http://www.npo.nl/andere-tijden/23-10-2014/VPWON_1227038`

of met alleen de episode ID:  
`download-npo VPWON_1227038`

Zie `download-npo -h` voor een overzicht van alle opties.


FAQ
===

Help! Het werkt niet! PANIEK!
-----------------------------
Vaak is dit omdat er op de NPO site iets niet klopt; soms ontbreekt een
videobestand, of is het niet compleet. Meestal is dit een dag of wat later
opgelost.  
Werkt het een dag later nog niet, of denk je dat het niet de schuld van de site
is? [Maak dan een issue][issue] of stuur even een mail naar
[martin@arp242.net][mail].

Het is handig als je de URL die je gebruikt en de (volledige) output van je
commando (het liefst met de `-VV` opties) er meteen bij zet.

Kan ik ook een video streamen zonder het eerst op te slaan?
-----------------------------------------------------------
Uiteraard! Bijvoorbeeld met:

	$ download-npo -f - VPWON_1227038 | mplayer -cache 4096 -cache-min 99 -

Het `play-npo` script doet dit.

Kan ik ook in 1 keer alle uitzendingen downloaden van een bepaald programma?
----------------------------------------------------------------------------
Ja, met `download-npo-list` kan je een lijst van alle uitzendingen ophalen:

	download-npo-list http://www.npo.nl/andere-tijden/VPWON_1247337

Je kan dit pipen naar `download-npo` met bv:

	download-npo-list http://www.npo.nl/andere-tijden/VPWON_1247337 |
		cut -d ' ' -f 2 |
		download-npo

Ondertitels worden opgeslagen als .srt, maar zijn eigenlijk in het WebVTT formaat?
----------------------------------------------------------------------------------
Dat klopt; WebVTT wordt vooralsnog door maar weinig spelers herkend, en het is
feitelijk hetzelfde als Subrip (`.srt`) ondertitels (de verschillen zijn miniem).

Ik vind dit geen fijn programma, weet je misschien iets anders?
---------------------------------------------------------------
Dat is jammer :-( Feedback is trouwens altijd welkom. Stuur een mailtje naar
[martin@arp242.net][mail] en laat me weten wat er beter kan!

Maar, deze alternatieven zijn bekend bij mij:

- [downloadgemist.nl][dg.nl]; voordeel is dat het online is (je hoeft niks te
  installeren); maar heeft minder opties, en is minder handig als je meer dan
  een paar afleveringen wilt downloaden.

- [Chrome-Uitzending-Gemist-Downloader](https://github.com/luukd/Chrome-Uitzending-Gemist-Downloader);
  Chrome plugin. Verder niet getest.

- [GemistDownloader](http://www.helpdeskweb.nl/gemistdownloader/); naar mijn
  inzien wat onhandig programma, en het is *niet* open source. Wellicht dat het
  voor jou beter werkt.

Voor het ophalen van een lijst met afleveringen:

- Voor Windows is er de [Npo-Pvr][npo-pvr] PowerShell wrapper door Jan Hoek.
  Door periodiek dit scriptje te starten worden steeds de nieuwste afleveringen
  gedownload.

- Er is ook een plugin voor [Flexget](http://flexget.com/); daarmee kan je
  nieuwe afleveringen van geabonneerde programma’s automatisch downloaden. De
  Flexget plugin zit [in Flexget
  zelf](https://github.com/Flexget/Flexget/blob/develop/flexget/plugins/input/npo_watchlist.py)
  en is gemaakt door [Jeroen L.](https://github.com/jeroenl).

Staat jouw programma er niet bij? Mail me dan even en ik zet het erbij.

ChangeLog
=========
Zie [ChangeLog.markdown](https://github.com/Carpetsmoker/download-npo/blob/master/ChangeLog.markdown).

[npo]: http://www.npo.nl/
[issue]: https://github.com/Carpetsmoker/download-npo/issues/new
[mail]: mailto:martin@arp242.net
[python]: http://python.org/
[d-py]: https://www.python.org/ftp/python/3.6.0/python-3.6.0.exe
[releases]: https://github.com/Carpetsmoker/download-npo/releases
[libmms]: http://sourceforge.net/projects/libmms/
[dg.nl]: http://downloadgemist.nl
[npo-pvr]: https://github.com/jhoek/Npo-Pvr
[ppa]: https://code.launchpad.net/~maarten-fonville/+archive/ubuntu/download-npo
