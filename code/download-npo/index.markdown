---
layout: code
title: "download-npo"
link: "download-npo"
last_version: "version-2.6"

---

[![This project is considered stable](https://img.shields.io/badge/Status-stable-green.svg)](https://arp242.net/status/stable)
[![Build Status](https://travis-ci.org/Carpetsmoker/download-npo.svg?branch=master)](https://travis-ci.org/Carpetsmoker/download-npo)
[![PyPI](https://img.shields.io/pypi/v/download-npo.svg)](https://pypi.python.org/pypi/download-npo)

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

De automatische installer is al een tijd niet meer bijgewerkt. Voel je vrij om
[je te melden](https://github.com/Carpetsmoker/download-npo/issues/1) mocht je
interesse hebben om hier aan te werken.

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
Versie 2.6, 2017-03-02
----------------------
- Fix voor huidige versie van de site.
- Bugfix voor Python2 icm. `-f` flag en unicode.

Versie 2.5.2, 2017-02-01
------------------------
- Python 2.6 is **niet** meer ondersteund. Je hebt nu minimaal Python 2.7+ or
  3.3+ nodig.
- Fix `UnicodeEncodeError` met Python 2.
- Fix instructies voor Windows.
- Versie 2.5 en 2.5.1 overgeslagen door gedoe met PyPI.

Versie 2.4.2, 2017-01-31
------------------------
- Fix ook downloaden van ondertiteling voor de huidige versie van de site.

Versie 2.4.1, 2017-01-27
------------------------
- Fix voor de huidige versie van de site.

Versie 2.4, 2016-10-03
----------------------
- Fix voor radio-uitzendingen.
- De waarschuwing als metadata niet weggescheven kan worden omdat `mutagen`
  ontbreekt wordt nu alleen getoond als `-V` gebruikt wordt.
- Bugfix: utf-8 karakters in `-o` en `-f` voor Python 2 & niet-UTF-8 omgevingen.
- Versie 2.3 overgeslagen door gedoe met PyPI.

Versie 2.2, 2016-02-29
----------------------
- Schrijf metadata naar mp4 bestand als de `mutagen` module beschikbaar is.
- Installeer `.desktop` bestand en icoon, zodat het te zien is in
  Ubuntu/Unity/etc.
- Verschillende bugfixes.

Versie 2.1, 2015-09-18
----------------------
- De GUI (`download-gemist-gui`) is nu een heel stuk beter.
- Ondersteun config file in `~/.config/download-npo.conf` (zie `--help`).
- `--help` optie voor meer help (`-h` is nog steeds vrij kort).
- De `-o` en `-f` opties (voor de filename) accepteert nu ook een aantal
  placeholders om informatie uit de metadata op te nemen. Zie `download-npo
  --help` voor meer info.
- Fix `-f -` (output naar stdout) voor Python 3.
- Voeg `play-npo` toe, wrapper om video's direct af te spelen.
- Splits URLs van stdin op elke whitespace (en niet alleen op een spatie).
- De ondertiteling werd altijd gedownload, ook als `-n` opgegeven was (dank aan
  Jan Hoek voor het melden).

Versie 2.0.1, 2015-07-04
------------------------
- Fix voor de huidige versie van de site.

Versie 2.0, 2015-01-20
----------------------
- **Hernoem tool naar `download-npo`**; iemand anders heeft een soortgelijk
  programma gemaakt en dat dezelfde naam genoemd. In overleg is besloten mijn
  programma te hernoemen om verwarring te voorkomen.
- Implementeer Omroep Brabant.
- Werk ook zonder `http://` (ie. `download-npo npo.nl/...`
- Nieuwe optie: `-k` voor het selecteren van de kwaliteit.
- Fallback nu naar lagere kwaliteit streams, als `-k` niet opgegeven is en de
  hoogste kwaliteit niet beschikbaar is.

Versie 1.7, 2014-10-25
----------------------
- uitzendinggemist.nl is nu npo.nl, hernoem hier en daar dingen.
- Fix voor Python 2.6
- Fix voor lokale omroepen (omroep Brabant ed.)
- `-V` kan nu tot 3 keer opgegeven worden
- `-t` toevoegd om ook ondertitels mee te downloaden. Met `-T` worden alleen de
  ondertitels gedownload.
- `-m` om alleen de metadata te laten zien, in YAML formaat; `-M` voor JSON
  formaat.

Versie 1.6.3, 2014-02-18
------------------------
- Fixes in release, Windows-build van 1.6.2 was fubar

Versie 1.6.2, 2014-02-10
------------------------
- Fix voor huidige versie van de site
- Ondersteun ook oudere (MMS/ASF) uitzendingen

Versie 1.6.1, 2014-01-05
------------------------
- Bugfix: Uitzendingen die niet bij een serie horen gaven een error
- Iets betere errors in de GUI
- Aantal kleine verbeteringen

Versie 1.6, 2013-12-28
----------------------
- Geef waarschuwing als je een oudere versie gebruikt
- Werkt ook op andere sites met de NPOPlayer (npo.nl, ncrv.nl, etc.)
- Betere bestandsnamen
- Voeg grafische interface toe (`download-gemist-gui`)
- Windows installer
- `download-gemist-list` verwijderd; zo heel nuttig is het niet, en kost toch
  continue tijd om te onderhouden

Versie 1.5.1, 2013-10-09
------------------------
- Fix voor huidige versie van de site

Versie 1.5, 2013-10-06
----------------------
- `download-gemist-list` werkt nu ook bij `/weekarchief/` pagina’s
- Bugfix: Output bestand werd toch gemaakt bij `-n`
- Bugfix: `-p` bij `download-gemist-list` haalde altijd 1 pagina te veel op
- Bugfix: UnicodeError met python2 & `download-gemist-list`

Versie 1.4.2, 2013-10-01
------------------------
- Fix voor huidige versie van de site

Versie 1.4.1, 2013-09-23
------------------------
- Fix voor huidige versie van de site

Versie 1.4, 2013-08-22
----------------------
- Fix voor huidige versie van de site
- **Hernoem `download-gemist-guide` naar `download-gemist-list`**
- Gebruik nu overal Nederlands ipv. Engels of een mix van beide
- `download-gemist-list` leest nu ook van stdin
- `setup.py` script

Versie 1.3, 2013-03-05
----------------------
- Fix voor huidige versie van de site
- Betere voortgang-indicator

Versie 1.2, 2012-11-11
----------------------
- Voeg `download-gemist-guide` toe
- Voeg `-c` en `-w` opties toe
- Werkt nu ook met Python 3
- Fix voor huidige versie van de site

Versie 1.1, 2012-10-11
----------------------
- Geen `:` in bestandsnamen (problemen met FAT32)
- Fix voor huidige versie van de site

Versie 1.0, 2012-10-03
----------------------
- Eerste release


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
