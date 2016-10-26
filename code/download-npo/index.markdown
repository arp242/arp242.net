---
layout: code
title: "download-npo"
link: "download-npo"
last_version: "version-2.4"
pre1: "Project status: stable"

---


**Download-npo downloads videos from the Dutch npo.nl site. The rest of the
documentation is in Dutch.**

Download-npo (voorheen `download-gemist`) download videos van de [NPO][1] site
van de publieke omroep. In principe zouden alle sites die gebruik maken van de
zogeheten “NPOPlayer” zouden moeten werken, zoals bv. ncrv.nl of nrc.nl (al
zijn deze niet allemaal getest).

Voor vragen of opmerkingen kun je mailen naar [martin@arp242.net][3].


Installatie
===========
Voor **Windows** is er een [installer][d-win] (versie 2.1); dit is alles wat je
nodig hebt. Het kan zijn dat je een foutmelding krijgt mbt. `MSVCR100.dll`; je
zal dan de ‘Microsoft Visual C++ 2010 Redistributable Package’ moeten downloaden
van [http://www.microsoft.com/en-us/download/details.aspx?id=14632](http://www.microsoft.com/en-us/download/details.aspx?id=14632).

Voor **BSD**, **Linux**, **OSX**, en andere **UNIX-y** systemen is `pip` het
makkelijkste:

    pip install download-npo

[Python][2] is nodig (Python 2.6+ & 3.3+ zijn getest), voor de grafische
interface is ook `Tkinter` nodig (deel van Python maar soms een aparte package).

Voor **Ubuntu** zijn er ook packages beschikbaar in [Maarten Fonville's
PPA][ppa]:

	$ sudo add-apt-repository ppa:maarten-fonville/download-npo
	$ sudo apt-get update
	$ sudo apt-get install download-npo

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
is? Stuur dan even een mail naar [martin@arp242.net][3] met de URL die je
gebruikt en de (volledige) output van je commando (het liefst met de `-VVV`
opties), dan zal ik er even naar kijken.


Kan ik ook een video streamen zonder het eerst op te slaan?
-----------------------------------------------------------
Uiteraard! Bijvoorbeeld met:

	$ download-npo -f - VPWON_1227038 | mplayer -cache 4096 -cache-min 99 -

Het `play-npo` script doet dit.


Ondertitels worden opgeslagen als .srt, maar zijn eigenlijk in het WebVTT formaat?
----------------------------------------------------------------------------------
Dat klopt; WebVTT wordt vooralsnog door maar weinig spelers herkend, en het is
feitelijk hetzelfde als Subrip (`.srt`) ondertitels (de verschillen zijn miniem).


Ik vind dit geen fijn programma, weet je misschien iets anders?
---------------------------------------------------------------
Dat is jammer :-( Feedback is trouwens altijd welkom. Stuur een mailtje naar
[martin@arp242.net][3] en laat me weten wat er beter kan!

Maar, deze alternatieven zijn bekend bij mij:

- [downloadgemist.nl][dg.nl]; voordeel is dat het online is (je hoeft niks te
  installeren; maar heeft minder opties, en is minder handig als je meer dan een
  paar afleveringen wilt downloaden.

- [Chrome-Uitzending-Gemist-Downloader](https://github.com/luukd/Chrome-Uitzending-Gemist-Downloader);
  Chrome plugin. Verder niet getest.

- [GemistDownloader](http://www.helpdeskweb.nl/gemistdownloader/); naar mijn
  inzien wat onhandig programma, en het is *niet* open source. Wellicht dat het
  voor jou beter werkt.

Staat jouw programma er niet bij? Mail me dan even en ik zet het erbij.


Kan ik ook in 1 keer alle uitzendingen downloaden van een bepaald programma?
----------------------------------------------------------------------------
Niet direct. Eerst kon dat wel, maar dat ging te vaak kapot omdat de site
veranderd werd.

Voor Windows is er de [Npo-Pvr][npo-pvr] PowerShell wrapper door Jan Hoek.
Door periodiek dit scriptje te starten worden steeds de nieuwste afleveringen
gedownload.

Er is ook een plugin voor [Flexget](http://flexget.com/); daarmee kan je
nieuwe afleveringen van geabonneerde programma’s automatisch downloaden.
De Flexget plugin zit
[in Flexget zelf](https://github.com/Flexget/Flexget/blob/develop/flexget/plugins/input/npo_watchlist.py)
en is gemaakt door (Jeroen L.)[https://github.com/jeroenl].



ChangeLog
=========

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



[1]: http://www.npo.nl/
[2]: http://python.org/
[3]: mailto:martin@arp242.net
[d-win]: http://tmp.arp242.net/download-npo-setup-2.1.exe
[d-unix]: https://bitbucket.org/Carpetsmoker/download-npo/get/version-2.4.tar.gz
[libmms]: http://sourceforge.net/projects/libmms/
[dg.nl]: http://downloadgemist.nl
[npo-pvr]: https://github.com/jhoek/Npo-Pvr
[ppa]: https://code.launchpad.net/~maarten-fonville/+archive/ubuntu/download-npo
