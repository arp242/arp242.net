---
title: "Comparing compression tools"
date: 2026-04-14
tags: ['Unix']
---

I'd like to know what the "best" compression tool is for storing archives
(backups, data files). So I wrote a tool to compare them: [cmp-compress].

My tl;dr take-away is:

- `zstd -3` for fast compression (the default).
- `xz -7` for the best ratio use; `-8` or `-9` *sometimes* compress better but
  often don't. You probably want to test this.
- `zstd -12` for a good trade-off that leans towards fast.
- `zstd -17` for a good trade-off that leans towards better ratio.
- Add `-T0` to zstd to use all cores if nothing else is running on the system
  (or use the `zstdmt` wrapper).

For other use-cases all of this may of course be different.

Some tools like xz and zstd offer many differs knobs and levers; I'm sure these
are useful but did not bother with them and tested only the presets. I'm not
looking for an incantation to eek out the absolute best – I just want an
informed practical decision on which tool to use with which flags to compress
common stuff.

For the same reason I'm only comparing reasonably common compression tools
already in wide-spread use. There are many others that are very similar to those
listed here with minor differences (e.g. zip, 7zip), not considered stable, or
just not widespread for one reason or the other.

If you're interested in other tools or sets of flags then you can run
cmp-compress yourself.

---

Full Results as HTML table: [/compress.html](/compress.html).
Or as JSON: [/compress.json](/compress.json).

I ran this on the following files:

| vim                      |   5.5M | Statically linked binary                      |
| qemu-system-x86_64       |  29M   | Dynamically linked binary                     |
| dockerd                  |  87M   | Statically linked binary                      |
| dickens                  |   9.7M | English text, no tags                         |
| enwik8                   |  95M   | English text, with XML and Wiki tags          |
| enwik9                   | 950M   | English text, with XML and Wiki tags          |
| yt-dlp-2026.03.17.tar    |  12M   | Python code                                   |
| coreutils-9.10.tar       |  63M   | C code                                        |
| go1.26.1.src.tar         | 150M   | Go code                                       |
| go1.26.1.linux-amd64.tar | 233M   | Mix of Go code and statically linked binaries |

The enwik files are from the [Large Text Compression Benchmark]; dickens is from
the [Silesia compression corpus]; QEMU is version 10.2.0; Docker is version
29.4.0, and vim is a private modified fork that's not easy to exactly reproduce
but a statically linked huge build of Vim 9.1 should be close.

All of this is run on Void Linux with Linux 6.19.10 on a ThinkPad x13 with AMD
Ryzen 7 7840U (8 cores/16 threads) and 32G of memory. I ran all the tests twice
and discarded the first run (`cmp-compress compare >/dev/null && cmp-compress compare >a.json`).

[cmp-compress]: https://github.com/arp242/cmp-compress
[Large Text Compression Benchmark]: https://mattmahoney.net/dc/text.html
[Silesia compression corpus]: https://sun.aei.polsl.pl/~sdeor/index.php?page=silesia

gzip
----
The -# flag has a small effect and becomes useless above -6. Even the difference
between -5 and -6 is quite small, and arguably -5 would be a better default than
-6. -4 is a good setting if you want to be faster as it compresses a bit more
than -1, -2, and -3, but isn't too much slower.

The `-#` flag makes no meaningful difference for decompression times.

In short, use only -4, -5, or -6.

pigz
----
The -# behaves identical to gzip: it has no meaningful difference from gzip
(in most cases pigz compresses slightly better – by a negligible amount but
still). It's often faster when using multiple threads, but single-thread
compression is a bit slower.

It also adds a -11 flag to use the zopfli algorithm. The manpage says it "gives
a few percent better compression at a severe cost in execution time". It's not
exaggerating about the "severe cost": it's always the slowest of *any* tool by a
huge margin. I suppose that it can be useful if you're serving things at
Google-scale, but you're probably not, and other algorithms (brotli, zstd) are
now widely-implemented. I'm going to say that in 2026 it's useless: bzip2, xz,
and zstd can all achieve better compression while being much much faster.

Aside: I kind of wish /bin/gzip would be replaced by pigz, or that gzip would
use zlib and incorporate multi-threaded code. pigz seems stable, reasonably
coded, and generally fairly good. I can't find any reasons to *not* s/gzip/pigz/
other than vague concerns about "it's different", which is not entirely invalid
but pigz has been around for a long time and at some point things need to move
forward.

bzip2
-----
The classic "I'm okay waiting a bit longer than gzip to get better ratios". As a
rule, compression is ~1.5 times slower, and decompression is ~3 times slower. It
practically always gets a better compression ratio than gzip. More so on text
than on binary files.

The -# flags make a small difference in compression ratio or time. There is no
reason to use anything other than `-9` (the default). bzip3 did away with -#
flags entirely.

Both xz and zstd compress better than bzip2, but do take longer. Only on the
dickens file does bzip2 give the same compression ratio as xz, but bzip2 is an
order of a magnitude faster. Overall I'm going to say that bzip2 is rarely worth
it, except *perhaps* if your data is primary text with minimal formatting (e.g.
Markdown files, or similar). I don't know to what degree this holds true for
other languages or scripts as I only tested English.

xz
--
The newer "I'm okay waiting a bit longer than gzip to get better ratios". Both
compression and decompression is fairly slow, but delivers the best ratios of
the common compression tools (zstd comes close, but xz is still meaningfully
better).

The -# flag does little above -5, albeit more than gzip and there is a small but
meaningful difference between the levels. For many files -8 and -9 are much
slower than -7 while having little to no effect on ratio. As a rule you want to
stick with the default of -6 unless you've tested it makes a meaningful
difference on your data.

On binary files it outperforms bzip2 even on -0, on code at around -1, and on
natural language it tends to outperform bzip2 at around -4 or -5, 

Decompression speed decreases with higher -# flags, although this is not quite
linear and sometimes higher -# flags have *faster* decompression speeds.
Sometimes it's *very* slow (e.g. enwik9 is almost two minutes to decompress,
which is by far the slowest other than `pigz -11`.

zstd
----
Unlike gzip and xz the -# flag makes a meaningful difference at any level. The
progression from -1 to -19 isn't linear, but comes closer than anything else. In
particular, the gap between -12 to -13 is consistently large with -13 being two
to three times slower than -12.

Decompression is fast, although does take a noticeable hit at higher -# levels,
but even at -19 it's always faster than xz -0.

It's almost always faster than gzip -1 at lower -# levels while delivering a
better compression ratio. -12 is usually faster than gzip -6 (and -13 is slower,
due to aforementioned jump).

For natural language files it compresses better than bzip2 at around -16, while
being much slower. For code and binary files it's around -6, while being faster.
xz still compresses ~10% better than zstd -19, but xz is slower (often a lot
slower).

The \--ultra flags eeks out a slightly amount of extra compression ratio at the
expense of being a lot slower, although not quite as dramatic as pigz -11. The
compression ratio differences are small enough that for most cases it's rarely
useful. 

\--fast is not that much faster than -1 and compression ratio suffers greatly,
and decompression performance is not significantly faster. There's probably
*some* uses cases where you really want to get the maximum compression
performance, but by and large, I'm going to say it's not very useful for most
cases, outside of some streaming perhaps.

Conclusion
----------
I'm going to say that "just use zstd" is probably decent advice: it doesn't have
the absolute best compression ratio or performance, but for many use-cases the
trade-of it makes are quite good, and it has very fast decompression which is
nice. zstd also has a bewildering number of configuration options, making it
very flexible: e.g. for smaller files the ability to pre-train a dictionary will
make a big difference (not tested in this overview: based on previous
experience).

If you do need absolute maximum compression ratios then xz is often better, at
the expense of being much slower. In some cases that's a good trade-off.

For natural language text bzip2 might still be worth it, but compression seems
to suffer if there's too much formatting (which is often the case in real-world
files).

I want to stress once more that all of this may depend on your specific data,
system you're using, planetary alignments, etc. "Most of the time", "often", and
"usually" do *not* equal "always".
