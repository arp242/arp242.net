---
layout: code
title: "transip-dynamic"
link: "transip-dynamic"
last_version: "master"
redirect: "https://github.com/Carpetsmoker/transip-dynamic"
---

[![This project is considered experimental](https://img.shields.io/badge/Status-experimental-red.svg)](https://arp242.net/status/experimental)

Dynamic DNS for TransIP.

For a very long time I was a happy [XS4ALL](https://www.xs4all.nl/) customer
with a static IP address, custom reverse DNS, and all sorts of fancy shit.

Then I moved to a country which doesn't seem to have decent ISPs, and now my IP
address changes every week.

I'd like to keep my home address accessible from the public internet. You never
know when you might want to phone home. So I wrote a script to automatically
update the records.

How to use it
=============
- Set an initial value for the records manually in the TransIP control panel.

- Make sure you've got the API enabled in the TransIP control panel. Generate a
  private key you'll use for authentication.

- Get this program; you'll need [Go](https://golang.org/):

		go get arp242.net/transip-dynamic

- Open up `config` in any 'ol text editor. Set the appropriate values.

- Build and run the program: `go run transip-dynamic.go`

- You probably want to run this automatically every hour orso with cron.

Alternatives
============
* [transip-dyndns](https://github.com/RolfKoenders/transip-dyndns) (deals poorly
  with A and AAAA records; can only set one domain; node.js so difficult to
  run).
