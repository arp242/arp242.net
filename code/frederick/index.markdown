---
layout: code
title: "frederick"
link: "frederick"
last_version: "version-2.0"

---

Project status: stable

-----------------------------------------

Frederick is a web-based feed reader (RSS, Atom). It’s simple, and should “just
work”.

Installation & running
======================

Dependencies
------------
- [Python 3](http://python.org/) (Python 2 will not work)
- [Jinja2](http://jinja.pocoo.org/docs/)
- [CherryPy](http://www.cherrypy.org/)
- py-sqlite3 (Included in Python, sometimes a separate package)

Usually running:

	$ pip3 install cherrypy jinja2

Should install what you need.

Running
-------
To start the server, run `serve.py`, this will start a HTTP server at port 8000.
You can optionally add a server & port to listen on as `address:port`

Frederick should work on any size device, but will probably have problems in
older browsers (such as IE8 and earlier).

Updating feeds
--------------
Feeds automatically are updated on a pageview if the last update was more than
30 minutes ago.

You can also run `update.py` to update Frederick, you probably want to run this
from cron to prevent ‘gaps’ in your item list.

ChangeLog
=========

Version 2.0, 20160423
---------------------
- This improves everything. A lot. It's now in a state where I can actually
  recommend it, instead of something I quickly hacked together for personal use
  and released because a friend wanted to use it.

Version 1.1, 20130725
--------------------
- Many minor changes

Version 1.0, 20130721
---------------------
- Initial release


Credits
=======
Copyright © 2013-2016 Martin Tournoij <martin@arp242.net>  
MIT license applies

Frederick includes (in whole, or code based on):

- [Bootstrap](http://getbootstrap.com/)
- [FeedParser](https://code.google.com/p/feedparser/)
- [Font awesome](http://fortawesome.github.io/Font-Awesome/)
- [jQuery](http://jquery.com/)
