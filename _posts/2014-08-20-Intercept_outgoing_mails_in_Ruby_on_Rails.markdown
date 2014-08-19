---
layout: post
title: Intercept outgoing mails in Ruby on Rails
---

A simple way to this, which just works™


There are already a bunch of solutions for this; including the
[post\_office][po] gem by my coworker, but this is the simple UNIX-y approach
for us simple UNIX-y folks.

We take advantage of `delivery_method = :sendmail`, this effective just pipes an
email to a binary; this is *assumed* to be `sendmail`, but it can be anything,
really;


Append to mbox file
-------------------
This is similar to setting `delivery_method = :file`, except that you can read
the mails with `$any` mail client, so you can check formatting, attachments,
etc.

`config/environments/development.rb`

	YourApp::Application.configure do
		# [...]
		config.action_mailer.delivery_method = :sendmail
		config.action_mailer.sendmail_settings = {
			location: "#{Rails.root}/script/fake-sendmail",
			arguments: "'#{Rails.root}/tmp/mail.mbox'",
		}
	end

`script/fake-sendmail`

	#!/bin/sh
	echo "\nFrom FAKE-SENDMAIL $(date)" >> "$1"
	cat /dev/stdin >> "$1"


You can reading the mbox file from the commandline with `mail -f tmp/mail.mbox`
or `mutt -f tmp/mail.mbox`.

Most email clients should be able to mbox files one way or another; although it
seems to be somewhat complicated for Thunderbird:

1. Exit Thunderbird
2. `cd ~/.thunderbird/$profile_name/Mail/Local Folders/`
3. `ln -s ~/code/yourproject/tmp/mail.mbox` your-folder-name
4. Restart Thunderbird; you should now have the mbox file in *‘Local Folders’*

See also [this page](http://bahut.alma.ch/2010/01/open-mbox-file-in-thunderbird.html).


Forward to another email address
--------------------------------
This will just forward all mails to another email address. Simple.

`config/environments/development.rb`

	YourApp::Application.configure do
		# [...]
		config.action_mailer.delivery_method = :sendmail
		config.action_mailer.sendmail_settings = {
			location: "#{Rails.root}/script/fake-sendmail",
			arguments: 'martin+rails@arp242.net',
		}
	end

`script/fake-sendmail`

	#!/bin/sh
	sendmail -if fake_sendmail@example.com "$1" < /dev/stdin


[po]: https://github.com/bluerail/post_office
