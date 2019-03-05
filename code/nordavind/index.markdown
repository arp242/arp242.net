---
layout: code
title: "nordavind"
link: "nordavind"
last_version: "master"
redirect: "https://github.com/Carpetsmoker/nordavind"
---

[![This project is archived](https://img.shields.io/badge/Status-archived-red.svg)](https://arp242.net/status/archived)

Nordavind is a web based audio player.

Current status: It's usable  but not as polished as I'd like it to be.


Browser support
===============
**Nordavind works best in Firefox**; WebKit browsers (eg. Chrome) are known to
be broken, as WebKit doesn't bufffer & seek properly (this seems to be a
problem/bug on their side, near as I can figure out).  
Other browsers may work, but aren't tested. Feel free to report problems if you
encounter them.

Browsers that will *never* work are Internet Explorer 8 and Safari 5.


Audio codecs
------------
Nordavind will transparently convert FLAC, MP3, and OGG files for you so that
your browser can play them, but you should be aware that converting from MP3 to
Ogg Vorbis (or vice versa) *will* reduce audio quality even at fairly high
bitrates because you’re converting from one lossy format to another. So you
may want to choose your browser depending on the format of you music collection.

Note that converting FLAC to either format is fine.


Installation
============

Dependencies
------------
- A UNIX/Linux machine (Windows will not work)
- [Python 3](http://python.org/) (Python 2 will not work)
- [CherryPy](http://www.cherrypy.org/)
- [Jinja2](http://jinja.pocoo.org/docs/)
- [mutagen](https://pypi.python.org/pypi/mutagen)
- [Unidecode](https://pypi.python.org/pypi/Unidecode)
- py-sqlite3 (Included in Python, sometimes a separate package)


### Optional
- [Pillow](https://github.com/python-imaging/Pillow) or any other PIL-compatible
  library (there are several), this is used to scale large covers to a
  reasonable size, if not installed, large covers simply won't be displayed
- If you want to convert from FLAC to Ogg Vorbis: [`flac`][flac] and [`oggenc`][vorbis]
- If you want to convert from FLAC to MP3: [`flac`][flac] and [`lame`][lame]
- If you want to convert from MP3 to Ogg Vorbis: [`mpg123`][mpg123] and [`oggenc`][vorbis]
- If you want to convert from Ogg Vorbis to MP3: [`oggdec`][vorbis] and [`lame`][lame]

[flac]: http://xiph.org/flac/
[vorbis]: http://www.vorbis.com/
[mpg123]: http://mpg123.org/
[lame]: http://lame.sourceforge.net/


Configuration
-------------
You almost certainly want to edit `config.cfg` and edit at least the `password`
and `musicpath` options.


Running
-------
Run `serve.py` to start the server. You can optionally add an `address:port`
to listen on (defaults to `0.0.0.0:8001`).


Adding your music collection
============================
You can use `update.py` to update your music collection; by default, this does a
full update (add new files, update existing files, remove deleted files,
calculate replaygain if missing).

See `update.py -h` for some options.


Using Nordavind
===============
A pane (library, playlist, player, info) needs to have focus for it to receive
keybinds.


Global
------
- The tab key cycles focus between playlist, library, filter, and the player
  buttons


Library
-------
- Doubleclicking an artist will open/close it

- Doubleclicking an album will append it to the playlist

- Middleclicking either an artist or album will append it to the playlist (note
  that there's no reliable way to prevent the default action on middle click, so
  this may do unexpected things)

- Typing any text while the library is focused will highlight whatever you’re
  typing (similar to many native desktop applications)


Playlist
--------
- You can select multiple rows with the shift & ctrl modifier keys

- Arrow keys, page{up,down}, home, and end all work as expected.

- ctrl+a selects everything


Info
----
- Click on the album to get a larger view


Player
------
Nothing yet...

Credits
=======
Copyright © 2013-2015 Martin Tournoij <martin@arp242.net>  
MIT license applies

Nordavind includes (in whole, or code based on):

- [Bootstrap](http://getbootstrap.com/)
- [Font awesome](http://fortawesome.github.io/Font-Awesome/)
- [Javascript MD5](http://pajhome.org.uk/crypt/md5/md5.html)
- [Perfect Scrollbar](http://github.com/noraesae/perfect-scrollbar)
- [jQuery.mousewheel](https://github.com/brandonaaron/jquery-mousewheel)
- [jQuery](http://jquery.com/)
