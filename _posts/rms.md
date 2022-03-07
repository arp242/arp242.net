---
title: "Stallman isn't great, but not the devil"
date: 2021-03-25
tags: ['Open source', 'Community', 'Politics']
---

So Richard Stallman is back at the FSF, on the board of directors this time
rather than as President. I'm not sure how significant this position is in the
day-to-day operations, but I'm not sure if that's really important.

How anyone could have thought this was a good idea is beyond me. I've long
considered Stallman to be a poor representative of the community, and quite
frankly it baffles me that people do. I'm not sure what the politics were that
led up to this decision; I had hoped that after Stallman's departure the FSF
would move forward and shed off some of the Stallmanisms. It seems this hasn't
happened.

To quickly recap why Stallman is a poor representative:

- Actively turned many people off because he's such a twat; one of the better
  [examples I know of is from Keith Packard][x], explaining why X didn't use the
  GPL in spite of Packard already having used it for some of his projects
  before:

  > Richard Stallman, the author of the GPL and quite an interesting individual
  > lived at 5405 DEC square, he lived up on the sixth floor I think? Had an
  > office up there; he did not have an apartment. And we knew him extremely
  > well. He was a challenging individual to get along with. He would regularly
  > come down to our offices and ask us, or kind of rail at us, for not using
  > the GPL.
  >
  > This did not make a positive impression on me; this was my first
  > interaction with Richard directly and I remember thinking at the time,
  > "this guy is a little, you know, I'm not interesting in talking to him
  > because he's so challenging to work with."
  >
  > And so, we should have listened to him then but we did not because, we know
  > him too well, I guess, and met him as well.
  >
  > He really was right, we need to remember that!

  [x]: https://youtu.be/cj02_UeUnGQ?t=1705

- His behaviour against women in particular is creepy. This is not a crime (he
  has, as far as I know, never forced himself on anyone) but not a good quality
  in a community spokesperson, to put it mildly.

- His personal behaviour in general is ... odd, to put it mildly. Now, you can
  be as odd as you'd like as far as I'm concerned, but I also don't think
  someone like that is a good choice to represent an entire community.

- Caused a major and entirely avoidable fracture of the community with the *Open
  Source* movement; it's pretty clear that Stallman, him specifically as a
  person, was a major reason for the OSI people to start their own organisation.
  Stallman still seems to harbour sour grapes over this more than 20 years
  later.

- Sidetracking of pointless issues ("GNU/Linux", "you should not be using hacker
  but cracker", "Open Source misses the point", etc.), as well as stubbornly
  insisting on the term "Free Software" which is confusing and stands in the way
  if communicating the ideals to the wider world. Everyone will think that an
  article with "Free Software" in the title will be about software free of
  charge. There is a general lack of priorities or pragmatism in almost
  anything Stallman does.

- Stallman's views in general on computing are stuck somewhere about 1990.
  Possibly earlier. The "GNU Operating System" (which does not exist, has never
  existed, and most likely will never exist[^gnu]) is not how to advance Free
  Software in modern times. Most people don't give a rat's arse which OS they're
  using to access GitHub, Gmail, Slack, Spotify, Netflix, AirBnB, etc. The world
  has changed and the strategy needs to change – but Stallman is still stuck in
  1990.

  [^gnu]: A set of commandline utilities, libc, and a compiler are not an
          operating system. Linux (the kernel) is not the "last missing piece of
          the GNU operating system".

- Insisting on absolute freedom to the detriment of *more* freedom compared to
  the status quo. No, people don't want to run a "completely free GNU/Linux
  operating system" if their Bluetooth and webcam doesn't work and if they can't
  watch Netflix. That's just how it is. Deal with it.

  His views are quite frankly [ridiculous][install]:

  > If [an install fest] upholds the ideals of freedom, by installing only free
  > software from 100%-free distros, partly-secret machines won't become
  > entirely functional and the users that bring them will go away disappointed.
  > However, if the install fest installs nonfree distros and nonfree software
  > which make machines entirely function, it will fail to teach users to say no
  > for freedom's sake. They may learn to like GNU/Linux, but they won't learn
  > what the free software movement stands for.
  >
  > [..]
  >
  > My new idea is that the install fest could allow the devil to hang around,
  > off in a corner of the hall, or the next room. (Actually, a human being
  > wearing sign saying “The Devil,” and maybe a toy mask or horns.) The devil
  > would offer to install nonfree drivers in the user's machine to make more
  > parts of the computer function, explaining to the user that the cost of this
  > is using a nonfree (unjust) program.

  Aside from the huge cringe factor of having someone dressed up as a devil to
  install a driver, the entire premise is profoundly wrong; people *can*
  appreciate freedom while also not having absolute/maximum freedom. Almost the
  entire community does this, with only a handful of purist exceptions. This
  will accomplish nothing except turn people off.

  [install]: https://www.gnu.org/philosophy/install-fest-devil

- Crippling software out of paranoia; for example Stallman [refused to make gcc
  print the AST][ast] – useful for the Emacs completion and other tooling –
  because he was afraid someone might "abuse" it. He comes off as a gigantic
  twat in that entire thread (e.g. [this][ast2]).

  How do you get people to use Free Software? *By making great software people
  want to use*. Not by offering some shitty crippled product where you can't do
  some common things *you can already do in the proprietary alternatives*.

  [ast]: https://lists.gnu.org/archive/html/emacs-devel/2015-01/msg00015.html
  [ast2]: https://lists.gnu.org/archive/html/emacs-devel/2015-01/msg00213.html

---

Luckily, the backlash against this has been significant, including [an open
letter to remove Richard M. Stallman from all leadership positions][l]. Good.
There are many things in the letter I can agree with. If there are parliamentary
hearings surrounding some Free Software law then would you want Stallman to
represent you? Would you want Stallman to be left alone in a room with some
female lawmaker (especially an attractive one)? I sure wouldn't; I'd be fearful
he'd leave a poor impression, or outright disgrace the entire community.

But there are also a few things that bother me, as are there in the general
conversation surrounding this topic. Quoting a few things from that letter:

[l]: https://rms-open-letter.github.io/

> [Stallman] has been a dangerous force in the free software community for a
> long time. He has shown himself to be misogynist, ableist, and transphobic,
> among other serious accusations of impropriety.
>
> [..]
>
> him and his hurtful and dangerous ideology
>
> [..]
>
> RMS and his brand of intolerance

Yikes! That sounds horrible. But closer examinations of the claims don't really
bear out these strong claims.

The transphobic claim seems to hinge entirely on his eclectic opinion regarding
gender-neutral pronouns; he prefers some [peculiar set of neologisms][p] ("per"
and "pers") instead of the singular "they". You can think about his pronoun
suggestion what you will – I feel it's rather silly and pointless at best – but
a disagreement on how to best change the common use of language to be more
inclusive does not strike me as transphobic. Indeed, it strikes me as the *exact
opposite*: he's willing to spend time and effort to make language *more
inclusive*. That he doesn't do it in the generally accepted way is not
transphobia, a "harmful ideology", or "dangerous". It's really not.

Stallman is well known for his [excessive pedantry surrounding language][t];
he's not singularly focused on the issue of pronouns and has [consistently
posted in favour of trans rights][t2].

[p]: https://stallman.org/articles/genderless-pronouns.html
[t]: https://www.gnu.org/philosophy/words-to-avoid.html
[t2]: https://duckduckgo.com/?t=ffab&q=site%3Astallman.org+transgender&ia=web

Stallman's penchant to make people feel unconformable has long been known; and
should hardly come as a surprise to anyone. Many who met him in person did not
leave with an especially good impression of him for one reason or the other. His
behaviour towards women in particular is pretty bad; many anecdotes have been
published and they're pretty 😬

But ... I don't have the impression that Stallman dislikes or distrusts women,
or sees them as subservient to men. Basically, he's just creepy. That's not
good, but is it misogyny? His lack of social skills seem to be broad and not
uniquely directed towards women. He's just a socially awkward guy in general. I
mean, this is a guy who will, *when giving a presentation*, will take off his
shoes and socks – which is already a rather weird thing to do – will then
proceed to *rub his bare foot* – even weirder – only to proceed to appear to
*eat something from his foot* – wtf wtf wtf?!

If he can't understand that this is just ... wtf, then how can you expect him to
understand that some comment towards a woman is wtf?

Does all of this excuse bad behaviour? No. But it shines a rather different
light on things than phrases such as "misogynist", "hurtful and dangerous
ideology", and "his brand of intolerance" do. He hasn't forced himself on
anyone, as far as I know, and most complaints are about him being creepy.

I don't think it's especially controversial to claim that Stallman would have
been diagnosed with some form of autism if he had been born several decades
later. This is not intended as an insult or some such, just to establish him as
a neurodivergent[^ne] individual. Someone like that is absolutely a poor choice
for a leadership position, but at the same time doesn't diversity *also* mean
diversity of neurodivergent people, or at the very least some empathy and
understanding when people's exhibit a lack of social skills and behaviour
considered creepy?

[^ne]: Neurodivergency is, in a nutshell, the idea that "normal" is a wide
       range, and that not everyone who doesn't fits with the majority should be
       labelled as "there is something wrong with them" such as autism. While
       some some people take this a bit too far (not every autist is
       high-functioning; for some it really is debilitating) I think there's
       something to this.

At what point is there a limit if someone's neurodiversity drives people away? I
don't know; there isn't an easy answer to his. Stallman is *clearly* unsuitable
for a leadership role; but "misogynist"? I'm not really seeing it in Stallman.

The ableist claim seems to mostly boil down to a comment he posted on his
website regarding abortion of fetuses with Down's syndrome:

> A new noninvasive test for Down's syndrome will eliminate the small risk of
> the current test.
>
> This mind lead more women to get tested, and abort fetuses that have Down's
> syndrome. Let's hope so!
>
> If you'd like to love and care for a pet that doesn't have normal human mental
> capacity, don't create a handicapped human being to be your pet. Get a dog or
> a parrot. It will appreciate your love, and it will never feel bad for being
> less capable than normal humans.

It was [later edited][down] to its current version:

[down]: https://stallman.org/archives/2016-sep-dec.html#31_October_2016_%28Down%27s_syndrome%29

> A noninvasive test for Down's syndrome eliminates the small risk of the old
> test. This might lead more women to get tested, and abort fetuses that have
> Down's syndrome.
>
> According to Wikipedia, Down's syndrome is a combination of many kinds of
> medical misfortune. Thus, when carrying a fetus that is likely to have Down's
> syndrome, I think the right course of action for the woman is to terminate the
> pregnancy.
>
> That choice does right by the potential children that would otherwise likely
> be born with grave medical problems and disabilities. As humans, they are
> entitled to the capacity that is normal for human beings. I don't advocate
> making rules about the matter, but I think that doing right by your children
> includes not intentionally starting them out with less than that.
>
> When children with Down's syndrome are born, that's a different situation.
> They are human beings and I think they deserve the best possible care.

He also made a few other comments to the effect of "you should abort if you're
pregnant with a fetus who has Down's syndrome".

That last paragraph of the original version was ... not great, but the new
version seems okay to me. It *is* a women's right to choose to have an abortion,
for any reason, including not wanting to raise a child with Down's syndrome.
This is already commonplace in practice, with many women choosing to do so.

Labelling an entire person as ableist based *only* on this – and this is really
the only citation of ableism I've been able to find – seems like a stretch, at
best. It was a shitty comment, but he *did* correct it which is saying a lot in
Stallman terms, as I haven't seen him do that very often.

---

Phrases like "a dangerous force", "dangerous ideology", and "brand of
intolerance" make it sound like he's crusading on these kind of issues. Most of
these are just short notes on his personal site which few people seem to read.

Most of the issues surrounding Stallman seem to be about him thinking out loud,
not realizing when it is or is not appropriate to do so, being excessively
pedantic over minor details, or just severally lacking in social skills. This can
be inappropriate, offensive, or creepy – depending on the scenario – but that's
just something different than being actively transphobic or dangerous. If
someone had read only this letter without any prior knowledge of Stallman they
would be left with the impression that Stallman is some sort of alt-right troll
writing for Breitbart or the like. This is hardly the case.

I think Stallman *should* resign of newly appointed post, and from GNU as well,
over his personal behaviour in particular. Stallman isn't some random programmer
working on GNU jizamabob making the occasional awkward comment, he's the face of
the entire movement. Appointing "a challenging individual to get along with" –
to quote Packard – is not the right person for the job. I feel the rest of the
FSF board has shown spectacular poor judgement in allowing Stallman to come
back.[^s]

[^s]: I guess this shouldn't come as that much of a surprise, as the only people
      willing and able to hang around Stallman's FSF were probably similar-ish
      people. It's probably time to just give up on the FSF and move forward
      with some new initiative (OSI is crap too, for different reasons). I swear
      we've got to be the most dysfunctional community ever.

But I can not, in good conscience, sign the letter as phrased currently. It
vastly exaggerates things to such a degree that I feel it does a gross injustice
to Stallman. It's  grasping at straws to portray Stallman as the most horrible
human being possible, and I don't think he is that. He seems clueless on some
topics and social interactions, and find him a bit of a twat in general, but
that doesn't make you a horrible and dangerous person. I find the letter lacking
in empathy and deeply unkind.

---

In short, I feel Stallman's aptitudes do not apply well for any sort of
leadership position and I would rather not have him represent the community I'm
a part of, even if he did start it and made many valuable contributions to it.
Just starting something does not give you perpetual ownership over it, and in
spite of all his hard work I feel he's been very detrimental to the movement and
has been a net-negative contributor for a while. A wiser version of Stallman
would have realized his shortcomings and stepped down some time in the late 80s
to let someone else be the public face.

Overall I feel he's not exactly a shining example of the human species, but then
again I'm probably not either. He is not the devil and the horrible person that
the letter makes him out to be. None of these exaggerations are even *needed* to
make the case that he should be removed, which makes it even worse.

It's a shame, because instead of moving forward with Free Software we're
debating this. Arguably I should just let this go as Stallman isn't *really*
worth defending IMO, but on the other hand being unfair is being unfair, no
matter who the target may be.
