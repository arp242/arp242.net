---
layout: post
title: Tunnelling SSH though a firewall with ssh -L
excerpt: Here's a little tip on how to tunnel ssh through another machine with the `-L` option.
categories: programming-and-such
---

Here’s a little tip on how to tunnel ssh through another machine with
the `-L` option. While not terribly difficult, I did spend some time
figuring this out… Maybe this will save someone else some time ;-)

The network setup (simplified):

	  [ Workstation ]
	         |
	         |
	   [ Firewall ]
	         |
	         |
	  ~ The Internet ~
	         |
	         |
	[ Public webserver ]

The problem is connecting to public webserver from my workstation, first I had
to ssh or sftp to the Linux firewall, and from that machine I could connect to
the webserver.

There has to be an easier way… And a look at the SSH manpage provided the
answer: The `-L` option.

Excerpt from [ssh(1)][ssh]:

	-L [bind_address:]port:host:hostport
		Specifies that the given port on the local (client) host is to be
		forwarded to the given host and port on the remote side.  This
		works by allocating a socket to listen to port on the local side,
		optionally bound to the specified bind_address.

Example on how to create the tunnel:

	$ ssh -f -N -p 22 username@firewall -L 2844/webserver.example.com/22

To briefly explain what the other options mean:
- `-f` Runs the tunnel in the background.
- `-N` Don’t execute a login command, just setup the tunnel.
- `-p` Connect to the firewall on port 22


You can now connect with ssh, sftp, or scp through `localhost:2844`

	$ ssh -p 2844 myusername@localhost
	$ scp -P 2844 file.tar.gz myusername@localhost:file.tar.gz

Note that [ssh(1)][ssh] requires `-p` and [scp(1)][scp] `-P`.

Testing
-------
For debugging, don’t forget you can specify `-v` up to three times to get
more information about what’s going on. In addition, it’s probably
best to test with `telnet` since this excludes things like authentication
problems.

	$ telnet localhost 2844
	Trying ::1...
	Connected to localhost.
	Escape character is '^]'.
	SSH-2.0-OpenSSH_5.1p1 FreeBSD-20080901

If you don’t see the last line, something is wrong.

Bonus tip
---------
As a free complimentary bonus tip, it’s also very easy to setup a convenient shortcut in `~/.ssh/config`

	Host webserver
		Hostname localhost
		Port 2844
		User myusername


Further reading
---------------
- [ssh(1)][ssh]
- [ssh\_config(5)][ssh_config]


Responses
---------
Over at the FreeBSD Forums, [Freddie pointed out a clever way to accomplish the same thing using netcat and the ProxyCommand option][freddie]


[ssh]: http://www.openbsd.org/cgi-bin/man.cgi?apropos=0&sektion=1&manpath=OpenBSD+Current&arch=i386&format=html&query=ssh
[scp]: http://www.openbsd.org/cgi-bin/man.cgi?apropos=0&sektion=1&manpath=OpenBSD+Current&arch=i386&format=html&query=scp
[ssh_config]: http://www.openbsd.org/cgi-bin/man.cgi?apropos=0&sektion=5&manpath=OpenBSD+Current&arch=i386&format=html&query=ssh_config
[freddie]: http://forums.freebsd.org/showpost.php?p=110006&postcount=2
