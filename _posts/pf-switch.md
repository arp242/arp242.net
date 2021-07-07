---
title: Running multiple services on one port with PF
date: 2010-05-14
archive: true
---

At my work there’s a HTTP/HTTPS proxy which requires authentication, I would
like to access both ssh and a subversion repository through HTTP at my home
server.

The easiest solution would be to use two IP addresses, but I don’t have an extra
IP address available. Ports other than 443 are blocked, and using port 80 won’t
work because the HTTP proxy doesn’t support the HTTP WebDAV extensions required
for subversion (and it’s also insecure).

The solution
------------

Use pf’s `overload` feature to switch between services on a given port.

Using it is simple: I can use svn whenever I want, if I would like to use ssh I
open my browser, go to `http://94.142.244.51` three times in 42 seconds and I
can use ssh. After closing ssh and waiting for a minute I can use svn again.

This solution will work for FreeBSD and OpenBSD. The concept can be implemented
in most – if not all – other stateful firewalls too.

/etc/pf.conf
------------

Simplified ruleset for demonstration purposes

    # Interface to filter
    if="re0"

    # My server's IP
    ip="94.142.244.51"

    # IP from my work
    work={"X.X.X.X"}

    # Table to keep track of who should be redirected from port 443 to port 22
    table <rdr_ssh> persist

    # Redirect everyone in the rdr_ssh table from port 443 to port 22
    rdr on $if inet proto tcp from <rdr_ssh> to $ip port https -> $ip port ssh

    # Default rules
    block in log
    pass out quick

    # Allow traffic on port 443
    pass in on $if proto tcp from any to $ip port https

    # Allow traffic on port 80 for svn/ssh switching, allow it only from my work.
    # Most (all?) browsers will try to load /favicon.ico so opening a page once
    # are actually two TCP connections.
    pass in log quick proto tcp from $work to $ip port http keep state
    (max-src-conn-rate 6/42, overload <rdr_ssh>)

dummyserver.py
---------------

From [pf.conf(5)][pf.conf]:

    For stateful TCP connections, limits on established connections (connec-
    tions which have completed the TCP 3-way handshake) can also be enforced
    per source IP.

    max-src-conn <number>
    Limits the maximum number of simultaneous TCP connections which
    have completed the 3-way handshake that a single host can make.

    max-src-conn-rate <number> / <seconds>
    Limit the rate of new connections over a time interval. The con-
    nection rate is an approximation calculated as a moving average.

It took me some time to realize that if no service is running on port 80 the
connection attempt will time out and the 3-way handshake is not completed.

You can use Python to start a simple web server that does nothing.

    #!/usr/bin/env python

    from BaseHTTPServer import *

    host = '94.142.244.51'
    port = 80

    HTTPServer((host, port), BaseHTTPRequestHandler).serve_forever()

Or you can use your web server with a document root of `/var/empty/` if you prefer.

/etc/crontab
------------

It’s also useful to add a crontab entry to flush the table periodically to
switch back to svn when you’re done with ssh.

To your `/etc/crontab` add:

    * * * * * root /sbin/pfctl -t rdr_ssh -T expire 60 > /dev/null 2>&1

From [pfctl(8)][pfctl]:

    -T expire number
                Delete addresses which had their statistics cleared
                more than number seconds ago. For entries which
                have never had their statistics cleared, number
                refers to the time they were added to the table.

In other words: As long as a connection is open, the address won’t be
removed, but if no connection has been open for 60 seconds the address is
removed.

Or, if you prefer, you can manually clear the table with:

    pfctl -t rdr_ssh -T del <ipaddress>

Further reading
---------------

- [pfctl(8)][pfctl]
- [pf.conf(5)][pfctl]
- [PF user’s guide from the OpenBSD site](http://openbsd.org/faq/pf/index.html)
- [FreeBSD handbook: 30.4 The OpenBSD Packet Filter (PF) and ALTQ]( http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/firewalls-pf.html)

[pf.conf]: http://www.openbsd.org/cgi-bin/man.cgi?apropos=0&sektion=5&manpath=OpenBSD+Current&arch=i386&format=html&query=pf.conf
[pfctl]: http://www.openbsd.org/cgi-bin/man.cgi?apropos=0&sektion=8&manpath=OpenBSD+Current&arch=i386&format=html&query=pfctl
