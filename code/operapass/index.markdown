---
layout: code
title: operapass
link: operapass
---

Opera is a great browser, but one feature it’s been lacking for a very long
time is the ability to view the passwords you’ve saved with the Opera password
manager (“The wand”).

There are a few closed-source and Windows-only programs out there. An
open-source multi-platform utility to read the wand seemed like a good idea :-) 

operapass can be run from in a terminal or with a basic GUI. It should find the
wand.dat in your Opera profile directory, but you can also specify it as the
first parameter (eg.. `operapass-tk path/to/wand.dat`)

There are two utilities: `operapass-dump` to dump the password file to your
stdout (ie. terminal) and `operapass-tk` for a very basic TKinter GUI. 

It should run on Windows, Linux, FreeBSD, and OSX.

Notes
=====
operapass can currently **only read wand files without a master password**. Note
you can remove and (re-)add a master password at any time in the Opera
preferences. 

operapass will use the [M2Crypto][1] module when available, and fall back to pyDes
(bundled) when it’s not, note that M2Crypto is *much* faster. M2Crypto isn’t
available for Python 3 yet.

Credits
=======
Copyright © 2011-2014, Martin Tournoij <[martin@arp242.net][2]>
MIT licence applies: http://opensource.org/licenses/MIT  

The Opera wand format is described here:  
http://securityxploded.com/operapasswordsecrets.php  
This information was an extremely useful starting point. 

operpass also includes pyDes from http://twhiteman.netfirms.com/des.html 

ChangeLog
=========
Version 1.3, 2014-11-01
-----------------------
- Detect if a master password is set

Version 1.2, 2013-03-13
---------------------
- Python 3 didn’t always work, fix that
- Windows binaries
- A few minor bugfixes/cleanup

Version 1.1, 2012-11-01
---------------------
- Work with both Python 2 & 3

Version 1.0, 2011-10-04
---------------------
- Initial release


[1]: https://pypi.python.org/pypi/M2Crypto
[2]: mailto: martin@arp242.net
