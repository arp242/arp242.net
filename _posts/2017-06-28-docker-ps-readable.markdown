---
layout: post
title: "Make docker ps work on normal sized terminals"
archive: true
---

I’m sorry folks, but I cannot call this anything other than silly interface design:

	[~]% docker ps
	CONTAINER ID        IMAGE                                 COMMAND                  CREATED             STATUS                            PORTS                                                                                                NAMES
	8467772b79aa        haproxy:1.7                           "/docker-entrypoin..."   5 minutes ago       Up 5 minutes                      127.0.0.235:80->80/tcp, 127.0.0.235:443->443/tcp, 127.0.0.235:8877->8877/tcp                         haproxy
	726bc8270037        teamwork/launchpad:dev-env            "/bin/sh -c ./laun..."   5 minutes ago       Up 5 minutes                      9001/tcp                                                                                             launchpad
	980c57aab6fa        elasticsearch:2.3                     "/docker-entrypoin..."   7 minutes ago       Up 7 minutes (healthy)            9200/tcp, 9300/tcp                                                                                   elasticsearch
	8527ee711c3e        teamwork/deskcustomerportal:dev-env   "/bin/sh -c 'watch..."   About an hour ago   Up 24 minutes                     127.0.0.235:5150->5150/tcp                                                                           deskcustomerportal
	d5d55fe9806c        teamwork/minio                        "minio server /export"   2 days ago          Up 7 minutes                      127.0.0.235:9000->9000/tcp                                                                           minio
	de48a0dbe4d2        rabbitmq:3-management                 "docker-entrypoint..."   5 days ago          Up 7 minutes (healthy)            4369/tcp, 5671/tcp, 127.0.0.235:5672->5672/tcp, 15671/tcp, 25672/tcp, 127.0.0.235:15672->15672/tcp   rabbitmq
	72563020b8ef        teamwork/desk:dev-env                 "/bin/sh -c ./desk"      7 days ago          Restarting (127) 52 seconds ago                                                                                                        desk
	35209ff049e6        redis:alpine                          "docker-entrypoint..."   7 days ago          Up 7 minutes (healthy)            6379/tcp                                                                                             redis
	89bba4de1280        teamwork/db:dev-env                   "docker-entrypoint..."   7 days ago          Up 24 minutes (healthy)           127.0.0.235:3306->3306/tcp                                                                           db

260 characters wide for a common command... It looks terrible on any vaguely
normal sized terminal:

<figure><img alt="Docker xterm" src="{% base64 ./_images/docker-wide.png %}"></figure>

It’s exactly 56 characters too much for even a full-screen xterm(!) Guess I’ll
have to buy a new 32 inch 4k HD screen to run Docker?

I’m [not the first person who notices this ~~idiotic design~~
issue](https://github.com/moby/moby/issues/7477), and a [`--format` switch was
added](https://github.com/moby/moby/pull/14699) after enough people complained.

Compare:

{% raw %}
	[~]% docker ps --format "table {{.ID}}  {{.Names}}\t{{.Image}}\t{{.Status}}"
	CONTAINER ID  NAMES                IMAGE                                 STATUS
	8467772b79aa  haproxy              haproxy:1.7                           Up 17 minutes
	726bc8270037  launchpad            teamwork/launchpad:dev-env            Up 17 minutes
	980c57aab6fa  elasticsearch        elasticsearch:2.3                     Up 19 minutes (healthy)
	8527ee711c3e  deskcustomerportal   teamwork/deskcustomerportal:dev-env   Up 36 minutes
	d5d55fe9806c  minio                teamwork/minio                        Up 19 minutes
	de48a0dbe4d2  rabbitmq             rabbitmq:3-management                 Up 19 minutes (healthy)
	72563020b8ef  desk                 teamwork/desk:dev-env                 Restarting (127) 19 seconds ago
	35209ff049e6  redis                redis:alpine                          Up 19 minutes (healthy)
	89bba4de1280  db                   teamwork/db:dev-env                   Up 36 minutes (healthy)
{% endraw %}

Still a bit larger than the standard 80 columns, but only by a bit (108 in this
specific example), which is a hell of a lot better than 260.

You can add this to `~/.config/docker.json` – [ugh][json] – to have it apply
automatically:

{% raw %}
	{
		"psFormat": "table {{.ID}}  {{.Names}}\t{{.Image}}\t{{.Status}}",
		[...]
	}
{% endraw %}

This is not only easier than a shell alias, but will also make it work for
`docker container ls`.

You can check `man docker-container-ls` for the documentation on `--format`.

The lesson here is to use safe and sane defaults people ... not everyone uses
porn-sized terminal windows. Some of us have normal-sized windows!

[json]: /json-config.html
