---
layout: code
title: "rhttp"
link: "rhttp"
last_version: "master"
redirect: "https://github.com/Carpetsmoker/rhttp"
---

rhttp is a Go package to make returning from HTTP handlers a bit easier.

Here's a pretty standard endpoint to handle a form request:

	http.HandleFunc("/bar", func(w http.ResponseWriter, r *http.Request) {
		r.ParseForm()

		var data Data
		err := formam.Decode(r.Form, &data)
		if err != nil {
			http.Error(w, err.Error(), StatusInternalServerError)
			return
		}

		d, err := getData()
		if err != nil {
			http.Error(w, err.Error(), StatusInternalServerError)
			return
		}

		_, _ = fmt.Fprintf(w, "Hello, %s", d)
	})

- fmt.Fprintf and w.Write() need "error check".
- http.Error() takes only a string (losing other information), and still need
  extra `return` line.
- Many other cases of duplicated content, such as HTTP redirects, setting
  Content-Type header, etc.

Enter `rhttp.Wrap()`:

	http.HandleFunc("/bar", rhttp.Wrap(func(w http.ResponseWriter, r *http.Request) error {
		r.ParseForm()

		var data Data
		err := formam.Decode(r.Form, &data)
		if err != nil {
			return err
		}

		d, err := getData()
		if err != nil {
			return err
		}

		return rhttp.String("Hello, %s")
	}))


The handler function signature is similar, except for the `error` return value.
The r in rhttp is for "return".

This is the same pattern as [echo](https://github.com/labstack/echo) uses, which
I rather like. There are some other parts of echo I don't need/like, so I made a
small library to support this.

Supported packages:

- http://github.com/teamwork/guru
- http://github.com/pkg/errors
