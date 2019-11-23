---
layout: post
title: "PHP’s fopen() is broken"
tags: ['PHP']
updated: 2019-01-20
desc: "Even essential standard library functions such as fopen() suffer from some serious shortcomings in PHP"
hatnote: |
 Discussions:
 <a href="https://www.reddit.com/r/lolphp/comments/agam6a/phps_fopen_is_broken_2017/">/r/lolphp</a>.
---

I know that “bashing PHP” is *so 2010*. But even now many people don’t seem to
fully realize the limitations and problems of this language.

There have been some improvements in the last few years (the sort of
improvements that other languages have had for ages), but some problems still
remain. Arguably the largest is the absolutely abysmal state of the standard
library. Rather than do a [Gish gallop][gish] I’ll focus on one basic core
function: [`fopen()`][php-fopen].

Lack of errors
--------------

On errors `fopen()` simplistically returns boolean `False` and emits an
`E_WARNING` error; the problem here is that *there is no way to figure out what
went wrong*.

In C, you can use the `errno` variable to check what went wrong. `EEXISTS`
indicates the path already exists, `EACCESS` indicates you don’t have
permission, `ELOOP` indicates there are too many symlinks, and so forth. See
[POSIX for a full list][c-fopen].

This can be very useful. On an `ENAMETOOLONG` error you could trim the pathname
and try again, for `EEXISTS`, you could try adding `(1)` to the filename, etc.
In other words: you can do something sane, rather than quit and say “an error
occurred, have a nice day”.

For some algorithms, these errors are *required* to work properly. If you want
to have a `mktemp()` with more features than the default function PHP offers,
you *need* this to prevent race conditions ([see my `mktemp()`][mktemp]).
There is no obvious way to do this in PHP, other than ‘silence’ the error with
the `@` operator, use `error_get_last()`, and do a string search on that. This
is rather ugly and prone to breaking: the error might change in the future and
the text is locale-independent (e.g. French locale gets French errors).

There are some functions that get the `errno` for specific modules, such as
`curl_errno()` and `posix_errno()`, but those only work for the functions from
that module, not for `fopen()` or other functions.

### Other languages?

Every other language that I know of 
[except Bourne shell scripting](http://stackoverflow.com/q/27152022/660921)
can do this. For example in Ruby we use exceptions:

    begin
      File.open '/etc/passwd', 'w'
    rescue Errno::EACCESS
      puts 'Access denied'
      exit 1
      # Or maybe ask user for different filename and try again?
	  # Or maybe execute myself again with sudo?
	  # Or maybe try a different filename?
    end

All other languages that I know work the same, either by exceptions, or by a
return value or special `errno` variable.

### Exceptions

`fopen()` never raises an exception, this code:

	try {
		$fp = fopen('/etc/shadow', 'r');
	}
	catch (Exception $exc) {
		print("Error!\n");
	}
	print("Okay!\n");

Will still give you:

	PHP Warning: fopen(/etc/shadow): failed to open stream: Permission denied in /home/martin/test.php on line 4

And PHP will *continue happily* after this error as if nothing happened. Yikes!

What you could do instead is to install a [custom error handler][err-h] to throw
an exception:

	set_error_handler(function($errno, $errstr, $errfile, $errline) {
		throw new ErrorException('Error!');
	});

	try {
		$fp = fopen('/etc/shadow', 'r');
	}
	catch (Exception $exc) {
		print("Error!\n");
	}

But this requires modifying the way PHP behaves. In some scenarios this is okay,
but sometimes it’s more tricky (in libraries, for example), so we can do:

	# The @ suppresses printing the error message.
	$fp = @fopen('/etc/shadow', 'r');
	if (!$fp) {
		$err = error_get_last();
		throw new Exception($err['message']);
	}

But what if you’re using this in a larger piece of code, and some other code
installed an error handler to throw an exception (as is somewhat common to do
these days)?

So what we should write, is:

	try {
		$fp = null;
		$fp = @fopen('/etc/shadow', 'r');
	}
	catch (Exception $exc) { }

	if (!$fp) {
		$err = error_get_last();
		throw new Exception($err['message']);
	}

Ugh.

This is *not* fixed in PHP 7. In spite of [the changelog](http://php.net/manual/en/migration70.incompatible.php)
mentioning:

> Many fatal and recoverable fatal errors have been converted to exceptions in
> PHP 7.

Quite a few lower-level functions – such as `fopen()` – have not been converted.

Opening directories
-------------------

Another curious copy of C behaviour is that you can `fopen()` directories:

> fopen — Opens file or URL
>
> [...]
>
> This function may also succeed when filename is a directory. If you are
> unsure whether filename is a file or a directory, you may need to use the
> `is_dir()` function before calling `fopen()`.

Wait, what?! Let’s check this:

	$fp = fopen('/etc', 'r');

	var_dump($fp);
	# resource(4) of type (stream)

	var_dump(fread($fp, 1024));
	# string(0) ""

	var_dump(file_get_contents('/etc'));
	# string(0) ""

	var_dump(readdir($fp));
	# PHP Warning:  readdir(): 5 is not a valid Directory resource in php shell code on line 1

	var_dump(fstat($fp));
	# array(26) {

	var_dump(flock($fp, LOCK_EX));
	# true

Not even a warning; but on mode `w` you get an error:

	$fp = fopen('/etc', 'w');
	PHP Warning:  fopen(/etc): failed to open stream: Is a directory in php shell code on line 1

In Unix/C a directory is really a file; and originally you could open and read
it like any ol’ file. This is how you got the directory entries back in the day!

Here’s an example:

	# Doesn't work on Linux. Try it on BSD!
	$ hexdump -C testdir
	00000000  e9 0c 03 00 0c 00 04 01  2e 00 00 00 d6 3d 02 00  |.............=..|
	00000010  0c 00 04 02 2e 2e 00 00  ea 0c 03 00 10 00 08 05  |................|
	00000020  66 69 6c 65 31 00 4a c6  eb 0c 03 00 10 00 08 05  |file1.J.........|
	00000030  66 69 6c 65 32 00 4a c6  ec 0c 03 00 10 00 0a 05  |file2.J.........|
	00000040  6c 69 6e 6b 31 00 4a c6  ed 0c 03 00 b8 01 04 04  |link1.J.........|
	00000050  64 69 72 31 00 00 00 00  00 00 00 00 00 00 00 00  |dir1............|
	00000060  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

In `testdir` there are 4 entries: 2 files, a symlink, and a directory.

It looks like Linux actually prevents you from `fopen()`-ing directories, as it
doesn’t make all that much sense on modern systems. Making the Linux `fopen()`
behaviour *more* high-level than PHP’s.

Magic file objects
------------------

`fopen()` returns a ‘magic file object’, this:

	var_dump(fopen('/etc/passwd', 'r'));

Will give you:

	resource(5) of type (stream)

So how do we use this? How do I implement my own “type (steam)” that can be used
with `fread()`? This is not at all obvious. It looks like a
[resource](http://php.net/manual/en/language.types.resource.php) is a magic
special internal thing.

Compare this with Python, Ruby, Go, and many other languages where you can
easily create file-like objects, and where these sort of objects are used
extensively throughout the standard library and third-party libraries.

In PHP, everyone will have to invent their own API.

Wrappers
--------

`fopen()` supports the concept of “wrappers” so you can use it to download files
from HTTP, FTP, open archives, and so forth.

This may or may not work, depending on the value of `allow_url_fopen`. Every PHP
installation behaves different!

There are some problems with this; for starters it's rather hackish. How do you
get the response headers? Why, with a special magically created
[`$http_response_header`](http://php.net/manual/en/reserved.variables.httpresponseheader.php)
variable of course!

But much more seriously, it can be a pretty big security problem. You should of
course always validate and/or sanitize user input, but it’s a fact of life that
occasionally attackers find creative ways to bypass this. These stream wrappers
will escalate the severity of these sort of attacks, not infrequently to a
remote code vulnerability.[^1]

[^1]: This is an even bigger problem with `include()` and friends, where these
	  wrappers *also* work. `include($malicious_input)` will “upgrade” an
	  information disclosure bug (which is already serious) to a remote code
	  exploit. Botnet operators of the world rejoice! Thankfully, this behaviour
	  is now off by default, but it took the PHP folk a while to realize this
	  was even a problem since `allow_url_include` wasn't introduced until 2006.

What about the rest of the standard library?
--------------------------------------------

One PHP proponent might reply to this article with something along the lines of:
“so fopen may have serious shortcomings, but that’s only one function out of
thousands!”

Well, yes, but many functions in PHP suffer from similar problems (and some,
such as `proc_open()`, are even worse).

I chose to highlight a single example in depth, rather than list a large list of
things.

Conclusion
---------

PHP has made some decent progress in the area of language features, but I
believe the largest problem always has been – and continues to be – the lack of
quality in the standard library. I’ve used `fopen()` as a single example here,
but I could have used many others.

The lack of good errors is a common problem, not only with `fopen()`. Other
problems include standard library functions missing features, leaving you to
re-implement them yourself (this is why PHP frameworks are so popular, they
attempt to fix much of the standard library).

All of this makes that PHP is unsuitable for reliable and robust systems
programming, or, indeed, for any sort of programming at all. Often, the
counterparts in C are actually better, and if C has features that your
‘high-level’ programming language does not have, then I think you’re probably
doing something wrong.

"This is not PHP's target environment" is a bit of a weak excuse for not doing
things correct. It's not a whole lot more effect, so why *not* do it. Besides, a
lot of these issues affect web programming too.

Can it be fixed? Maybe. But changing public APIs is difficult. There is a lot of
code that assumes the existing API, and if you break too much, It doesn’t matter
how much better you make it, any people will stick to the old version rather
than use the new version (see: Python 3, Perl 6).

Perhaps we shouldn’t fix PHP. There are plenty of alternatives available with a
similar feature-set. Why do we need PHP? If you ask me, investing time in PHP is
a [sunk-cost fallacy](http://rationalwiki.org/wiki/Sunk_cost).

[gish]: http://www.urbandictionary.com/define.php?term=Gish%20Gallop
[php-fopen]: http://php.net/manual/en/function.fopen.php
[proc_open]: http://php.net/manual/en/function.proc_open.php
[c-fopen]: http://pubs.opengroup.org/onlinepubs/9699919799/functions/fopen.html#tag_16_155_05
[mktemp]: /php-mktemp.html
[err-h]: http://php.net/manual/en/function.set-error-handler.php
