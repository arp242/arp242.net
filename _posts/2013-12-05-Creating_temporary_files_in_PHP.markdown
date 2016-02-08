---
layout: post
title: Creating temporary files in PHP
---

`mktemp()` isn’t good enough; here’s something that’s (slightly) better.


Creating temporary files in PHP is not as straightforward as it “should” be in a
high-level language. The PHP library offers two functions two create temporary files,
[`tmpfile()`](http://nl3.php.net/manual/en/function.tmpfile.php)
and [`tempnam()`](http://nl3.php.net/tempnam).

I would consider neither adequate, `tmpfile()` accepts no options at all, it’s a
1:1 mapping to the C `tmpfile()` function.  
It returns a file handle (rather than a pathname) and the file is deleted when
the script ends. This certainly has legitimate use cases, but quite often it’s
not what you want.
In addition, the function is susceptible to a race condition.

`tempnam()` is slightly better, but it doesn’t allow creating directories,
using a suffix in the filename, or choose the maximum number of possible files.
I’ve seen (and must admit, even wrote) quick ’n dirty hacks to work around this.

In addition, you also need to specify a `$prefix` (using the rather
wonky-named `sys_get_temp_dir()` function), rather that using a sane default,
and the error reporting (or rather, lack thereof) leaves much to be desired.

This problem has been solved a long time ago. POSIX offers us
[`mkstemp()`](http://pubs.opengroup.org/onlinepubs/009695399/functions/mkstemp.html)
, and many systems also implement `mkstemps()` and `mkdtemp()`.
It’s somewhat unfortunate that PHP doesn’t just implement a proxy to these
functions or re-implements them…

Here my PHP implementation of `mkstemps()`, it behaves slightly different in a
few minor details, but most of it is the same. It doesn’t quite offer the
flexibility that Python’s [`tempfile`](http://docs.python.org/library/tempfile.html)
module offers, but it’s better than the PHP functions.

	#!/usr/bin/env php
	<?php

	/**
	 * Make a temporary file or directory in $prefix
	 *
	 * If $prefix is Null, sys_get_temp_dir() is used
	 *
	 * The template can be any file name, all sequences of two or more subsequent 
	 * X's are replaced by random alphanumeric characters
	 *
	 * If $dir is True, a directory is created
	 *
	 * A MktempError is thrown if an error occurs
	 *
	 * We return the full path to the created file or directory.
	 *
	 * This implementation is written by Martin Tournoij <martin@arp242.net>, while 
	 * peeking at FreeBSD's implementation of mkstemp (src/lib/libc/stdio/mktemp.c)
	 * http://arp242.net/weblog/Creating_temporary_files_in_PHP.html
	 */
	function mktemp($template=Null, $prefix=Null, $dir=False)
	{
		if ($template === Null)
			$template = 'XXXXXX';
		if ($prefix === Null)
			$prefix = sys_get_temp_dir();

		# Check if we can write to $prefix, we will *not* create this directory!
		$oprefix = $prefix;
		$prefix = realpath($prefix);
		if ($prefix === False || !is_dir($prefix))
			throw new MktempError("Prefix `$oprefix' doesn't exists or isn't a directory");
		if (!is_writable($prefix))
			throw new MktempError("Prefix `$prefix' isn't writable");

		# Some sanity checks in $template
		if (strpos($template, '/') !== False)
			throw new MktempException("Template `$template' contains a slash (/) character");
		if (strlen($template) > PHP_MAXPATHLEN)
			throw new MktempException("Template `$template' is longer than PHP_MAXPATHLEN");

		# Replacement characters for the X's
		$padchars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

		# Replace two or more XX's with a random choice from $padchars
		$name = '';
		$doreplace = False;
		$Xs = [];
		foreach (range(0, strlen($template)) as $i) {
			$c = substr($template, $i, 1);
			if ($c !== 'X')
				$doreplace = False;
			elseif ($c === 'X' && substr($template, $i + 1, 1) === 'X')
				$doreplace = True;

			if ($doreplace) {
				$c = $padchars[mt_rand(0, strlen($padchars) - 1)];
				$Xs[] = $i;
			}

			$name .= $c;
		}

		if (count($Xs) === 0)
			throw new MktempError("No sequence of two or more X characters in template `$template'");

		$maxpermutations = pow(strlen($padchars), count($Xs));
		$permutation = 0;
		$curpos = array_shift($Xs);
		$startchr = strpos($padchars, substr($name, $curpos, 1)) - 1;
		$trychr = $startchr;
		while (true) {
			if ($permutation >= $maxpermutations)
				throw new MktempError("Unable to create $prefix/$template; all possible file permutations already exist");

			# Try to create file/directory
			if ($dir) {
				$s = @mkdir("$prefix/$name", 0700);

				# What we *really* want to do is do something along the lines of 
				# `errno == EEXISTS' in C. In PHP there is, as far as I can see, no 
				# way to do this.
				# The only thing we can do is run error_get_last(), and get a text 
				# message, which is locale-dependent and may change in future PHP 
				# versions.
				#
				# This check is needed, because all sort of things can go wrong (
				# permissions of $prefix changed, signal caught, symlink loop, max 
				# file descriptors, etc).
				#
				# The file_exists() sort of solves the problem, I can't think of any 
				# serious drawbacks, but it's extra disk I/O, and in very, *VERY* 
				# rare cases it's not reliable (fopen() failed for another reason & 
				# this file is created before we arrive at this check)
				#
				# There's a bug for this, but it doesn't seem to be considered much 
				# of a priority...  https://bugs.php.net/bug.php?id=49396
				if (!$s && file_exists("$prefix/$name")) {
					$err = error_get_last();
					throw new MktempError("Error creating `$prefix/$name': {$err['message']}");
				}
				if ($s) break;
			}
			else {
				$s = @fopen("$prefix/$name", 'x');

				if ($s === False && !file_exists("$prefix/$name")) {
					$err = error_get_last();
					throw new MktempError("Error creating `$prefix/$name': {$err['message']}");
				}

				if ($s !== False) {
					fclose($s);
					chmod("$prefix/$name", 0600);
					break;
				}
			}

			# Loop over each X we replaced, and try the next character from 
			# $padchars
			$permutation += 1;
			$trychr += 1;
			if ($trychr > strlen($padchars) - 1)
				$trychr = 0;

			if ($trychr === $startchr) {
				$curpos = array_shift($Xs);
				$startchr = strpos($padchars, substr($name, $curpos, 1)) - 1;
				$trychr = $startchr + 1;
			}

			$name = substr_replace($name, $padchars[$trychr], $curpos, 1);
		}

		return "$prefix/$name";
	}

	class MktempError extends Exception { }


### Some basic tests

	error_reporting(E_ALL);
	ini_set('display_errors', 'on');

	foreach (range(0, 10) as $i) {
		try {
			mktemp('nonexistent', '/nonexistent');
			print("We excpected an exception\n");
			exit(1);
		}
		catch (MktempError $exc) { }

		try {
			mktemp('NoXCharacters');
			print("We excpected an exception\n");
			exit(1);
		}
		catch (MktempError $exc) { }

		try {
			mktemp('ohnoes.XXXXXX', '../../../../../etc/passwd');
			print("We excpected an exception\n");
			exit(1);
		}
		catch (MktempError $exc) { }

		$path = mktemp('hello XXXXXX world');
		print "$path\n";
		unlink($path);

		$dir = mktemp('dir.XXXXX', Null, True);
		print "$dir\n";
		rmdir($dir);

		$path = mktemp("-> XXX TEST XXXX <- &|\n	asdf XXXX");
		print "$path\n";
		unlink($path);

		print "\n";
	}
