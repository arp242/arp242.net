---
layout: post
title: Minimal Apache configuration for subversion
excerpt: This is a minimal Apache configuration file for use with subversion access with SSL.
categories: programming-and-such
---

If you want to use subversion over HTTP you have little choice but to use
Apache.

This is a “minimal” Apache configuration file for use with subversion access
with SSL. In many cases, I feel that the best approach is to “Start simple,
then add complexity”.  
The default Apache configuration file is anything but “start simple”, it’s
much much larger than needed, especially if you only want to use it for
subversion access.

httpd.conf
----------
Note: these directives are written for Apache 2.2 on FreeBSD. They *may*
or **may not** work for other Apache versions. It *should* work for
other operating systems. On Linux you will probably want to change the
`libexec/apache22` to something else (for example `modules/` on Red Hat
based systems).

	# Modules to load
	LoadModule alias_module libexec/apache22/mod_alias.so
	LoadModule auth_basic_module libexec/apache22/mod_auth_basic.so
	LoadModule auth_digest_module libexec/apache22/mod_auth_digest.so
	LoadModule authn_file_module libexec/apache22/mod_authn_file.so
	LoadModule authz_default_module libexec/apache22/mod_authz_default.so
	LoadModule authz_host_module libexec/apache22/mod_authz_host.so
	LoadModule authz_user_module libexec/apache22/mod_authz_user.so
	LoadModule dav_module libexec/apache22/mod_dav.so
	LoadModule deflate_module libexec/apache22/mod_deflate.so
	LoadModule ssl_module libexec/apache22/mod_ssl.so

	# SVN modules
	LoadModule dav_svn_module libexec/apache22/mod_dav_svn.so
	LoadModule authz_svn_module libexec/apache22/mod_authz_svn.so

	# ServerRoot: The top of the directory tree under which the server's
	# configuration, error, and log files are kept
	# Do not add a slash at the end of the directory path
	ServerRoot "/usr/local"

	# Only listen on one IP
	Listen 94.142.244.51:443

	# Make sure the Apache process can write to your SVN dir if you want to allow
	# files to be commited
	User apache
	Group apache

	# We do not want to serve anything other than svn
	# NOTE:
	# Some Linux systems seem to store files in /var/empty/ (Which part of "empty"
	# is difficult to understand is something I cannot even begin to phantom)
	# I recommend making a "/var/reallyempty/" and setting the immutable flag with
	# chattr(1)
	DocumentRoot "/var/empty/"

	# Not a busy server, so don't fork too many server
	StartServers 2
	MinSpareServers 1
	MaxSpareServers 2

	# The location of the error log file
	ErrorLog "/var/log/httpd-error.log"

	# Control the number of messages logged to the error_log
	# Possible values: debug, info, notice, warn, error, crit, alert, emerg
	LogLevel warn

	# The default MIME type the server will use for a document
	DefaultType text/plain

	# Enable SSL
	SSLEngine on

	# PEM encoded certificate, key is also loaded from this file
	SSLCertificateFile "/usr/local/etc/ssl/svn.pem"

	<Location /svn>
			# This is a SVN dir
			DAV svn
			SVNParentPath /home/svn

			# Only allow from authenticated users
			AuthType Basic

			AuthName "Subversion repository"
			AuthUserFile /usr/local/etc/svn-auth-file
			Require valid-user

			# Allow from everyone
			Order allow,deny
			Allow from all

			# Use compression
			SetOutputFilter DEFLATE
			SetInputFilter DEFLATE
	</Location>


The default configuration:

	[/usr/local/etc/apache22]# wc -l httpd.conf extra/httpd-ssl.conf
		481 httpd.conf
		231 extra/httpd-ssl.conf
		712 total
	[/usr/local/etc/apache22]# grep -Ev '(^#|^$)' httpd.conf extra/httpd-ssl.conf | wc -l
		256


Compared to the above file:

	[/usr/local/etc/apache22]# wc -l httpd.conf
		72 httpd.conf
	[/usr/local/etc/apache22]# grep -Ev '(^#|^$)' httpd.conf | wc -l
		41


Additional setup
----------------
You can generate a basic self-signed SSL certificate with:
	$ openssl req -new -x509 -keyout svn.pem -out svn.pem -days 365 -nodes


When OpenSSL asks for your name, enter the server’s hostname, not your name.

It is recommended you chown it to the user you run the Apache server as
(`apache` in my case) and chmod the file to `400`.

The `AuthUserFile` `/usr/local/etc/svn-auth-file` can be created/modified with the `htpasswd` command.

	$ touch /usr/local/etc/svn-auth-file
	$ htpasswd -s /usr/local/etc/svn-auth-file lovecraft dunwich


Further reading
---------------
- [svnbook chapter 6: httpd, the Apache HTTP Server](http://svnbook.red-bean.com/nightly/en/svn.serverconfig.httpd.html)
- [Official Apache documentation](http://httpd.apache.org/docs/2.2/)
