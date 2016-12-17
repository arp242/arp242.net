---
layout: code
title: "transip-dynamic"
link: "transip-dynamic"
last_version: "master"
pre1: "Project status: experimental"

---

Dynamic DNS for TransIP.

For a very long time I was a happy [XS4ALL](https://www.xs4all.nl/) customer
with a static IP address, custom reverse DNS, and all sorts of fancy shit.

Then I moved to a country which doesn't seem to have decent ISPs, and now my IP
address changes every week.

I'd like to keep my home address accessible from the public internet. You need
know when you might want to `ssh` home. So I wrote a script to automatically
update the records.

How to use it
=============
- Set an initial value for the records manually in the TransIP control panel.

- Make sure you've got the API enabled in the TransIP control panel. Generate a
  private key you'll use for authentication.

- Get this program; you'll need [Go](https://golang.org/):

		go get arp242.net/transip-dynamic

- Open up `config` in any 'ol text editor. Set the appropriate values.

- Build and run the program: `go build transip-dynamic.go; ./main`

- You probably want to run this automatically every hour orso with cron.

Alternatives
============
* [transip-dyndns](https://github.com/RolfKoenders/transip-dyndns) (deals poorly
  with A and AAAA record; can only set one domain, node.js).
