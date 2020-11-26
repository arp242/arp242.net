---
title: Digging for hosts on FreeBSD 10
archive: true
---

FreeBSD 10 now has [unbound](http://unbound.net/) for DNS lookups, which is a
lot better than bind (the zone server,
[nsd](http://www.nlnetlabs.nl/projects/nsd/), is *not* in FreeBSD base), but I
was confused when my favourite DNS tools `dig(1)` was MIA.

So, what can we use now?

host(1)
-------

[`host(1)`][host] is part of bind, but for FreeBSD 10 a compatible replacement
has been imported from [ldns-host][ldnshost].

    $ host arp242.net
    arp242.net has address 66.111.4.53
    arp242.net mail is handled by 20 in2-smtp.messagingengine.com.
    arp242.net mail is handled by 10 in1-smtp.messagingengine.com.

It has a nice short output, which is cool. For a reverse lookup, use the IP
address:

    $ host 66.111.4.53
    53.4.111.66.in-addr.arpa domain name pointer web.messagingengine.com.

Using `dig arp242.net NS`

    $ host -tNS arp242.net
    arp242.net name server ns0.transip.net.
    arp242.net name server ns2.transip.eu.
    arp242.net name server ns1.transip.nl.

`dig arp242.net ANY` can be done with `host -a`

    $ host -a arp242.net

    Trying "arp242.net"
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 24937
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 3

    ;; QUESTION SECTION:
    ;arp242.net.                    IN      ANY

    ;; ANSWER SECTION:
    arp242.net.             56930   IN      NS      ns0.transip.net.
    arp242.net.             56930   IN      NS      ns2.transip.eu.
    arp242.net.             56930   IN      NS      ns1.transip.nl.

    ;; ADDITIONAL SECTION:
    ns2.transip.eu.         85989   IN      A       217.115.203.194
    ns1.transip.nl.         7146    IN      A       80.69.69.69
    ns0.transip.net.        86172   IN      A       80.69.67.67

    Received 158 bytes from 192.168.178.1#53 in 0 ms

drill(1)
--------

[`drill(1)`][drill] Comes with unbound, and behaves a bit more like `dig`

    $ drill arp242.net
    ;; ->>HEADER<<- opcode: QUERY, rcode: NOERROR, id: 33602
    ;; flags: qr rd ra ; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
    ;; QUESTION SECTION:
    ;; arp242.net.  IN      A

    ;; ANSWER SECTION:
    arp242.net.     86326   IN      A       66.111.4.53

    ;; AUTHORITY SECTION:

    ;; ADDITIONAL SECTION:

    ;; Query time: 0 msec
    ;; SERVER: 192.168.178.1
    ;; WHEN: Tue Mar  4 21:27:18 2014
    ;; MSG SIZE  rcvd: 44

Reverse lookup with `-x`:

    $ drill -x 66.111.4.53
    ;; ->>HEADER<<- opcode: QUERY, rcode: NOERROR, id: 19910
    ;; flags: qr rd ra ; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
    ;; QUESTION SECTION:
    ;; 53.4.111.66.in-addr.arpa.    IN      PTR

    ;; ANSWER SECTION:
    53.4.111.66.in-addr.arpa.       526     IN      PTR     web.messagingengine.com.

    ;; AUTHORITY SECTION:

    ;; ADDITIONAL SECTION:

    ;; Query time: 0 msec
    ;; SERVER: 192.168.178.1
    ;; WHEN: Tue Mar  4 21:28:04 2014
    ;; MSG SIZE  rcvd: 79

And classes work like `dig` as well

    $ drill arp242.net ANY
    ;; ->>HEADER<<- opcode: QUERY, rcode: NOERROR, id: 62701
    ;; flags: qr tc rd ra ; QUERY: 1, ANSWER: 5, AUTHORITY: 0, ADDITIONAL: 0
    ;; QUESTION SECTION:
    ;; arp242.net.  IN      ANY

    ;; ANSWER SECTION:
    arp242.net.     86177   IN      A       66.111.4.53
    arp242.net.     86177   IN      RRSIG   A 7 2 86400 20140807142905
    20140205142905 3707 arp242.net.
    JWyPfrgV+sauV03/8eKSAzzM+GIRLLcqzye1BKFYsYwoAOxS+yBQNOzoSSJiuWMGj+zhvu1hyK0E3yFgSyWbzITTdigkWBwnkrVLOEnZ/CRVwj68/9MhLC/l2w7YyOyAkty2EVOWZljduVo1NIajB593JIWpDVbh0rKwn1X7IOY=
    arp242.net.     86177   IN      MX      20 in2-smtp.messagingengine.com.
    arp242.net.     86177   IN      MX      10 in1-smtp.messagingengine.com.
    arp242.net.     86177   IN      RRSIG   MX 7 2 86400 20140807142905
    20140205142905 3707 arp242.net.
    MvvwO7HNnvJXOazXTbGtk28ofhPttYdiF5enHcAREs7ZevQP2k8hVF6xXZSPLScDCPP1R4CPaZrq7XtUPkWDqPSjD3zcBaIE8VyKZIPmAotR7ZpGIlmVDEdqcHlvbFZF9HWZM4wwSe8hO97sy3KRaqR3GxE167n6D0njw8B5PSY=

    ;; AUTHORITY SECTION:

    ;; ADDITIONAL SECTION:

    ;; Query time: 1154 msec
    ;; SERVER: 192.168.178.1
    ;; WHEN: Tue Mar  4 21:29:47 2014
    ;; MSG SIZE  rcvd: 453

    ;; WARNING: The answer packet was truncated; you might want to
    ;; query again with TCP (-t argument), or EDNS0 (-b for buffer size)

`+short` doesn’t work, though:

    $ drill arp242.net +short
    ;; ->>HEADER<<- opcode: QUERY, rcode: NXDOMAIN, id: 609
    ;; flags: qr rd ra ; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 0
    ;; QUESTION SECTION:
    ;; +short.      IN      A

    ;; ANSWER SECTION:

    ;; AUTHORITY SECTION:
    .       815     IN      SOA     a.root-servers.net. nstld.verisign-grs.com.
    2014030401 1800 900 604800 86400

    ;; ADDITIONAL SECTION:

    ;; Query time: 0 msec
    ;; SERVER: 192.168.178.1
    ;; WHEN: Tue Mar  4 21:29:52 2014
    ;; MSG SIZE  rcvd: 99

But I really want dig, man!
---------------------------

Then you shall have it: [dns/bind-tools](http://www.freshports.org/dns/bind-tools).

[ldnshost]: http://tx97.net/ldns-host/
[host]: http://www.freebsd.org/cgi/man.cgi?query=host&apropos=0&sektion=0&manpath=FreeBSD+10.0-RELEASE&arch=default&format=html
[drill]: http://www.freebsd.org/cgi/man.cgi?query=drill&apropos=0&sektion=0&manpath=FreeBSD+10.0-RELEASE&arch=default&format=html
