---
title: Intercept outgoing mails in Ruby on Rails
date: 2014-08-20
tags: ['Ruby', 'Ruby on Rails', 'Email']
---

There already are a bunch of solutions for this; including the
[post\_office][po] gem by my co-worker, but this is the simple Unix-y approach
for us simple Unix-y folks.

We take advantage of `delivery_method = :sendmail`, this pipes an email to
something executable; this is *assumed* to be `sendmail`, but it can be
anything.

Append to mbox file
-------------------

This is similar to setting `delivery_method = :file`, except that you can read
the mails with `$any` mail client, so you can check formatting, attachments,
etc.

`config/environments/development.rb`:

    YourApp::Application.configure do
        # [...]
        config.action_mailer.delivery_method = :sendmail
        config.action_mailer.sendmail_settings = {
            location: "#{Rails.root}/script/fake-sendmail",
            arguments: "'#{Rails.root}/tmp/mail.mbox'",
        }
    end

`script/fake-sendmail` (don’t forget to make this executable):

    #!/bin/sh
    echo "From FAKE-SENDMAIL $(date)" >> "$1"
    cat /dev/stdin >> "$1"
    echo >> "$1"

You can read the mbox file from the commandline with `mail -f tmp/mail.mbox` or
`mutt -f tmp/mail.mbox`.

Most email clients should be able to read mbox files one way or other;
although it requires some hackery for Thunderbird:

1. Exit Thunderbird
2. `cd ~/.thunderbird/$profile_name/Mail/Local Folders/`
3. `ln -s ~/code/yourproject/tmp/mail.mbox your-folder-name`
4. Restart Thunderbird; you should now have the mbox file in *‘Local Folders’*

See also [this page](http://bahut.alma.ch/2010/01/open-mbox-file-in-thunderbird.html).

Forward to another email address
--------------------------------

This will only forward all mails to another email address.

`config/environments/development.rb`:

    YourApp::Application.configure do
        # [...]
        config.action_mailer.delivery_method = :sendmail
        config.action_mailer.sendmail_settings = {
            location: "#{Rails.root}/script/fake-sendmail",
            arguments: 'martin+rails@arp242.net',
        }
    end

`script/fake-sendmail` (don’t forget to make this executable):

    #!/bin/sh
    sendmail -if fake_sendmail@example.com "$1" < /dev/stdin

[po]: https://github.com/bluerail/post_office
