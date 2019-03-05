---
layout: post
title: You (probably) don’t need Kubernetes
updated: 5 Mar 2019
---

<div class="hatnote">Translations:
<a href="https://linux.cn/article-10469-1.html">Chinese (汉语)</a>.
</div>

You know those old “Hello world according to programmer skill” jokes that start
with `printf("hello, world\n")` for a junior programmer and end with some
convoluted Java OOP design pattern solution for senior software architect
engineer? This is kind of like that.

<dl>
<dt>Junior sysops</dt>
<dd><code>./binary</code></dd>

<dt>Experienced sysops</dt>
<dd><code>./binary</code> on EC2.</dd>

<dt>devops</dt>
<dd>Self-deployed CI pipeline to run <code>./binary</code> on EC2.</dd>

<dt>Senior cloud orchestration engineer</dt>
<dd>k8s orchestrated self-deployed CI pipeline to run <code>./binary</code> on E2C platform.</dd>
</dl>

¯\\\_(ツ)\_/¯

That doesn’t mean that Kubernetes or any of these things are bad *per se*, just
as Java or OOP aren't bad per se, but rather that they’re horribly misapplied in
many cases, just as using several Java OOP design patterns are horribly
misapplied to a hello world program. For most companies the sysops requirements
are fundamentally not very complex, and applying k8s to them makes little sense.

True story: I once saw an expensive luxury sports car (Ferrari? Maserati?
Lamborghini? I don't recall) get stuck. In which difficult circumstances? The
local supermarket's parking lot. The parking space was lower than the road. They
had managed to drive in but were now struggling to get out without damage, as
the car's clearance height was so low.
It's undoubtedly a great well-designed car; but that doesn't mean it's the best
car to go grocery shopping with.

---

Complexity creates work by its very nature, and I’m skeptical that using k8s is
a time-saver for most users. It’s like spending a day on a script to automate
some 10-minute task that you do once a month. That’s not a good time investment
(especially since the chances are you’ll have to invest further time in the
future by expanding or debugging that script at some point).

Your deployments probably *should* be automated – lest you [end up like
Knightmare](https://dougseven.com/2014/04/17/knightmare-a-devops-cautionary-tale/)
– but k8s can often be replaced by a simple shell script.

In our own company the sysops team spent a lot of time setting up k8s. They also
had to spend a lot of time on updating to a newer version a while ago (1.6 ➙
1.8). And the result is something no one really understands without really
diving in to k8s, and even then it's hard (those YAML files, yikes!)

Before I could debug and fix deploy issues myself. Now that’s a lot harder. I
understand the basic concepts, but that’s not all that useful when actually
debugging practical issues. I don’t deal with k8s often enough to justify
learning this.

---

That k8s is really hard is not a novel insight, which is why there are a host of
"k8s made easy" solutions out there. The idea of adding another layer on top of
k8s to “make it easier” strikes me as, ehh, unwise. It’s not like that
complexity disappears; you’ve just hidden it.

I have said this many times before: when determining if something is “easy” then
my prime concern is not how easy something is to write, but how easy something
is to debug when things fail. Wrapping k8s will not make things easier to debug,
quite the opposite: it will make it *even harder*.

---

There is a famous Blaise Pascal quote:

> All human evil comes from a single cause, man’s inability to sit still in a
> room.

k8s – and to lesser extent, Docker – seem to be an example of that. A lot of
people seem lost in the excitement of the moment and are "k8s al the things!",
just as some people were lost in the excitement when Java OOP was new, so
everything has to be converted from the "old" way to the "new" ones, even though
the "old" ways still worked fine.

Sometimes the IT industry is pretty silly.

Or to summarize this post [with a Tweet](https://twitter.com/sahrizv/status/1018184792611827712):

> 2014 - We must adopt #microservices to solve all problems with monoliths<br>
> 2016 - We must adopt #docker to solve all problems with microservices<br>
> 2018 - We must adopt #kubernetes to solve all problems with docker<br>
