---
layout: code
title: complete_email.vim
link: complete_email.vim
extra_links: <li><a href="http://www.vim.org/scripts/script.php?script_id=5208">This plugin at www.vim.org</a></li>
---


Allow completion of email addresses so you can use Vim as a basic "address
book".

This is useful when you use Vim to compose emails in a program such as `mutt`. I
have the following settings in my `muttrc`:

	set edit_headers = yes          # Edit the headers of your outgoing messages
	set autoedit = yes              # Go directly to editor after pressing m

After pressing `m` I immediately go to Vim, and can fill out the headers myself:

	From: Martin Tournoij <martin@arp242.net>
	To: 
	Cc: 
	Bcc: 
	Subject: 
	Reply-To: 

I can then use this plugin to quickly fill in the `To:`, `Cc:`, etc. fields.


Basic usage
-----------
- Use `<C-x><C-m>` to complete.
- Use `:AddEmailAddress` to add a new email address.
- Email addresses are stored in `'~/.mutt/address` by default. You can configure
  this by setting `g:complete_email_file`.


File format
-----------
There are 3 fields in the address file. `name`, `email address`, and `extra
info`. The extra info is shown preview window. These fields are separated by the
`0x1e` character. Type `<C-v>x1e` to insert it.


Other scripts
-------------
- [mail.tgz](http://www.vim.org/scripts/script.php?script_id=99) - calls
  external utility (`abook`).
