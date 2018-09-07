---
layout: code
title: "orgstat"
link: "orgstat"
last_version: "master"
---

List git author statistics for an entire GitHub organisation.

	$ go get arp242.net/orgstat
	$ orgstat -org Foo -user Me -token $GITHUB_TOKEN -out stats.html

TODO:

- Deal with forks smarter; somehow (want to include historic people who are no
  longer a member in the stats, but not people who committed upstream)
