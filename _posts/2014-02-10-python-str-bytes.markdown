---
layout: post
title: "A primer on the str and bytes types in Python 3"
---

Python 3 handles strings a bit different. Originally there was only one type for
strings: `str`. When unicode gained traction in the '90s the new `unicode` type
was added to handle Unicode without breaking pre-existing code.[^1] This is
effectively the same as `str` but with multibyte support.

In Python 3 there are two different types:

- The `bytes` type. This is just a sequence of bytes, Python doesn't know
  anything about how to interpret this as characters.
- The `str` type. This is also a sequence of bytes, *but Python knows how to
  interpret those bytes as characters*.
- The separate `unicode` type was dropped. `str` now supports unicode.

In Python 2 implicitly assuming an encoding can cause a lot of problems; you can
end up using the wrong encoding, or the data may not be text in the first place
(e.g. it’s a PNG image or some other binary data).

Explicitly telling Python which encoding to use (or explicitly telling it to
guess) is often a lot better and much more in line with the "Python philosophy"
of "[explicit is better than implicit][pep20]".

This change is incompatible with Python 2 as many return values have changed,
leading to subtle problems like this one; it’s the main reason why Python 3
adoption has been so slow. Since Python doesn't have static typing[^2] it’s hard
to change this automatically with a script (such as the bundled `2to3`).

- You can convert `str` to `bytes` with `bytes('h€llo', 'utf-8')`; this should
  produce `b'H\xe2\x82\xacllo'`. Note how one character was converted to three
  bytes.
- You can convert `bytes` to `str` with  `b'H\xe2\x82\xacllo'.decode('utf-8')`.

UTF-8 may not be the correct character set in your case, so be sure to use the
correct one.

In your specific piece of code, `nextline` is of type `bytes`, not `str`,
reading `stdout` and `stdin` from `subprocess` changed in Python 3 from `str` to
`bytes`. This is because Python can't be sure which encoding this uses. It
*probably* uses the same as `sys.stdin.encoding` (the encoding of your system),
but it can’t be sure.

You need to replace:

    sys.stdout.write(nextline)

with:

    sys.stdout.write(nextline.decode('utf-8'))

or maybe:

    sys.stdout.write(nextline.decode(sys.stdout.encoding))

You will also need to modify `if nextline == ''` to `if nextline == b''` since:

    >>> '' == b''
    False

Also see the [Python 3 ChangeLog][changelog], [PEP 358][pep358], and [PEP 3112][pep3112].

[^1]: There are some neat tricks you can do with ASCII that you can't do with multibyte character sets; the most famous example is the "xor with space to switch case" (e.g. `chr(ord('a') ^ ord(' ')) == 'A'`) and "set 6th bit to make a control character" (e.g. `ord('\t') + ord('@') == ord('I')`). ASCII was designed in a time when manipulating individual bits was an operation with a non-negligible performance impact.

[^2]: Yes, you can use function annotations, but it's a comparatively new feature and little used.

[changelog]: http://docs.python.org/3.0/whatsnew/3.0.html#text-vs-data-instead-of-unicode-vs-8-bit
[pep20]: http://www.python.org/dev/peps/pep-0020/
[pep358]: http://www.python.org/dev/peps/pep-0358/
[pep3112]: http://www.python.org/dev/peps/pep-3112/
