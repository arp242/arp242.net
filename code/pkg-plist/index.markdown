---
layout: code
title: "pkg-plist"
link: "pkg-plist"
last_version: "version_1.4"
---

[![This project is archived](https://img.shields.io/badge/Status-archived-red.svg)](https://arp242.net/status/archived)

Make a pkg-plist for a FreeBSD port. Try to be as ‘automatic’ as possible. 

That’s all it does ;-) 

You can find it in the FreeBSD ports collection at `ports-mgmt/pkg-plist`.

Basic usage
===========
1. Build your port to the staging directory: `make stage`.
2. Run this from your port’s directory (or set `-p`).

Alternatively, you can install your ports to a ‘fake’ prefix, this is the “old”
from before staging support, but it has the added advantage that you’ve tested
whether your port works when installing to a different prefix.

1. Build & install your port with a different `PREFIX`: `make install
   PREFIX=/var/tmp/ptest`.
2. Run this from your port’s directory with `-x` set to `PREFIX`.


ChangeLog
=========

Version 1.4, 2014-12-02
-----------------------
- Use `@dir`, instead of `@dirrm`; patch by lightside@gmx.com
- Support `STAGEDIR`; patch by lightside@gmx.com


Version 1.3, 2013-03-13
-----------------------
- Use `LOCALBASE`, not `/usr/local`


Version 1.2, 2012-11-07
-----------------------
- Python 3 compatibility


Version 1.1, 2011-11-14
-----------------------
- Update to reflect changes in the ports tree. 


Version 1.0, 2006
---------------------
- Initial release
