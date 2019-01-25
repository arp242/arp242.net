---
layout: code
title: "password-bunny"
link: "password-bunny"
last_version: "version-1.3"
redirect: "https://github.com/Carpetsmoker/password-bunny"
---

[![This project is archived](https://img.shields.io/badge/Status-archived-red.svg)](https://arp242.net/status/archived)

Note that this project is **archived**. I added a `convert-to-pass` script to
convert the contents of a password database to
[`pass`](https://www.passwordstore.org/).

---

Manage passwords with Vim.

You will need Vim 7.4.399 or later (Vim 7.3 will also work, but has a flaw in
the blowfish implementation and is *not* secure; we will warn for this).

This program was tested on FreeBSD & Arch Linux; it will *probably* also work on
other POSIX systems (OpenBSD, MacOSX, Other Linuxes, etc.). It will *not* work
on Windows.

Use `./pwbunny` to start the program or use `./gpwbunny` to use gVim. You can
optionally specify a file to open, i.e.: `./pwbunny my-passwords`. The default
is `passwords.pwbunny` in the directory `pwbunny` was  called from.  
See `pwbunny -h` for more command-line options.


Clipboard support
=================
Some functions need some way to access the clipboard. If Vim has `+clipboard`
we’ll use that. If it doesn’t, we try to use one of these command-line utilities:

- [xclip][xclip]
- [xcopy][xcopy]
- xsel (the original, no page) or the [newer xsel][xsel]
- `pbcopy`/`pbpaste` (for OSX)


Clipboard support is useful but entirely *optional*.

You can also use the clipboard features over an ssh session with X11 forwarding,
please see the notes in the ‘Security’ section before enabling this.

You also need to enable both `ForwardX11` and `ForwardX11Trusted`; on the
command-line this can be done with the `-X` and `-Y` flags, i.e.:
`ssh -XY $server`

Or you can set these options for a host in your `~/.ssh/config`:

	Host myhost
		ForwardX11 yes
		ForwardX11Trusted yes


Password strength checking
==========================
Pwbunny can also check the strength of passwords. This requires either Python
or Ruby support, and the he “zxcvbn” module for the language. Which you can find
here:

- [python-zxcvbn](https://github.com/dropbox/python-zxcvbn)
- [zxcvbn-ruby](https://github.com/envato/zxcvbn-ruby)

The result is a number from 0 to 4, which represents an estimation of the crack
time:

- 0: 100 seconds (very bad)
- 1: 2.5 hours (bit better, but still bad)
- 2: 11 days (okay-ish)
- 3: 3 years (good)
- 4: Infinity (very good)


Security
========
- The file is encrypted with [blowfish][blf], which should be secure, although
  it is possible that the Vim implementation may be incorrect (a
  [vulnerability][vuln] was discovered, and fixed, in August 2014).

- Your system’s memory will contain the plaintext contents. You should only run
  this program on trusted machines (i.e. not a shared host or the like).

- Pwbunny uses the system’s clipboard extensively to get the passwords to your
  applications (e.g. browser); you should be aware that *any* program can read
  the clipboard, including malicious clipboard snoopers (as well as
  non-malicious snoopers, which may store their clipboard history database as
  world-readable in plain text).

- Using `ForwardX11Trusted` effectively gives the server complete control over
  the machine you’re connecting with, which may be a **serious** security
  problem. **Only** use this if you fully trust the server, and **do not** set
  these options globally!

- May not be safe against holy hand grenade attacks.


Keybinds
========
- `<Leader>a`  
Add a new entry. This is the recommended way to add a new entry.

- `<Leader>g`  
Go to an entry; try to open it in a browser (this uses `gx`).

- `<Leader>c`  
Copy the password of the entry under the cursor (which may still be in a closed
fold). This is especially useful if someone may be watching over your shoulder.  
By default, your clipboard will be automatically emptied after 10 seconds, this
timeout can be changed (or disabled) by setting `s:emptyclipboard` in
`pwbunny.vim`.

- `<Leader>u`  
Copy the username of the entry under the cursor (which may still be in a closed
fold); and after a user confirmation, also copy the password (as with
`<Leader>c`)

- `<Leader>C`  
Empty the clipboard.

- `<Leader>p`  
Generate a random password.

- `<Leader>P`  
Generate a random password & insert it at the cursor position.

- `<Leader>s`  
Sort all entries by title (the first line).

- `<Leader>e`  
Show an estimation of the password strength at the cursor position, where 0=
horrible and 4=superb.

- `<Leader>E`  
Show an estimation of all the password strengths that are lower than
`s:min_password_strength`.

PS. By default, Vim maps `<Leader>` to `\`.


Settings
========
- `s:defaultuser`  
Default username to use (default: unset).

- `s:site_from_clipboard`  
Use the clipboard contents as default site; it will try and get the domain part
from an URL (default: 1).

- `s:emptyclipboard = 10`  
Empty the clipboard after this many seconds after calling
`PwbunnyCopyPassword()`, set to 0 to disable (default: 10).

- `s:passwordlength = 15`  
Length of generated passwords (default: 15).

- `s:autosort = 1`  
Sort entries after adding a new one (default: 1).

- `s:min_password_strength = 4`  
Minimal passwords strength, score of 0 to 4 based on a estimation of the actual
crack time. See ‘Password strength checking’ above.

- `s:private = 0`  
Start ‘private mode’ by default (name of site isn’t displayed in the fold text).

A score of 4 is recommended (this is the default), 3 is acceptable, 2 or lower
is strongly discouraged


File format
==========
The file format is simple:

- An entry *must* have at least 3 lines.

- An entry *must* be followed by 1 or more empty lines; except for the last
  entry, where an empty line is *optional*.

- The first line *must* be the title and *must* be present. This line also
  doubles as the domain.

- The second line *must* be the username, and *may* be blank.

- The third line *must* be the password, and *may* be blank.

- An entry *may* have as many lines as desired. This is useful for storing
  notes, answers to ‘security questions’ (which should also be random), and
  other extra data (e.g. SSH fingerprints).


Changelog
=========

Version 1.3, 2016-02-25
-----------------------
- Keep more backups of the password database instead of just one.


Version 1.2, 2015-08-05
-----------------------
- Add `-p` option for 'private mode', this won’t display the site name in the
  fold.


Version 1.1, 2015-02-27
-----------------------
There are many new options, features, and improvements. With thanks to *yggdr*
for some patches; the most important changes are:

- [`cm=blowfish` has been discovered to be insecure][vuln]; warn for this, and
  use `cm=blowfish2`.

- Use `~/.pwbunny/passwords.pwbunny` as the default file; `./passwords.pwbunny`
  is used if it exists.

- `pwbunny.vim` is now used from `/usr/share/pwbunny/pwbunny.vim` if
  `./pwbunny.vim` doesn’t exist.


Version 1.0, 2014-05-10
-----------------------
- Initial release.


TODO
====
- Write some tests (http://usevim.com/2012/10/17/vim-unit-tests/).

- A tool to regenerate passwords, and/or store when they were last changed,
  perhaps also integrate https://datalossdb.org and/or
  http://thepasswordproject.com/leaked_password_lists_and_dictionaries

- Allow settings in `~/`, now you have to modify the script to change settings.

- Prepare for unexpected inquisitions.


Functions
=========
- `PwbunnyMakePassword()`  
Generate a random password (mapped to `<Leader>p`).

- `PwbunnyAddEntry()`  
Add a new entry (mapped to `<Leader>a`).

- `PwbunnyGetSite()`  
Get title/sitename of the entry under the cursor.

- `PwbunnyGetUser()`  
Get username of the entry under the cursor.

- `PwbunnyGetPassword()`  
Get password of the entry under the cursor.

- `PwbunnyGetLine(n)`  
Get line number *n* of the entry under the cursor.

- `PwbunnyCopyPassword()`  
Copy the password of the entry under the cursor (mapped to `<Leader>c`).

- `PwbunnyCopyUserAndPassword()`
Copy the username of the entry under the cursor, and after a while go ahead and
copy the password (mapped to `<Leader>u`).

- `PwbunnyGetEntries()`  
Get a list of all entries as `[start, end]`.

- `PwbunnySort()`  
Sort *all* entries (mapped to `<Leader>s`).

- `PwbunnyEmptyClipboard()`  
Clear the clipboard.

- `PwbunnyCopyToClipboard(str)`  
Copy *str* to the clipboard.

- `PwbunnyGetClipboard()`  
Get contents of clipboard.

- `PwbunnyOpen()`  
Detect is the correct password was entered.

- `PwbunnyFindCopyClose(name)`  
Find an entry by name, copy it to the clipboard, and exit.

- `PwbunnyGoto(site)`  
Try to open `site` in a web browser (this uses `gx`).

- `PwbunnyEstimatePassword(site, user, password)`  
Estimate password strength (mapped to `<Leader>e`).

- `PwbunnyEstimateAllPasswords()`  
Estimate password strength of all passwords (mapped to `<Leader>E`).

- `PwbunnySetPrivate()`  
Set ‘private mode’. The names of the sites isn’t displayed in the fold text.


Alternatives
------------
- [vim-safe](https://github.com/antenore/vim-safe); seems less mature, but has a
  different approach on some things; may be of interest.


[blf]: http://en.wikipedia.org/wiki/Blowfish_(cipher)
[xclip]: http://sourceforge.net/projects/xclip
[xsel]: http://www.vergenet.net/~conrad/software/xsel/
[xcopy]: http://www.chiark.greenend.org.uk/~sgtatham/utils/xcopy.html
[vuln]: https://groups.google.com/d/msg/vim_dev/D8FyRd0EwlE/bkBOo-hzTzoJ
