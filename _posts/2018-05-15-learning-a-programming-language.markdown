---
layout: post
title: "Learning a programming language"
updated: 2018-07-31
---

My advice to anyone learning a new programming language is always the same: get
the best book out there, read it, do the exercises, and then build some program
with it.

“Tutorials” and such might be nice if you’re only looking to adjust an existing
program in an unfamiliar language, or just want to get the general flavour of
the language before actually investing too much time in to learning it, but they
are almost always inadequate to truly teach a language. Learning a language is
more than just learning the syntax, but also learning best practices, idioms,
common pitfalls, etc. Tutorials usually don’t give you that, and only give you
syntax (and usually do a mediocre job at that, too).

Learning practical skills is not about *reading* but about *doing*. Only
*reading* about carpentry will not make me a carpenter. Of course it’s important
to learn about the appropriate techniques, but only actually practising what I’ve
read will teach me to be a carpenter.
This is why you should do the exercises and write a program. Even writing a
comparatively simple program will help solidify your skills. I encourage people
to write real actually useful projects as soon as they're able, which help with
motivation as well as solidifying the new knowledge.

Taking notes while reading the book also helps. I always write down key concepts
while I’m reading about them in brief notes. I don’t often refer to them, it’s
just useful to write things down in your own words to help your brain memorize
them (also see [Why write?](/why-write.html))

For example an excerpt in my notes for Go:

	Strings
	-------

		// utf-8 by default
		s := "€e"

		// But many operations operate on bytes, and not characters:
		fmt.Println(s[0:3])

		// Array of runes
		x := []rune(s)

		// Array of bytes
		y := []byte(s)

		// Unlike strings these are not immutable!
		y[3] = 'X'
		x[1] = 'X'
		fmt.Println(s, string(x), string(y))  // €e €X €X

		// 8364, 226
		fmt.Println(x[0], y[0])

		// €
		fmt.Println(string(x[0]))

		// Useful packages:
		// bytes, strings, strconv, unicode
		// var buf bytes.Buffer

		// Convert
		s := string(byteArray)

---

Do remember that programming books are like most things in life: [90% of them
are crap](https://en.wikipedia.org/wiki/Sturgeon%27s_law). Some of them – even
popular ones – can be truly terrible, and the best book *for you* also depends
on personal preference and your prior knowledge of programming (e.g. some books
assume prior basic programmer knowledge).

So please do take some time researching which book to buy; ask on reddit, or the
Stack Overflow chat. Usually experts in the language have a pretty good idea
what the good and bad books are.

---

A common question people new to programming ask is “what language should I
learn?”

As long as you stick to one of the mainstream languages it matters little. While
there *are* large differences between languages, the basics are fairly
universal, and without any experience it will be hard to judge your personal
preferences. It’s like picking your favourite music genre without ever having
listened to music.

That being said, I generally recommend Python, as it’s a good general purpose
language with a helpful and positive community. But if you think C#, Java, PHP,
Ruby, C++, JavaScript, or something else better fits your needs or preferences
then by all means go for it.

<div class="postscript">
<strong>Related articles</strong>
<ul>
<li><a href="https://eddyerburgh.me/how-i-take-notes-from-technical-books">How I take notes from technical books</a></li>
</ul>
</div>
