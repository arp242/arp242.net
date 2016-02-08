---
layout: post
title: "Uninstalling Emacs with apt-get: lessons in interface design"
---

Lessons we can learn from `apt-get`’s spectacuarly surprising behaviour.

I rather like Debian. I also like Ubuntu. It does a lot of things right.
Unfortunately, it also does one thing absolutely horribly wrong, and that is
package management.

`apt-get` is, simply put, one of the worst tools I have ever encountered. This
is hardly a novel observation, but the fuckery I encountered in doing the highly
complex and advanced operation of removing Emacs from my system motivated this
post. It was the straw that broke the camel’s back.

So, lets remove Emacs:

	$ sudo apt-get remove emacs24
	Reading package lists... Done
	Building dependency tree       
	Reading state information... Done
	The following extra packages will be installed:
	  emacs24-lucid xaw3dg
	The following packages will be REMOVED
	  emacs24
	The following NEW packages will be installed
	  emacs24-lucid xaw3dg
	0 to upgrade, 2 to newly install, 1 to remove and 0 not to upgrade.
	Need to get 3,534 kB of archives.
	After this operation, 531 kB of additional disk space will be used.
	Do you want to continue? [Y/n] 

Wait, it wants to install another version of Emacs? Meh. The reason for this is
because *another* package has been “manually installed” and that `emacs24` is
merely an “autoinstalled dependency”. In fact, the [Emacs package][pkg-emacs]
doesn’t really install anything, it just defines these dependencies:

	Depends: emacs24 | emacs24-lucid | emacs24-nox

The `|` means ‘or’, and any one will suffice, removing `emacs24` will trigger
`apt-get` to try and look for alternatives to it.

I know this because I wasted far too much time with `apt-get` fuckery, I find
this behaviour really surprising especially **as there is no message about this
at all**. The “principle of least surprise” is not something `apt-get` does.

Computers are great for automating stuff. But they are not so great at *guessing
intent*. In this case, it guessed my intent wrong.

No really, what’s wrong with this:

	$ sudo apt-get remove emacs24
	WARNING: Package emacs depends on emacs24.
	  Found two alternatives: emacs24-lucid, emacs24-nox.
	  Installing emacs24-lucid.

	The following extra packages will be installed:
	  emacs24-lucid xaw3dg
	The following packages will be REMOVED
	  emacs24

	This will download 3,534 kB and use 531 kB of disk space.
	Do you want to continue? [Y/n] 

- Remove useless `Reading package lists`-cruft. I don’t need to know this.
  Please, include a `--verbose` switch to spit out as much information as
  possible; but for normal day-to-day operation this really isn’t needed.

  Eric S. Raymond called this “[The Rule of Silence][silence]” in his *The Art
  of Unix Programming*:

  > Rule of Silence: When a program has nothing surprising to say, it should say
  > nothing.
  > [..]
  > Well-designed programs treat the user’s attention and concentration as a
  > precious and limited resource, only to be claimed when necessary.

  Perhaps more importantly, useless output distracts from the important
  output—which especially matters when a tool does something surprising (like
  `apt-get`).

- Give a clear warning that `emacs` depends on `emacs24`, and that we’re
  installing `emacs24-lucid` because of that. If you’re going to do something
  different than what the user asked, *then inform why*!

- Re-order the “installed” and “REMOVED” sections; the REMOVED part is far more
  dangerous and surprising, and it’s far more likely the user will see this at
  the end of the output; especially with very long output (see the examples at
  the end of this document).

- Add whitespace, as it adds it legibility. The times of 80x24 terminal
  emulators are long over, and even in primitive terminals you can *scroll*.

- Rewrite the last sentence. Why is it so verbose? There is no need for it to
  take up two lines (concise writing in technical documentation and commandline
  tools is the subject of an upcoming rant).

Of course, there are other things we can do. Personally, I would consider just
removing `emacs` much more logical (after displaying a clear message, of
course), this is what tools like `yum` do.

----------------

Lets move on and try removing `emacs`:

	$ sudo apt-get remove emacs
	Reading package lists... Done
	Building dependency tree       
	Reading state information... Done
	The following packages will be REMOVED
	  emacs
	0 to upgrade, 0 to newly install, 1 to remove and 0 not to upgrade.
	After this operation, 25.6 kB disk space will be freed.
	Do you want to continue? [Y/n] y
	(Reading database ... 364398 files and directories currently installed.)
	Removing emacs (46.1) ...

Okay, that worked. But ... did it remove `emacs24`? Lets see:

	$ dpkg -l | grep ^ii | grep -i emacs
	ii  emacs24                                                     24.5+1-1ubuntu2                                       amd64        GNU Emacs editor (with GTK+ GUI support)
	ii  emacs24-bin-common                                          24.5+1-1ubuntu2                                       amd64        GNU Emacs editor's shared, architecture dependent files
	ii  emacs24-common                                              24.5+1-1ubuntu2                                       all          GNU Emacs editor's shared, architecture independent infrastructure
	ii  emacs24-common-non-dfsg                                     24.4+1-2                                              all          GNU Emacs common non-DFSG items, including the core documentation
	ii  emacsen-common                                              2.0.8                                                 all          Common facilities for all emacsen

Now, this `dpkg` command is a wtf on its own. Why do we need a new tool? Why do
we need two `grep` invocations? Why is the output 200 columns wide (guaranteeing
that it will be wrapped and confusing)? Why can’t I just do `yum list
installed`, `pacman -Ql`, `pkg_info -l`, or something similarly simple? If there
is a simple way to just list all installed packages on Debian system, I have not
been able to figure it out (and [neither have the folks at ask
Ubuntu](http://askubuntu.com/q/17823)).

Removing a package will, of course, not remove its dependencies.  To do this, we
have `apt-get autoremove`.

	autoremove
		autoremove is used to remove packages that were automatically
		installed to satisfy dependencies for other packages and are now no
		longer needed.

But oh boy, is this a dangerous command! I’ve had it remove several *wanted*
packages on more than one occasion. Not installed directly does *not* equal
unwanted; this is why I wanted to remove the `emacs24` package directly.

But lets try it:

	$ sudo apt-get autoremove
	Reading package lists... Done
	Building dependency tree       
	Reading state information... Done
	0 to upgrade, 0 to newly install, 0 to remove and 0 not to upgrade.


I have no idea why this doesn’t work. Lets try and remove the `emacs24` packages
directly; surly a wildcard like `*` will work?

	$ sudo apt-get remove emacs\*
	Reading package lists... Done
	Building dependency tree       
	Reading state information... Done
	Note, selecting 'emacsen-common' for regex 'emacs*'
	Note, selecting 'qml-module-qtqml-statemachine' for regex 'emacs*'
	Note, selecting 'emacs23-bin-common' for regex 'emacs*'
	Note, selecting 'acl2-emacs' for regex 'emacs*'
	Note, selecting 'emacs24-nox' for regex 'emacs*'
	Note, selecting 'emacs-snapshot-gtk' for regex 'emacs*'
	Note, selecting 'emacspeak-espeak-server' for regex 'emacs*'
	Note, selecting 'emacs24-el' for regex 'emacs*'
	Note, selecting 'emacspeak-ss' for regex 'emacs*'
	Note, selecting 'emacs-goodies-el' for regex 'emacs*'
	Note, selecting 'xemacs21-gnome-mule' for regex 'emacs*'
	Note, selecting 'qemacs' for regex 'emacs*'
	Note, selecting 'xemacs21-supportel' for regex 'emacs*'
	Note, selecting 'cxref-emacs' for regex 'emacs*'
	Note, selecting 'xemacs21-gnome-mule-canna-wnn' for regex 'emacs*'
	Note, selecting 'xemacs21-mule' for regex 'emacs*'
	Note, selecting 'trac-includemacro' for regex 'emacs*'
	Note, selecting 'xemacs21-support' for regex 'emacs*'
	Note, selecting 'emacs-intl-fonts' for regex 'emacs*'
	Note, selecting 'xemacs21-bin' for regex 'emacs*'
	Note, selecting 'xemacs21-mule-canna-wnn' for regex 'emacs*'
	Note, selecting 'emacs20' for regex 'emacs*'
	Note, selecting 'emacs-chess' for regex 'emacs*'
	Note, selecting 'emacs21' for regex 'emacs*'
	Note, selecting 'emacs22' for regex 'emacs*'
	Note, selecting 'emacs-snapshot' for regex 'emacs*'
	Note, selecting 'emacs23' for regex 'emacs*'
	Note, selecting 'emacs24' for regex 'emacs*'
	Note, selecting 'emacs-goodies-extra-el' for regex 'emacs*'
	Note, selecting 'emacspeak' for regex 'emacs*'
	Note, selecting 'emacsen' for regex 'emacs*'
	Note, selecting 'emacspeak-dt-tcl' for regex 'emacs*'
	Note, selecting 'emacs23-lucid' for regex 'emacs*'
	Note, selecting 'emacspeak-bs-tcl' for regex 'emacs*'
	Note, selecting 'notmuch-emacs' for regex 'emacs*'
	Note, selecting 'emacs24-common-non-dfsg' for regex 'emacs*'
	Note, selecting 'emacs24-nox-dbg' for regex 'emacs*'
	Note, selecting 'python-ropemacs' for regex 'emacs*'
	Note, selecting 'xemacs21' for regex 'emacs*'
	Note, selecting 'xemacs21-basesupport' for regex 'emacs*'
	Note, selecting 'emacs24-lucid' for regex 'emacs*'
	Note, selecting 'xemacs21-mulesupport-el' for regex 'emacs*'
	Note, selecting 'xemacs' for regex 'emacs*'
	Note, selecting 'maxima-emacs' for regex 'emacs*'
	Note, selecting 'emacs-calfw' for regex 'emacs*'
	Note, selecting 'timemachine' for regex 'emacs*'
	Note, selecting 'emacs24-lucid-dbg' for regex 'emacs*'
	Note, selecting 'xemacs21-gnome-nomule' for regex 'emacs*'
	Note, selecting 'emacs-wiki' for regex 'emacs*'
	Note, selecting 'emacs24-bin-common' for regex 'emacs*'
	Note, selecting 'xemacs21-nomule' for regex 'emacs*'
	Note, selecting 'emacs24-common' for regex 'emacs*'
	Note, selecting 'xemacs21-basesupport-el' for regex 'emacs*'
	Note, selecting 'emacs-calfw-howm' for regex 'emacs*'
	Note, selecting 'xemacs-support' for regex 'emacs*'
	Package 'emacs20' is not installed, so not removed
	Package 'xemacs-widget' is not installed, so not removed
	Package 'xemacs-support' is not installed, so not removed
	Package 'emacs-snapshot-gtk' is not installed, so not removed
	Package 'emacs-snapshot-nonx' is not installed, so not removed
	Package 'emacs' is not installed, so not removed
	Package 'emacs-goodies-el' is not installed, so not removed
	Package 'emacs24-dbg' is not installed, so not removed
	Package 'emacs24-el' is not installed, so not removed
	Package 'emacs24-lucid-dbg' is not installed, so not removed
	Package 'emacs24-nox' is not installed, so not removed
	Package 'emacs24-nox-dbg' is not installed, so not removed
	Package 'acl2-emacs' is not installed, so not removed
	Package 'cxref-emacs' is not installed, so not removed
	Package 'emacs-calfw' is not installed, so not removed
	Package 'emacs-calfw-howm' is not installed, so not removed
	Package 'emacs-intl-fonts' is not installed, so not removed
	Package 'emacs-jabber' is not installed, so not removed
	Package 'emacs-mozc' is not installed, so not removed
	Package 'emacs-mozc-bin' is not installed, so not removed
	Package 'emacs-nox' is not installed, so not removed
	Package 'emacs-window-layout' is not installed, so not removed
	Package 'emacs24-lucid' is not installed, so not removed
	Package 'emacspeak' is not installed, so not removed
	Package 'emacspeak-espeak-server' is not installed, so not removed
	Package 'emacspeak-ss' is not installed, so not removed
	Package 'maxima-emacs' is not installed, so not removed
	Package 'notmuch-emacs' is not installed, so not removed
	Package 'python-ropemacs' is not installed, so not removed
	Package 'qml-module-qtqml-statemachine' is not installed, so not removed
	Package 'supercollider-emacs' is not installed, so not removed
	Package 'timemachine' is not installed, so not removed
	Package 'trac-includemacro' is not installed, so not removed
	Package 'trac-wikitablemacro' is not installed, so not removed
	Package 'xemacs21' is not installed, so not removed
	Package 'xemacs21-basesupport' is not installed, so not removed
	Package 'xemacs21-basesupport-el' is not installed, so not removed
	Package 'xemacs21-bin' is not installed, so not removed
	Package 'xemacs21-gnome-mule' is not installed, so not removed
	Package 'xemacs21-gnome-mule-canna-wnn' is not installed, so not removed
	Package 'xemacs21-gnome-nomule' is not installed, so not removed
	Package 'xemacs21-mule' is not installed, so not removed
	Package 'xemacs21-mule-canna-wnn' is not installed, so not removed
	Package 'xemacs21-mulesupport' is not installed, so not removed
	Package 'xemacs21-mulesupport-el' is not installed, so not removed
	Package 'xemacs21-nomule' is not installed, so not removed
	Package 'xemacs21-support' is not installed, so not removed
	Package 'xemacs21-supportel' is not installed, so not removed
	Some packages could not be installed. This may mean that you have
	requested an impossible situation or if you are using the unstable
	distribution that some required packages have not yet been created
	or been moved out of Incoming.
	The following information may help to resolve the situation:

	The following packages have unmet dependencies.
	apturl : Depends: gir1.2-webkit2-4.0 but it is not going to be installed or
					gir1.2-webkit-3.0 but it is not going to be installed
	E: Error, pkgProblemResolver::Resolve generated breaks, this may be caused by held packages.
	Exit 100

Ugh. wtf?

So it’s not a wildcard but a regexp search on the full string. To get what I had
intended I would have had to use `^emacs` or `^emacs.*`.

- Using regular expressions here is stupid. I have nothing against regexps *as
  such*—I even own *Mastering Regular Expressions*—but this is the wrong tool
  for the wrong job. A simple wildcard pattern would be more than adequate for
  >95% of the use cases and is a lot less likely to bite you. If you need more
  flexibility, then regular expressions are hardly the only way to go, for
  example [Lua patterns][patterns] are a much simpler method which should
  cover the remaining 5% of the use cases. A full implementation is [less than
  700 lines of C code][patterns-code], compared to
  [over](https://github.com/lattera/glibc/blob/a2f34833b1042d5d8eeb263b4cf4caaea138c4ad/posix/regexec.c)
  [10,000](https://github.com/lattera/glibc/blob/a2f34833b1042d5d8eeb263b4cf4caaea138c4ad/posix/regex_internal.c)
  [lines](https://github.com/lattera/glibc/blob/a2f34833b1042d5d8eeb263b4cf4caaea138c4ad/posix/regcomp.c)
  for basic POSIX regular expressions (and lets not even start on Perl
  compatible regular expressions)

- `apt-get` will, apparently, switch to “regexp mode” once it encounters a
  regexp character. This is why `^emacs` works. But this also means that my
  pattern will select things like `timemachine` (as the `*` will make the `s`
  optional, anything with `emac` will match). We should have used `emacs.\*`,
  but this *still* isn’t enough, since this will match anywhere in the string
  (e.g. `notmuch-emacs`), so we need to anchor it to the start: `^emacs.\*`. We
  can lose the `.\*` since its not anchored to the end.  
  I would say, if you *must* use regular expressions for this, *anchor it to the
  start*. This will prevent this sort of unexpected matches, and can be easily
  “undone” with `.*emacs` (this is often called a regexp *match*, rather than
  *search*).

- All in all, this is a classic example of how using regular expressions
  *creates* a problem, rather than *solves* it.

So, aside for the regexp stupidness, why is it also “selecting” packages that
aren’t installed?  And why does it need to tell me what exactly it matches in
such a verbose manner? It’s a lot of lines of mostly useless and redundant
output.

Eventually it errors out on an error relating to ... WebKit ... Which it wants
to install ... I have no idea why.

-------------------------

So, `^emacs24`:

	$ sudo apt-get remove ^emacs24
	Reading package lists... Done
	Building dependency tree       
	Reading state information... Done
	Note, selecting 'emacs24-nox' for regex '^emacs24'
	Note, selecting 'emacs24-el' for regex '^emacs24'
	Note, selecting 'emacs24' for regex '^emacs24'
	Note, selecting 'emacs24-common-non-dfsg' for regex '^emacs24'
	Note, selecting 'emacs24-nox-dbg' for regex '^emacs24'
	Note, selecting 'emacs24-lucid' for regex '^emacs24'
	Note, selecting 'emacs24-lucid-dbg' for regex '^emacs24'
	Note, selecting 'emacs24-bin-common' for regex '^emacs24'
	Note, selecting 'emacs24-common' for regex '^emacs24'
	Note, selecting 'emacs24-dbg' for regex '^emacs24'
	Package 'emacs24-dbg' is not installed, so not removed
	Package 'emacs24-el' is not installed, so not removed
	Package 'emacs24-lucid-dbg' is not installed, so not removed
	Package 'emacs24-nox' is not installed, so not removed
	Package 'emacs24-nox-dbg' is not installed, so not removed
	Package 'emacs24-lucid' is not installed, so not removed
	The following packages will be REMOVED
	  emacs24 emacs24-bin-common emacs24-common emacs24-common-non-dfsg
	0 to upgrade, 0 to newly install, 4 to remove and 0 not to upgrade.
	After this operation, 88.4 MB disk space will be freed.
	Do you want to continue? [Y/n] y
	(Reading database ... 301957 files and directories currently installed.)
	Removing emacs24 (24.5+1-1ubuntu2) ...
	Remove dictionaries-common for emacs24
	remove/dictionaries-common: Purging byte-compiled files for flavour emacs24
	Remove emacsen-common for emacs24
	emacsen-common: Handling removal of emacsen flavor emacs24
	Remove cmake-data for emacs24
	remove/cmake-data: Purging byte-compiled files for emacs24
	Removing emacs24-bin-common (24.5+1-1ubuntu2) ...
	Removing emacs24-common (24.5+1-1ubuntu2) ...
	Removing emacs24-common-non-dfsg (24.4+1-2) ...
	Processing triggers for man-db (2.7.4-1) ...
	Processing triggers for gnome-menus (3.13.3-6ubuntu1) ...
	Processing triggers for bamfdaemon (0.5.2~bzr0+15.10.20150627.1-0ubuntu1) ...
	Rebuilding /usr/share/applications/bamf-2.index...
	Processing triggers for desktop-file-utils (0.22-1ubuntu3) ...
	Processing triggers for mime-support (3.58ubuntu1) ...
	Processing triggers for menu (2.1.47ubuntu1) ...
	Processing triggers for install-info (6.0.0.dfsg.1-3) ...
	Processing triggers for hicolor-icon-theme (0.15-0ubuntu1) ...

And we’re finished ... *finally*!

So, the lessons learned?
------------------------
- **Do** follow the principle of least surprise unless there is a very good
  reason not to.
- **Do** inform the user *why* you’re doing something if it may be surprising
- **Don’t** output useless status messages that mean nothing to most users,
  unless a "debug mode" was specifically asked for.
- **Don’t** use regular expressions unless all other options are inadequate.
- **Do** make sure that it’s clear that regular expressions are being used and
  **do** anchor them to the start by default.

More examples
-------------
Some other examples of similar surprising `apt-get` behaviour:

	$ apt-get remove compiz-gnome 
	Reading package lists... Done
	Building dependency tree       
	Reading state information... Done
	The following extra packages will be installed:
	  compiz-kde compizconfig-backend-kconfig kdelibs5-data libattica0.3 libdlrestrictions1 libkdecore5 libkdeui5
	Suggested packages:
	  hspell
	The following packages will be REMOVED
	  compiz compiz-gnome unity
	The following NEW packages will be installed
	  compiz-kde compizconfig-backend-kconfig kdelibs5-data libattica0.3 libdlrestrictions1 libkdecore5 libkdeui5
	0 to upgrade, 7 to newly install, 3 to remove and 0 not to upgrade.
	Need to get 5,375 kB of archives.
	After this operation, 11.7 MB of additional disk space will be used.
	Do you want to continue [Y/n]?

Here’s another:

	$ apt-get install consolekit:i386

	Reading package lists...
	Building dependency tree...
	Reading state information...
	The following packages were automatically installed and are no longer required:
	  python-mutagen python-mmkeys python-cddb
	Use 'apt-get autoremove' to remove them.
	The following extra packages will be installed:
	  docbook-xml libck-connector0:i386 libpam-ck-connector:i386 libpam0g:i386
	  libpolkit-gobject-1-0:i386 sgml-data synaptic
	Suggested packages:
	  docbook docbook-dsssl docbook-xsl docbook-defguide libpam-doc:i386 perlsgml
	  doc-html-w3 opensp dwww deborphan
	Recommended packages:
	  rarian-compat
	The following packages will be REMOVED
	  acpi-support aptdaemon apturl colord consolekit dell-recovery
	  gnome-bluetooth gnome-control-center gnome-power-manager gnome-system-log
	  gnome-user-share hplip indicator-datetime indicator-power indicator-sound
	  jockey-common jockey-gtk landscape-client-ui-install language-selector-gnome
	  libcanberra-pulse libck-connector0 libnm-gtk0 libpam-ck-connector
	  manage-distro-upgrade nautilus-share network-manager-gnome policykit-1
	  policykit-1-gnome printer-driver-postscript-hp pulseaudio
	  pulseaudio-module-bluetooth pulseaudio-module-gconf pulseaudio-module-x11
	  python-aptdaemon python-aptdaemon.gtk3widgets python-aptdaemon.pkcompat
	  sessioninstaller software-center software-properties-gtk
	  ubuntu-system-service ubuntuone-control-panel-common
	  ubuntuone-control-panel-qt ubuntuone-installer update-manager
	  update-notifier xul-ext-ubufox
	  The following NEW packages will be installed
	  consolekit:i386 docbook-xml libck-connector0:i386 libpam-ck-connector:i386
	  libpam0g:i386 libpolkit-gobject-1-0:i386 sgml-data synaptic
	0 to upgrade, 8 to newly install, 46 to remove and 0 not to upgrade.
	Need to get 3,432 kB of archives.
	After this operation, 20.6 MB disk space will be freed.
	Do you want to continue [Y/n]? 

There are so many things wrong with this output that it hurts (and remember
`yes` is the default, so pressing `Y` here will basically hose the system).

Responses
---------
For some reason, responses like this to criticism of `apt-get` are far too
common:

> Arch user? Rolling releases and bleeding edge are not sane anywhere except the
> desktop (and questionable even there), nor do I have the time to deal with
> multiple package managers, layouts, idiosyncrasies, just to run something
> different on the desktop vs the server, without a damn good reason.

Which is not just a typical [*Tu quoque*](https://en.wikipedia.org/wiki/Tu_quoque),
but also a [Straw man](https://en.wikipedia.org/wiki/Straw_man); as this is not
about release management.

> You can't blame apt for your not bothering to read it's output.

I can blame it for doing surprising things, not telling me why, and providing
messy output which obscures important information.

> Use `aptitude`

No.

> And historically, rpm was a piece of crap that broke all the time. There used
> to be only two real options for comprehensive package management -
> apt and rpm, and apt was vastly superior.

Maybe, but it’s another *tu quoque*, and hasn’t been the case for at least
fifteen years.


[silence]: http://www.catb.org/~esr/writings/taoup/html/ch01s06.html#id2878450
[pkg-emacs]: https://packages.debian.org/stable/editors/emacs
[patterns]: http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man7/patterns.7
[patterns-code]: http://cvsweb.openbsd.org/cgi-bin/cvsweb/~checkout~/src/usr.sbin/httpd/patterns.c?rev=1.4&content-type=text/plain
