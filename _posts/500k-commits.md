---
title: "How to end up with 500,000 commits in your log"
date: 2021-06-17
tags: []
archive: true
---

I [posted this][l] yesterday:

> I once worked for a company where they managed to create about half a million
> subversion commits in just 2 or 3 years, with about 3 developers working on
> it. I’ll leave it as an exercise to guess how they managed to do that :-)

No one guessed, which is not a surprise as it's by far the weirdest usage of a
VCS that I've ever seen.

They had a server in the office which ran the SVN server and OpenVZ to give
every developer their own container running Apache and PHP, and that's what you
would use for development. How do you get your code to that container? NFS? SMB?
FTP? Nah, that's so boring! SVN is a much better tool for this!

The way this worked is that on every push the SVN server would run this PHP
script to copy the changes to the right container based on the committer, the
idea being that everyone only got their their own changes and not other
people's. You didn't work off a `martin` branch – branches are for losers – you
would always commit to the main `trunk` branch, which was the only branch people
used. The script would look at the committer and copy all the files that commit
touched to that person's container. Every once in a while you manually updated
your directory to get other people's changes. Two people working on the same
file at the same time was ... unwise.

That PHP script was indecipherable with umpteemt levels of nesting. No one dared
to touch it because it "mostly worked", some of the time anyway. If it was the
third Tuesday of the month.

Every little change you wanted to see you had to commit. Add a debug print?
Commit. Improve that print? Commit. Found the bug and fixed it? Commit. Remove
that print again? Commit. Fix up the comment? Commit. People had their editors
set up to commit and push to SVN on save. You could easily rack up hundreds of
commits on a single day.

I don't recall exactly how many people worked on this and for how long, I think
it was about 3-4 developers over a timespan of 2-3 years before I joined, maybe
even shorter. It was a pretty small company. I do distinctly remember reaching
the half a million mark.

It really was a subversion of subversion.

I worked like this for a few days before I told them to give me access to the
server so I could set up SMB because this was just unworkable for me. Aside from
mucking up your SVN log, you need to run a command every time which is just
annoying (I would stick that in a Vim autocmd now, but I didn't know about those
back then, and since the machine they gave me was Windows I didn't really know
how to do file watching either). The reason it took me that long was because
this was my first real programming job, and was a bit too insecure to ask sooner
😅 It also made me doubt myself: "Am I not understanding SVN correct? Is this
normal? Do all companies work like this?" Turns out I did understand it
correctly, that it's not, and that no one does.

I migrated the entire shebang to Vagrant and mercurial about a year later. I
didn't bother retaining the subversion history. `rm -rf .svn; hg init; hg ci -m
'import svn code'; hg push` and I called it a day.

---

There were some other weird things there as well. Almost all of the company
consisted of very junior people, often with no experience outside of that
company. I had the impression they did it because it was "cheaper". They also
used interns as "ohh, free labour!"

I guess the lesson here is: make sure you have at least one vaguely senior
developer. Aside from me there was one other guy who certainly wasn't bad, but
also lacked experience outside of that company. I wasn't really a senior
either,[^1] but was older than most and had already been programming for quite
some time (just not for a living; I did a lot of other jobs before I really made
a career out of programming).

[^1]: And arguably, I'm still not; this entire idea where everyone with a few
      years of experience is seen as a "senior" is pretty silly IMHO. It reminds
      me of a certain industry where everyone under 30 is a "teen" and everyone
      over 30 a "MILF".

Another lesson is to invest at least a little bit of time in the tooling you
use. I actually really hate learning about "plumbing" like VCS systems because
I'd rather be doing more useful stuff, but even just a little bit of effort goes
a long way and can save you a lot of time. Branches? They had just never heard
of them. Their entire setup would still be weird with branches, but it would be
*less* weird.

And if stuff is awkward then ... maybe you're doing it wrong? No one liked how
any of this worked, but just accepted it as a fact of life, like how you would
accept that it really sucks that it rains today. That's an attitude I've seen
more often and never really understood: if I see something that's really
awkward, frustrating, and time-consuming then I want to fix it, but a lot of
people seem happy to just 🤷 and accept it.

---

Some other tidbits about this job:

- One of their websites was a "website builder", like Geocities, except worse.
  The value for the customers was that was in Dutch, with Dutch support (it
  didn't even support English.[^i18n] Shortly before I joined they decided to
  rewrite it from scratch (which in this case was probably the right decision by
  the way).

  The old version had basically all code in the controllers; it was a hairy and
  messy "big ball of mud"; you've probably seen this before, especially if you
  were doing PHP ten years ago.

  So come the rewrite people were like "we gonna fix that!" Sure thing, so what
  they did was create a "callModel" handler in the controller, and you had URLs
  like `https://example.com/?callModel=foo&fun=bar` and that would just call the
  function `cm_bar()` method on the `foo` model.

  They had very clean controllers now. Hardly any code there! Look how elegant!
  Almost all code was in the models, including a lot of HTTP handling stuff.

  At least it was prefixed so you couldn't call random functions from the
  models: only those with the `cm_` prefix worked, but it was just the same
  pattern (if you can call it that) with `s/controllers/models/`.

- The same guy who did all of that kept talking about "public variables" in
  JavaScript. I didn't really understand what he meant with that since
  JavaScript doesn't really have public/private visibility or even classes, but
  I didn't work on that project, wasn't super-familiar with JavaScript at the
  time, so whatever.

  Later I started working on that project and learned that a "public variable"
  was `window.varname`. This was basically how he solved all scoping problems.

  This is a something I've seen more often with people "raised on OOP": drop
  them in a non-OOP procedural environment and they're completely lost on how to
  organize their code. He was actually pretty smart, but also very young,
  inexperienced, and not especially well versed in various fundamentals. I
  expect that now, ten years later, he's probably much better. Just being smart
  is not enough.

- One of the developers could not code at all. I don't mean this as "he was a
  bad coder", I mean he **literally** didn't know how to write code. He would
  spend an entire week on something basic and the end result was a 20-line
  function that didn't work, would never work, and something I would just write
  in half an hour, if not less.

  He was let go after his contract expired and got re-hired at his previous Big
  Enterprise™® company with a raise. This is one reason I always eschewed these
  kind of organisations and mostly worked for smaller companies.

  Nice guy though; he was a lot of fun. Just a bad choice of careers (or maybe
  not, since his salary was a lot higher than mine...)

- One of the websites we developed was a reseller for second-hand concert
  tickets, it would combine data from TicketMaster, ViaGoGo, and a whole bunch
  of others so you could "compare prices" and we got a commission for every
  sale.

  I learned far too late that this entire industry is little more than a scam,
  and that the people running this show have the ethical capacity of a
  psychopathic starfish. We were no different.

  That entire industry isn't built on selling something useful to anyone but
  just on duping people in to buying tickets at overinflated prices. A lot of
  times the concerts weren't sold out at all, but we pretended it was. It was
  just a lie. Pretty much 100% of our traffic came in through AdWords, people
  would search "Something-something concerts tickets", got an ad from us, and be
  duped in to buying them at ridiculous prices.

  At one point I learned that one company we connected with would literally just
  invent concerts: they would guess "they're probably doing a tour next year"
  and start "pre-selling" tickets for it at extraordinary prices.

  I very much regret working on this 😑 First job, insecure about your career
  prospects and whether you're able to get a new job, and it becomes easy to
  rationalize these things to yourself.

- While most developers felt at least a little bit dirt working on this, the
  owner thought it was all just great. He was an asshole in general, not just in
  his business practices. He was the kind of person that would aggressively
  berate servers in restaurants over minor things, and ended up being the reason
  I quit.

  That was not a very pretty affair: I hit my screen so hard it almost fell off
  my desk 😅 The backstory to that is that he was nowhere to be found while we
  (the two remaining devs) worked hard on a new product for an entire month, and
  when big bosman finally showed up it was all bad and had to be done different.
  I tried to explain the reasons *why* it was designed the way it was, and his
  only response was "I"m the boss, just do what I say". A real investor in
  people that man was. The only other remaining developer quit not much later.

  The product failed miserably. From what I heard later it never got a single
  customer. A shame, the calendar UI in particular was very good IMO, and better
  than literally any web-based calendar I could find (but I'm probably biased
  😅). Turns out developing a real product is harder than scamming people.

  He was also suffering from the delusion that he could program. He could not
  program. He would send us clobbered-together stuff anyway, which was
  invariably just hopeless, and when we gently tried to improve it he became
  very defensive to the point of aggression and accused us of being stubborn and
  close-minded.

  And then there was the time I improved some of the stuff he translated to
  English. It's not like my English is top-notch perfect, but what he wrote was
  so obvious [Dunglish][d]. I just improved it a bit before putting it online,
  yet he still took it as serious personal attack when he found out which turned
  in to this huge thing for no real reason 🤷

  The only saving grace was that he worked remotely from Berlin so we didn't
  have to deal with him in the office daily. We had a nickname for him in the
  office, after a certain failed Austrian painter who also worked out of Berlin.

[^i18n]: People often seem dismissive of that value i18n, "everyone speaks
         English" Well, depends on who your customer base is. Even in the
         Netherlands where almost everyone speaks *some* English there are still
         loads of people who are not especially good at it and much more
         comfortable with Dutch. This is probably over half the population, and
         it's really not just old people.

[l]: https://lobste.rs/s/b9pddy/when_it_comes_git_history_less_is_more
[d]: https://en.wikipedia.org/wiki/Dunglish
